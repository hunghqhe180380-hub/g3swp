package controller.assignment;

import dal.AssignmentAttemptDAO;
import dal.AssignmentAnswerDAO;
import dal.AssignmentDAO;
import dal.AssignmentQuestionDAO;
import dal.DBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import model.Assignment;
import model.AssignmentQuestion;
import model.User;

/**
 * Controller for taking an assignment
 * GET  /assignment/take             - show questions (NO attempt created)
 * POST /assignment/finish           - create attempt + save all answers + auto-grade
 * POST /assignment/force-submit-violated - create attempt with status=Violated
 */
public class TakeAssignmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String assignmentIdStr = request.getParameter("assignmentId");
        int assignmentId = Integer.parseInt(assignmentIdStr);

        // Get user from session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get assignment info
        AssignmentDAO assignmentDao = new AssignmentDAO();
        Assignment assignment = assignmentDao.getAssignmentById(assignmentId);

        if (assignment == null) {
            String classIdParam = request.getParameter("classId");
            response.sendRedirect(request.getContextPath() + "/assignment/view/list-assignment"
                    + (classIdParam != null ? "?classId=" + classIdParam : ""));
            return;
        }

        int classId = assignment.getClassId();

        // Load questions with choices (NO attempt created yet - only on finish)
        AssignmentQuestionDAO questionDao = new AssignmentQuestionDAO();
        List<AssignmentQuestion> questions = questionDao.getQuestionsByAssignmentId(assignmentIdStr);

        // Calculate due time from NOW
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime dueAt = now.plusMinutes(assignment.getDurationMinutes());
        String dueIso = dueAt.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        // Pass directly to JSP
        request.setAttribute("assignment", assignment);
        request.setAttribute("questions", questions);
        request.setAttribute("dueIso", dueIso);
        request.setAttribute("currentIndex", 0);
        request.setAttribute("classId", classId);

        request.getRequestDispatcher("/view/assignment/take-assignment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Determine action from parameter or URI
        String action = request.getParameter("action");
        if (action == null) {
            String uri = request.getRequestURI();
            if (uri.contains("/finish")) {
                action = "finish";
            } else if (uri.contains("/force-submit")) {
                action = "force-submit-violated";
            }
        }

        try {
            if ("finish".equals(action)) {
                handleFinish(request, response);
            } else if ("force-submit-violated".equals(action)) {
                handleForceSubmitViolated(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/assignment/view/list-assignment?classId=" + request.getParameter("classId"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/assignment/view/list-assignment?classId=" + request.getParameter("classId"));
        }
    }

    /**
     * Handle finish/submit request.
     * 1. Create attempt in AssignmentAttempts (Status=2 Submitted)
     * 2. Insert all answers into AssignmentAnswers
     * 3. Auto-grade MCQ (check IsCorrect from AssignmentChoices)
     * 4. Calculate AutoScore
     * 5. Set RequiresManualGrading = 1 if has essay, 0 if pure MCQ
     * 6. If pure MCQ: FinalScore = AutoScore
     */
    private void handleFinish(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String assignmentIdStr = request.getParameter("assignmentId");
        int assignmentId = Integer.parseInt(assignmentIdStr);

        // Get assignment for duration
        AssignmentDAO assignmentDao = new AssignmentDAO();
        Assignment assignment = assignmentDao.getAssignmentById(assignmentId);
        if (assignment == null) {
            response.sendRedirect(request.getContextPath() + "/assignment/view/list-assignment?classId=" + request.getParameter("classId"));
            return;
        }

        int classId = assignment.getClassId();

        // Get attempt count for this user/assignment
        AssignmentAttemptDAO attemptDao = new AssignmentAttemptDAO();
        int attemptCount = attemptDao.getAttemptCount(assignmentId, user.getUserID());

        // 1. Create attempt (Status = 2 Submitted since we're submitting now)
        int attemptId = attemptDao.createAttempt(assignmentId, user.getUserID(), attemptCount + 1,
                assignment.getDurationMinutes(), 2); // status 2 = Submitted

        if (attemptId <= 0) {
            response.sendRedirect(request.getContextPath() + "/assignment/view/list-assignment?classId=" + classId);
            return;
        }

        // 2. Load questions to get answers
        AssignmentQuestionDAO questionDao = new AssignmentQuestionDAO();
        List<AssignmentQuestion> questions = questionDao.getQuestionsByAssignmentId(assignmentIdStr);

        AssignmentAnswerDAO answerDao = new AssignmentAnswerDAO();
        boolean hasEssay = false;
        double mcqScore = 0;
        double mcqMax = 0;
        double essayMax = 0;

        for (AssignmentQuestion q : questions) {
            int qId = q.getId();
            String qType = q.getType(); // "1" = SCQ, "2" = MCQ, "3" = Essay

            if ("1".equals(qType)) {
                // SCQ - single correct answer
                mcqMax += q.getPoints();
                String selectedChoiceIdStr = request.getParameter("q-" + qId);
                boolean isCorrect = false;

                if (selectedChoiceIdStr != null && !selectedChoiceIdStr.isEmpty()) {
                    int selectedChoiceId = Integer.parseInt(selectedChoiceIdStr);

                    List<model.AssignmentChoice> choices = q.getListAssignmentChoice();
                    if (choices != null) {
                        for (model.AssignmentChoice c : choices) {
                            if (c.getId() == selectedChoiceId && c.isIsCorrect()) {
                                isCorrect = true;
                                mcqScore += q.getPoints();
                                break;
                            }
                        }
                    }
                }

                answerDao.saveAnswer(attemptId, qId,
                        selectedChoiceIdStr != null && !selectedChoiceIdStr.isEmpty()
                            ? Integer.parseInt(selectedChoiceIdStr) : null,
                        null, isCorrect);

            } else if ("2".equals(qType)) {
                // MCQ - multiple correct answers
                mcqMax += q.getPoints();
                String[] selectedIds = request.getParameterValues("q-" + qId);
                boolean allCorrect = false;

                if (selectedIds != null && selectedIds.length > 0) {
                    List<model.AssignmentChoice> choices = q.getListAssignmentChoice();
                    List<model.AssignmentChoice> correctChoices = choices.stream()
                            .filter(model.AssignmentChoice::isIsCorrect).toList();

                    if (selectedIds.length == correctChoices.size()) {
                        boolean allSelectedCorrect = true;
                        for (String sid : selectedIds) {
                            int cid = Integer.parseInt(sid);
                            boolean found = false;
                            for (model.AssignmentChoice c : correctChoices) {
                                if (c.getId() == cid) { found = true; break; }
                            }
                            if (!found) { allSelectedCorrect = false; break; }
                        }
                        allCorrect = allSelectedCorrect;
                    }
                    if (allCorrect) mcqScore += q.getPoints();
                }

                // Save multiple answers as comma-separated IDs in content field
                String content = (selectedIds != null) ? String.join(",", selectedIds) : null;
                answerDao.saveAnswer(attemptId, qId, null, content, allCorrect);

            } else {
                // Essay (type "3")
                hasEssay = true;
                essayMax += q.getPoints();
                String textAnswer = request.getParameter("essay-" + qId);

                answerDao.saveAnswer(attemptId, qId, null, textAnswer, null);
            }
        }

        // 3. Update attempt with scores
        double totalMax = mcqMax + essayMax;
        Double finalScore = hasEssay ? null : mcqScore;

        attemptDao.updateAttemptScores(attemptId, mcqScore, totalMax, hasEssay, finalScore);

        // Redirect back
        response.sendRedirect(request.getContextPath() + "/assignment/view/list-assignment?classId=" + classId);
    }

    /**
     * Handle force submit (anti-cheat violation)
     */
    private void handleForceSubmitViolated(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String assignmentIdStr = request.getParameter("assignmentId");
        int assignmentId = Integer.parseInt(assignmentIdStr);

        AssignmentDAO assignmentDao = new AssignmentDAO();
        Assignment assignment = assignmentDao.getAssignmentById(assignmentId);

        // Create attempt with status = 5 (Violated)
        AssignmentAttemptDAO attemptDao = new AssignmentAttemptDAO();
        int attemptCount = attemptDao.getAttemptCount(assignmentId, user.getUserID());
        int attemptId = attemptDao.createAttempt(assignmentId, user.getUserID(), attemptCount + 1,
                assignment != null ? assignment.getDurationMinutes() : 30, 5); // status 5 = Violated

        int classId = assignment != null ? assignment.getClassId() : 0;
        response.sendRedirect(request.getContextPath() + "/assignment/view/list-assignment?classId=" + classId);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
