package dal;

import java.sql.*;
import java.sql.ResultSet;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;
import model.GradeAttemptVM;
import model.GradeEssayItem;
import model.GradeMcqItem;
import model.McqChoice;
import java.util.List;
import model.SubmissionListItem;
import model.Assignment;
import model.AssignmentAttempt;
import model.ReviewQuestionDTO;

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
                if (resultSet.getTimestamp("StartedAt") != null) {
                    s.setStartedAt(resultSet.getTimestamp("StartedAt").toLocalDateTime()
                            .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                }
                if (resultSet.getTimestamp("SubmittedAt") != null) {
                    s.setSubmittedAt(resultSet.getTimestamp("SubmittedAt").toLocalDateTime()
                            .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                }
                s.setStatus(resultSet.getString("Status"));
                // AutoScore = SCQ + MCQ combined (Type 1 + Type 2)
                // Assign to SCQ since we cannot separate them from AutoScore alone
                s.setScqScore(resultSet.getDouble("AutoScore"));
                s.setMcqScore(0);
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
    public int createAssignment(Assignment a) {
        int newAssignmentId = -1;
        String sql = "INSERT INTO Assignments \n"
                + "(Title, Description, Type, DurationMinutes,\n"
                + " MaxAttempts, ClassId, OpenAt, CloseAt, CreatedAt, CreatedById)\n"
                + "\n"
                + "OUTPUT INSERTED.Id\n"
                + "\n"
                + "VALUES \n"
                + "(?, ?, ?, ?,\n"
                + " ?, ?, ?, ?, GETDATE(), ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setObject(1, a.getTitle());
            st.setObject(2, a.getDescription());
            st.setInt(3, a.getType());
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
            st.setTimestamp(8, closeAt);
            st.setObject(9, a.getCreatedById());

            // Use executeQuery to capture the OUTPUT INSERTED.Id value
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                newAssignmentId = rs.getInt(1);
            }
            rs.close();
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return newAssignmentId;
    }

    public GradeAttemptVM getAttemptDetail(int attemptId) {
        GradeAttemptVM vm = new GradeAttemptVM();

        // Sử dụng LinkedHashMap để giữ đúng thứ tự câu hỏi từ DB
        Map<Integer, GradeMcqItem> scqMap = new LinkedHashMap<>();
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

                    // Xử lý SCQ (type=1): chỉ 1 đáp án đúng
                    if ("1".equalsIgnoreCase(type)) {
                        GradeMcqItem q = scqMap.get(qId);
                        if (q == null) {
                            q = new GradeMcqItem();
                            q.setQuestionId(qId);
                            q.setPrompt(resultSet.getString("Prompt"));
                            q.setPoints(resultSet.getDouble("Points"));
                            q.setChoices(new ArrayList<>());
                            scqMap.put(qId, q);
                        }
                        int choiceId = resultSet.getInt("ChoiceId");
                        if (choiceId > 0) {
                            McqChoice c = new McqChoice();
                            c.setChoiceId(choiceId);
                            c.setContent(resultSet.getString("ChoiceText"));
                            c.setIsCorrect(resultSet.getBoolean("IsCorrect"));
                            int selectedId = resultSet.getInt("SelectedChoiceId");
                            c.setIsSelected(selectedId == choiceId);
                            if (c.isIsSelected() && c.isIsCorrect()) {
                                c.setCssClass("choice-correct");
                            } else if (c.isIsSelected() && !c.isIsCorrect()) {
                                c.setCssClass("choice-wrong");
                            } else if (!c.isIsSelected() && c.isIsCorrect()) {
                                c.setCssClass("choice-correct-unselected");
                            }
                            q.getChoices().add(c);
                        }
                    }

                    // Xử lý MCQ (type=2): nhiều đáp án đúng
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

                    // Xử lý Essay (type=3)
                    if ("3".equalsIgnoreCase(type)) {
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

            vm.setScqs(new ArrayList<>(scqMap.values()));
            vm.setMcqs(new ArrayList<>(mcqMap.values()));
            vm.setEssays(essays);

            double sMax = vm.getScqs().stream().mapToDouble(GradeMcqItem::getPoints).sum();
            double mMax = vm.getMcqs().stream().mapToDouble(GradeMcqItem::getPoints).sum();
            double eMax = essays.stream().mapToDouble(GradeEssayItem::getMaxPoints).sum();
            vm.setScqMax(sMax);
            vm.setMcqMax(mMax);
            vm.setEssayMax(eMax);
            vm.setFinalMax(sMax + mMax + eMax);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return vm;
    }

    public static void main(String[] args) {
        AssignmentDAO dao = new AssignmentDAO();

        // THAY ĐỔI ID NÀY THEO DỮ LIỆU THẬT TRONG DATABASE CỦA BẠN
        int testAttemptId = 1054;

        try {
            System.out.println("========== TEST REVIEW ATTEMPT ==========");
            System.out.println("Đang truy vấn Attempt ID: " + testAttemptId);

            // 1. Test hàm getAttemptById
            AssignmentAttempt attempt = dao.getAttemptById(testAttemptId);
            if (attempt != null) {
                System.out.println("[INFO] Thông tin Attempt:");
                System.out.println(" - Student ID: " + attempt.getUserId());
                System.out.println(" - Final Score: " + attempt.getFinalScore());
                System.out.println(" - Status: " + (attempt.getStatus() == 3 ? "Graded" : "Pending"));
                System.out.println(" - Submitted At: " + attempt.getSubmittedAt());
            } else {
                System.out.println("[ERROR] Không tìm thấy Attempt với ID: " + testAttemptId);
                return;
            }

            System.out.println("-----------------------------------------");

            // 2. Test hàm getReviewData
            System.out.println("[INFO] Đang lấy chi tiết câu hỏi Review...");
            List<ReviewQuestionDTO> questions = dao.getReviewData(testAttemptId);

            if (questions == null || questions.isEmpty()) {
                System.out.println("[WARN] Không có dữ liệu câu trả lời nào cho Attempt này.");
            } else {
                for (int i = 0; i < questions.size(); i++) {
                    ReviewQuestionDTO q = questions.get(i);
                    System.out.printf("\nCâu %d [%s] (%s pts): %s\n",
                            (i + 1), q.type, q.points, q.prompt);

                    if ("MCQ".equalsIgnoreCase(q.type)) {
                        // In danh sách lựa chọn MCQ
                        for (ReviewChoiceDTO c : q.choices) {
                            String prefix = "[ ]";
                            if (c.isChosen && c.isCorrect) {
                                prefix = "[V] CORRECT & CHOSEN";
                            } else if (c.isCorrect) {
                                prefix = "[!] CORRECT ANSWER";
                            } else if (c.isChosen) {
                                prefix = "[X] STUDENT WRONG CHOICE";
                            }

                            System.out.println("   " + prefix + " " + c.text);
                        }
                    } else {
                        // In nội dung tự luận
                        System.out.println("   -> Student Answer: " + (q.essayText != null ? q.essayText : "N/A"));
                        System.out.println("   -> Teacher Score: " + q.essayScore);
                        System.out.println("   -> Teacher Comment: " + (q.teacherComment != null ? q.teacherComment : "No comment"));
                    }
                }
            }

            System.out.println("\n========== TEST HOÀN TẤT ==========");

        } catch (Exception e) {
            System.err.println("!!! LỖI KHI TEST DAO !!!");
            e.printStackTrace();
        }
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
            WHERE q.Type = '1'
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

    //update type of question
    public void updateTypeFollowQuestionInAssignment(int AssignmentId, int type) {
        try {
            String sql = "UPDATE [dbo].[Assignments]\n"
                    + "   SET [Type] = ?\n"
                    + " WHERE [Id] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, type);
            statement.setObject(2, AssignmentId);
            statement.executeUpdate();
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
            Status = '3'
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

    public void updateGrade(int attemptId, String overallComment, double finalScore, List<GradeEssayItem> essays) throws SQLException {
        String sqlUpdateAnswer = "UPDATE AssignmentAnswers SET PointsAwarded = ?, TeacherComment = ? WHERE AttemptId = ? AND QuestionId = ?";
        String sqlUpdateAttempt = "UPDATE AssignmentAttempts SET TeacherComment = ?, FinalScore = ?, Status = 3 WHERE Id = ?";

        try {
            // 1. Cập nhật các câu tự luận (Batch Update)
            if (essays != null && !essays.isEmpty()) {
                statement = connection.prepareStatement(sqlUpdateAnswer);
                for (GradeEssayItem essay : essays) {
                    statement.setDouble(1, essay.getScore());
                    statement.setString(2, essay.getComment());
                    statement.setInt(3, attemptId);
                    statement.setInt(4, essay.getQuestionId());
                    statement.addBatch();
                }
                statement.executeBatch();
            }

            // 2. Cập nhật bảng tổng kết bài làm
            statement = connection.prepareStatement(sqlUpdateAttempt);
            statement.setString(1, overallComment);
            statement.setDouble(2, finalScore);
            statement.setInt(3, attemptId);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Ném lỗi để Servlet bắt được và hiển thị
        }
    }

    public double getAutoScoreByAttemptId(int attemptId) throws SQLException {
        String sql = "SELECT AutoScore FROM AssignmentAttempts WHERE Id = ?";
        double autoScore = 0;

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            resultSet = statement.executeQuery(); // Giả sử bạn có biến resultSet trong class

            if (resultSet.next()) {
                autoScore = resultSet.getDouble("AutoScore");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return autoScore;
    }

    public AssignmentAttempt getAttemptById(int attemptId) throws SQLException {
        String sql = "SELECT a.Id, a.AssignmentId, a.UserId, a.FinalScore, a.SubmittedAt, a.Status, "
                + "assign.Title as AssignmentTitle "
                + "FROM AssignmentAttempts a "
                + "JOIN Assignments assign ON a.AssignmentId = assign.Id "
                + "WHERE a.Id = ?";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                AssignmentAttempt a = new AssignmentAttempt();
                a.setId(resultSet.getInt("Id"));
                a.setAssignmentId(resultSet.getInt("AssignmentId"));
                a.setUserId(resultSet.getString("UserId"));
                a.setFinalScore(resultSet.getDouble("FinalScore"));
                a.setSubmittedAt(resultSet.getString("SubmittedAt"));
                a.setStatus(resultSet.getInt("Status"));
                // Bạn có thể set thêm Title nếu model có thuộc tính này
                return a;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    public List<ReviewQuestionDTO> getReviewData(int attemptId) throws SQLException {
        // Dùng LinkedHashMap để giữ đúng thứ tự câu hỏi và tránh trùng lặp khi JOIN với Choices
        Map<Integer, ReviewQuestionDTO> questionMap = new LinkedHashMap<>();

        String sql = """
        SELECT 
            aq.Id AS AQId, aq.Prompt, aq.Type, aq.Points, 
            ans.TextAnswer, ans.PointsAwarded, ans.TeacherComment, ans.SelectedChoiceId,
            ac.Id AS ChoiceId, ac.Text AS ChoiceText, ac.IsCorrect
        FROM AssignmentQuestions aq
        LEFT JOIN AssignmentAnswers ans ON aq.Id = ans.QuestionId AND ans.AttemptId = ?
        LEFT JOIN AssignmentChoices ac ON aq.Id = ac.QuestionId
        WHERE aq.AssignmentId = (SELECT AssignmentId FROM AssignmentAttempts WHERE Id = ?)
        ORDER BY aq.[Order], ac.[Order]
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, attemptId);
            ps.setInt(2, attemptId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int aqId = rs.getInt("AQId");
                    ReviewQuestionDTO q = questionMap.get(aqId);

                    if (q == null) {
                        q = new ReviewQuestionDTO();
                        q.questionId = aqId;
                        q.prompt = rs.getString("Prompt");

                        // Thống nhất Logic: 1 là MCQ, 2 là Essay (theo hàm Grade của bạn)
                        int typeInt = rs.getInt("Type");
                        q.type = (typeInt == 1) ? "MCQ" : "Essay";

                        q.points = rs.getDouble("Points");
                        q.essayText = rs.getString("TextAnswer");

                        Object p = rs.getObject("PointsAwarded");
                        q.essayScore = (p != null) ? (Double) p : 0.0;
                        q.teacherComment = rs.getString("TeacherComment");
                        q.choices = new ArrayList<>();

                        questionMap.put(aqId, q);
                    }

                    // Nếu là MCQ, xử lý nạp Choice
                    if ("MCQ".equals(q.type)) {
                        int choiceId = rs.getInt("ChoiceId");
                        if (choiceId > 0) {
                            ReviewChoiceDTO c = new ReviewChoiceDTO();
                            c.choiceId = choiceId;
                            c.text = rs.getString("ChoiceText");
                            c.isCorrect = rs.getBoolean("IsCorrect");

                            // Kiểm tra xem sinh viên có chọn choice này không
                            int selectedId = rs.getInt("SelectedChoiceId");
                            c.isChosen = (choiceId == selectedId);

                            q.choices.add(c);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }

        return new ArrayList<>(questionMap.values());
    }

    private List<ReviewChoiceDTO> getChoicesForReview(int questionBankId, int selectedChoiceId) throws SQLException {
        List<ReviewChoiceDTO> choices = new ArrayList<>();
        // Theo ảnh: Bảng QuestionBankChoices, Cột Text, Cột QuestionBankId
        String sql = "SELECT Id, [Text], IsCorrect FROM QuestionBankChoices WHERE QuestionBankId = ? ORDER BY [Order]";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionBankId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewChoiceDTO c = new ReviewChoiceDTO();
                    c.choiceId = rs.getInt("Id");
                    c.text = rs.getString("Text"); // Đổi từ Content -> Text
                    c.isCorrect = rs.getBoolean("IsCorrect");
                    c.isChosen = (c.choiceId == selectedChoiceId);
                    choices.add(c);
                }
            }
        }
        return choices;
    }

    //get total assignmet(teacher)
    public int getTeacherTotalAssignment(String teacherId) {
        int total = 0;
        try {
            String sql = "SELECT count(Id) as TotalAssignment\n"
                    + "  FROM [dbo].[Assignments]\n"
                    + "  Where CreatedById = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, teacherId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                total = resultSet.getInt("TotalAssignment");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    //get student's assignment due
    public int getStudentAssignmentDue(int classId) {
        int total = 0;
        try {
            String sql = "SELECT Count(ClassId) as TotalAssignment\n"
                    + "  FROM [dbo].[Assignments]\n"
                    + "  Where ClassId = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            resultSet = statement.executeQuery();
            if(resultSet.next()){
                total = resultSet.getInt("TotalAssignment");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
}
