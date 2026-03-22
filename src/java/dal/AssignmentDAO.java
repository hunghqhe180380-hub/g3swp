package dal;

import java.sql.*;
import java.sql.ResultSet;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.SubmissionListItem;
import model.Assignment;
import model.GradeAttemptVM;
import model.GradeEssayItem;
import model.GradeEssayItemVM;
import model.GradeMCQChoice;
import model.GradeMCQQuestion;
import model.GradeMcqItem;
import model.McqChoice;

/**
 * * * @author FPT
 */
public class AssignmentDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public List<Assignment> getListAssignmentByClassId(String search, String classId) {
        List<Assignment> listAssignment = new ArrayList<>();

        try {
            String sql = "SELECT Id, Title, Description, Type, DurationMinutes, MaxAttempts, "
                    + "ClassId, OpenAt, CloseAt, CreatedAt, CreatedById "
                    + "FROM Assignments WHERE ClassId = ?";
            if (search != null && !search.trim().isEmpty()) {
                sql += " AND LOWER(Title) LIKE ?";
            }
            statement = connection.prepareStatement(sql);
            statement.setString(1, classId);
            if (search != null && !search.trim().isEmpty()) {
                statement.setString(2, "%" + search.toLowerCase() + "%");
            }

            resultSet = statement.executeQuery();

            while (resultSet.next()) {

                Assignment a = new Assignment(
                        resultSet.getInt("Id"),
                        resultSet.getString("Title"),
                        resultSet.getString("Description"),
                        resultSet.getInt("Type"),
                        resultSet.getInt("DurationMinutes"),
                        resultSet.getInt("MaxAttempts"),
                        resultSet.getInt("ClassId"),
                        resultSet.getTimestamp("OpenAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getTimestamp("CloseAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getString("CreatedById")
                );

                listAssignment.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return listAssignment;
    }

    //get list submissions by classId
    public List<SubmissionListItem> getSubmissionsByClass(int classId) {
        List<SubmissionListItem> list = new ArrayList<>();
        try {
            String sql = "SELECT at.Id AttemptId, "
                    + "at.AttemptNumber, at.UserId,"
                    + " u.FullName, u.Email, at.StartedAt,"
                    + " at.SubmittedAt, at.Status, at.AutoScore,"
                    + " at.FinalScore, at.RequiresManualGrading FROM AssignmentAttempts at "
                    + "JOIN Assignments a ON at.AssignmentId = a.Id JOIN Users u ON at.UserId = u.Id "
                    + "WHERE a.ClassId = ? ORDER BY at.SubmittedAt DESC ";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, classId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                SubmissionListItem s = new SubmissionListItem();
                s.setAttemptId(resultSet.getInt("AttemptId"));
                s.setAttemptNumber(resultSet.getInt("AttemptNumber"));
                s.setStudentId(resultSet.getString("UserId"));
                s.setStudentName(resultSet.getString("FullName"));
                s.setStudentEmail(resultSet.getString("Email"));
                s.setStartedAt(resultSet.getTimestamp("StartedAt").toLocalDateTime());
                if (resultSet.getTimestamp("SubmittedAt") != null) {
                    s.setSubmittedAt(resultSet.getTimestamp("SubmittedAt").toLocalDateTime());
                }
                s.setStatus(resultSet.getString("Status"));
                s.setMcqScore(resultSet.getDouble("AutoScore"));
                s.setFinalScore(resultSet.getDouble("FinalScore"));
                s.setRequiresManual(resultSet.getBoolean("RequiresManualGrading"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //get assignment by ID
    public Assignment getAssignmentById(int id) {
        try {
            String sql = "SELECT Id, Title, Description, Type, DurationMinutes, MaxAttempts, "
                    + "ClassId, OpenAt, CloseAt, CreatedAt, CreatedById "
                    + "FROM Assignments WHERE Id = ?";

            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return new Assignment(
                        resultSet.getInt("Id"),
                        resultSet.getString("Title"),
                        resultSet.getString("Description"),
                        resultSet.getInt("Type"),
                        resultSet.getInt("DurationMinutes"),
                        resultSet.getInt("MaxAttempts"),
                        resultSet.getInt("ClassId"),
                        resultSet.getTimestamp("OpenAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getTimestamp("CloseAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getString("CreatedById")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //create assignment
    public void createAssignment(Assignment a) {

        String sql = "INSERT INTO Assignments (Title,Description,Type,DurationMinutes,"
                + "MaxAttempts,ClassId,OpenAt,CloseAt,CreatedAt,CreatedById)"
                + " VALUES (?,?,?,?,?,?,?,?,GETDATE(),?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setObject(1, a.getTitle());
            st.setObject(2, a.getDescription());
            st.setObject(3, a.getType());
            st.setObject(4, a.getDurationMinutes());
            st.setObject(5, a.getMaxAttempts());
            st.setObject(6, a.getClassId());
            java.sql.Timestamp openAt = null;
            java.sql.Timestamp closeAt = null;

            if (a.getOpenAt() != null && !a.getOpenAt().isEmpty()) {
                openAt = java.sql.Timestamp.valueOf(
                        a.getOpenAt().replace("T", " ") + ":00"
                );
            }

            if (a.getCloseAt() != null && !a.getCloseAt().isEmpty()) {
                closeAt = java.sql.Timestamp.valueOf(
                        a.getCloseAt().replace("T", " ") + ":00"
                );
            }

            st.setTimestamp(7, openAt);
            st.setTimestamp(8, closeAt);;
            st.setObject(9, a.getCreatedById());

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public GradeAttemptVM getAttemptDetail(int attemptId) {
        GradeAttemptVM vm = new GradeAttemptVM();

        // Sử dụng LinkedHashMap để giữ đúng thứ tự câu hỏi từ DB
        Map<Integer, GradeMcqItem> mcqMap = new LinkedHashMap<>();
        List<GradeEssayItem> essays = new ArrayList<>();

        String sql = """
        SELECT 
                     a.Title AS AssignmentTitle, 
                         u.FullName, u.Email,a.ClassId,
            at.Id AS AttemptId, at.AttemptNumber, at.UserId, at.StartedAt, 
            at.SubmittedAt, at.Status, at.AutoScore, at.FinalScore, at.AssignmentId,
            q.Id AS QuestionId, q.Prompt, q.Type, q.Points,
            c.Id AS ChoiceId, c.Text AS ChoiceText, c.IsCorrect,
            ans.SelectedChoiceId, ans.TextAnswer, ans.TeacherComment, ans.PointsAwarded
        FROM AssignmentAttempts at
        JOIN AssignmentQuestions q ON q.AssignmentId = at.AssignmentId
        LEFT JOIN AssignmentChoices c ON c.QuestionId = q.Id
        LEFT JOIN AssignmentAnswers ans ON ans.AttemptId = at.Id AND ans.QuestionId = q.Id
                     JOIN Assignments a ON at.AssignmentId = a.Id
                     JOIN Users u ON at.UserId = u.Id
        WHERE at.Id = ?
        ORDER BY q.[Order], c.[Order]
    """;

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, attemptId);
            try (ResultSet resultSet = statement.executeQuery()) {
                boolean isFirstRow = true;
                while (resultSet.next()) {
                    if (isFirstRow) {
                        vm.setAssignmentTitle(resultSet.getString("AssignmentTitle")); // Cần cột này từ SQL JOIN
                        vm.setStudentName(resultSet.getString("FullName")); // Cần cột này từ SQL JOIN
                        vm.setStudentEmail(resultSet.getString("Email"));
                        vm.setClassId(resultSet.getInt("ClassId"));

                        vm.setAttemptId(resultSet.getInt("AttemptId"));
                        vm.setAssignmentId(resultSet.getInt("AssignmentId"));
                        vm.setAttemptNumber(resultSet.getInt("AttemptNumber"));
                        vm.setStudentId(resultSet.getString("UserId"));
                        vm.setStatus(resultSet.getString("Status"));
                        vm.setMcqScore(resultSet.getDouble("AutoScore"));
                        if (resultSet.getTimestamp("StartedAt") != null) {
                            vm.setStartedAt(resultSet.getTimestamp("StartedAt").toLocalDateTime());
                        }
                        if (resultSet.getTimestamp("SubmittedAt") != null) {
                            vm.setSubmittedAt(resultSet.getTimestamp("SubmittedAt").toLocalDateTime());
                        }
                        isFirstRow = false;
                    }

                    int qId = resultSet.getInt("QuestionId");
                    if (qId == 0) {
                        continue;
                    }
                    String type = resultSet.getString("Type");

                    // Xử lý MCQ
                    if ("2".equalsIgnoreCase(type)) {
                        GradeMcqItem q = mcqMap.get(qId);
                        if (q == null) {
                            q = new GradeMcqItem();
                            q.setQuestionId(qId);
                            q.setPrompt(resultSet.getString("Prompt"));
                            q.setPoints(resultSet.getDouble("Points"));
                            q.setChoices(new ArrayList<>());
                            mcqMap.put(qId, q);
                        }

                        // Sửa đoạn này trong AssignmentDAO
                        int choiceId = resultSet.getInt("ChoiceId");
                        if (choiceId > 0) {
                            // Đổi GradeMCQChoice thành McqChoice cho khớp với List trong GradeMcqItem
                            McqChoice c = new McqChoice();
                            c.setChoiceId(choiceId);
                            c.setContent(resultSet.getString("ChoiceText"));
                            c.setIsCorrect(resultSet.getBoolean("IsCorrect"));

                            int selectedId = resultSet.getInt("SelectedChoiceId");
                            c.setIsSelected(selectedId == choiceId);

                            // Gán CSS (Nhớ thêm field cssClass vào file McqChoice.java nhé)
                            if (c.isIsSelected() && c.isIsCorrect()) {
                                c.setCssClass("choice-correct");
                            } else if (c.isIsSelected() && !c.isIsCorrect()) {
                                c.setCssClass("choice-wrong");
                            } else if (!c.isIsSelected() && c.isIsCorrect()) {
                                c.setCssClass("choice-correct-unselected");
                            }

                            q.getChoices().add(c); // Bây giờ sẽ không còn lỗi nữa
                        }
                    }

                    // Xử lý Essay
                    if ("1".equalsIgnoreCase(type)) {
                        if (essays.stream().noneMatch(e -> e.getQuestionId() == qId)) {
                            GradeEssayItem e = new GradeEssayItem();
                            e.setQuestionId(qId);
                            e.setPrompt(resultSet.getString("Prompt"));
                            e.setMaxPoints(resultSet.getDouble("Points"));
                            e.setStudentAnswer(resultSet.getString("TextAnswer"));
                            Object p = resultSet.getObject("PointsAwarded");
                            e.setScore(p != null ? (Double) p : 0.0);
                            e.setComment(resultSet.getString("TeacherComment"));
                            essays.add(e);
                        }
                    }
                }
            }

            vm.setMcqs(new ArrayList<>(mcqMap.values()));
            vm.setEssays(essays);

            // Tính điểm Max để tránh lỗi chia cho 0 ở JSP
            double mMax = vm.getMcqs().stream().mapToDouble(GradeMcqItem::getPoints).sum();
            double eMax = essays.stream().mapToDouble(GradeEssayItem::getMaxPoints).sum();
            vm.setMcqMax(mMax);
            vm.setEssayMax(eMax);
            vm.setFinalMax(mMax + eMax);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return vm;
    }

    public static void main(String[] args) {
        AssignmentDAO d = new AssignmentDAO();
        System.out.println(d.getAttemptDetail(1044));
    }

    public void updateEssayScore(int attemptId, int questionId, double score, String comment) {
        try {
            String sql = """
            UPDATE AssignmentAnswers
            SET PointsAwarded = ?, TeacherComment = ?
            WHERE AttemptId = ? AND QuestionId = ?
        """;

            statement = connection.prepareStatement(sql);
            statement.setDouble(1, score);
            statement.setString(2, comment);
            statement.setInt(3, attemptId);
            statement.setInt(4, questionId);

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateFinalScore(int attemptId, double finalScore) {
        try {
            String sql = """
            UPDATE AssignmentAttempts
            SET FinalScore = ?
            WHERE Id = ?
        """;

            statement = connection.prepareStatement(sql);
            statement.setDouble(1, finalScore);
            statement.setInt(2, attemptId);

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(int attemptId, String status) {
        try {
            String sql = """
            UPDATE AssignmentAttempts
            SET Status = ?
            WHERE Id = ?
        """;

            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, attemptId);

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public GradeAttemptVM getGradeAttemptById(int attemptId) {
        GradeAttemptVM vm = new GradeAttemptVM();

        try {
            String sql = """
            SELECT at.Id, at.AttemptNumber, at.UserId,
                   u.FullName, u.Email,
                   at.StartedAt, at.SubmittedAt,
                   at.AutoScore, at.FinalScore
            FROM AssignmentAttempts at
            JOIN Users u ON at.UserId = u.Id
            WHERE at.Id = ?
        """;

            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                vm.setAttemptId(attemptId);
                vm.setAttemptNumber(resultSet.getInt("AttemptNumber"));
                vm.setStudentId(resultSet.getString("UserId"));
                vm.setStudentName(resultSet.getString("FullName"));
                vm.setStudentEmail(resultSet.getString("Email"));

                vm.setMcqScore(resultSet.getDouble("AutoScore"));
                vm.setCurrentFinalScore(resultSet.getDouble("FinalScore"));
            }

            // 👉 load essay
            vm.setEssays(getEssayByAttempt(attemptId));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return vm;
    }

    public List<GradeEssayItem> getEssayByAttempt(int attemptId) {
        List<GradeEssayItem> list = new ArrayList<>();

        try {
            String sql = """
            SELECT q.Id, q.Prompt, q.Points,
                   a.TextAnswer, a.PointsAwarded, a.TeacherComment
            FROM AssignmentQuestions q
            LEFT JOIN AssignmentAnswers a
                 ON q.Id = a.QuestionId AND a.AttemptId = ?
            WHERE q.Type = 'Essay'
        """;

            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                GradeEssayItem e = new GradeEssayItem();

                e.setQuestionId(resultSet.getInt("Id"));
                e.setPrompt(resultSet.getString("Prompt"));
                e.setMaxPoints(resultSet.getDouble("Points"));
                e.setStudentAnswer(resultSet.getString("TextAnswer"));
                e.setScore(resultSet.getObject("PointsAwarded") != null
                        ? resultSet.getDouble("PointsAwarded") : null);
                e.setComment(resultSet.getString("TeacherComment"));

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void saveEssayGrades(int attemptId, String[] qIds, String[] scores, String[] comments) {

        try {
            String sql = """
            UPDATE AssignmentAnswers
            SET PointsAwarded = ?, TeacherComment = ?
            WHERE AttemptId = ? AND QuestionId = ?
        """;

            statement = connection.prepareStatement(sql);

            for (int i = 0; i < qIds.length; i++) {

                double score = 0;
                if (scores[i] != null && !scores[i].isEmpty()) {
                    score = Double.parseDouble(scores[i]);
                }

                statement.setDouble(1, score);
                statement.setString(2, comments[i]);
                statement.setInt(3, attemptId);
                statement.setInt(4, Integer.parseInt(qIds[i]));

                statement.addBatch();
            }

            statement.executeBatch();

            // 👉 update final score
            updateFinalScore(attemptId);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateFinalScore(int attemptId) {
        try {
            String sql = """
            UPDATE AssignmentAttempts
            SET FinalScore = AutoScore + (
                SELECT SUM(PointsAwarded)
                FROM AssignmentAnswers
                WHERE AttemptId = ?
            ),
            Status = 'Graded'
            WHERE Id = ?
        """;

            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            statement.setInt(2, attemptId);

            statement.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
