/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.QuestionBank;

/**
 *
 * @author hung2
 */
public class QuestionBankDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    /**
     * Search + filter + sort questions for Admin.
     * @param search  keyword to match prompt or subject name (nullable)
     * @param status  "0"=pending, "1"=approved, "2"=rejected, ""=all
     * @param type    "1"=SCQ, "2"=MCQ, "3"=Essay, ""=all
     * @param sort    column name: id|subject|type|chapter|status (default id)
     * @param dir     "asc" or "desc"
     */
    public List<QuestionBank> getFilteredQuestions(String search, String status,
            String type, String sort, String dir) {
        List<QuestionBank> list = new ArrayList<>();
        try {
            // Build ORDER BY
            String orderCol;
            switch (sort == null ? "" : sort.toLowerCase()) {
                case "subject":  orderCol = "s.subject_name"; break;
                case "type":     orderCol = "q.Type";        break;
                case "chapter":  orderCol = "q.Chapter";     break;
                case "status":   orderCol = "q.Status";      break;
                default:         orderCol = "q.Id";          break;
            }
            String orderDir = "desc".equalsIgnoreCase(dir) ? "DESC" : "ASC";

            // Build WHERE conditions
            StringBuilder where = new StringBuilder("WHERE 1=1 ");
            if (status != null && !status.isEmpty()) {
                where.append("AND q.Status = ").append(status).append(" ");
            }
            if (type != null && !type.isEmpty()) {
                where.append("AND q.Type = ").append(type).append(" ");
            }
            boolean hasSearch = search != null && !search.trim().isEmpty();
            if (hasSearch) {
                // Dùng EXISTS subquery để search subject tên độc lập với LEFT JOIN
                where.append("AND (q.Prompt LIKE ? "
                        + "OR EXISTS (SELECT 1 FROM [dbo].[Subjects] sx "
                        + "           WHERE sx.Id = q.SubjectId "
                        + "           AND sx.subject_name LIKE ?)) ");
            }

            String sql = "SELECT q.Id, q.SubjectId, q.Type, q.Prompt, q.Chapter, "
                       + "       q.CreatedById, q.CreatedAt, q.Status, s.subject_name AS SubjectName "
                       + "FROM [dbo].[QuestionBank] q "
                       + "LEFT JOIN [dbo].[Subjects] s ON q.SubjectId = s.Id "
                       + where
                       + "ORDER BY " + orderCol + " " + orderDir;

            PreparedStatement ps = connection.prepareStatement(sql);
            if (hasSearch) {
                String kw = "%" + search.trim() + "%";
                // LƯU Ý QUAN TRỌNG: Dùng setNString cho dữ liệu NVARCHAR để không bị vỡ font Tiếng Việt
                ps.setNString(1, kw);
                ps.setNString(2, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank q = new QuestionBank(
                        rs.getInt("Id"),
                        rs.getString("SubjectId"),
                        rs.getInt("Type"),
                        rs.getString("Prompt"),
                        rs.getInt("Chapter"),
                        rs.getString("CreatedById"),
                        rs.getTimestamp("CreatedAt") != null
                            ? rs.getTimestamp("CreatedAt").toLocalDateTime()
                                  .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                            : "",
                        rs.getInt("Status"),
                        null);
                q.setSubjectName(rs.getString("SubjectName"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Count questions grouped by status for stats cards. Returns int[3]: [pending, approved, rejected] */
    public int[] getQuestionStats() {
        int[] stats = {0, 0, 0};
        try {
            String sql = "SELECT Status, COUNT(*) AS cnt FROM [dbo].[QuestionBank] GROUP BY Status";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int s = rs.getInt("Status");
                int c = rs.getInt("cnt");
                if (s == 2) stats[2] += c;
                else if (s == 1) stats[1] += c;
                else if (s == 0) stats[0] += c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    //get all question in question bank
    public List<QuestionBank> getAllQuestionBank() {
        List<QuestionBank> listQuestionBank = new ArrayList<>();
        try {
            String sql = "SELECT [Id]\n"
                    + "      ,[SubjectId]\n"
                    + "      ,[Type]\n"
                    + "      ,[Prompt]\n"
                    + "      ,[Chapter]\n"
                    + "      ,[CreatedById]\n"
                    + "      ,[CreatedAt]\n"
                    + "      ,[Status]\n"
                    + "  FROM [dbo].[QuestionBank]";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            QuestionBankChoiceDAO qBankChoiceDAO = new QuestionBankChoiceDAO();
            while (resultSet.next()) {
                QuestionBank q = new QuestionBank(resultSet.getInt("Id"),
                        resultSet.getString("SubjectId"),
                        resultSet.getInt("Type"),
                        resultSet.getString("Prompt"),
                        resultSet.getInt("Chapter"),
                        resultSet.getString("CreatedById"),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getInt("Status"),
                        qBankChoiceDAO.getChoicesByQuestionId(resultSet.getInt("Id")));

                listQuestionBank.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listQuestionBank;
    }

    //get question by subject'id
    public List<QuestionBank> getQuestionsBySubject(String subjectId) {
        List<QuestionBank> list = new ArrayList<>();

        String sql = "SELECT * FROM QuestionBank WHERE SubjectId = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, subjectId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
//                QuestionBank q = new QuestionBank(
//                        rs.getInt("Id"),
//                        rs.getString("SubjectId"),
//                        rs.getInt("Type"),
//                        rs.getString("Prompt"),
//                        rs.getInt("Level"),
//                        rs.getDouble("DefaultPoints"),
//                        rs.getString("CreatedById"),
//                        rs.getString("CreatedAt")
//                );

                //  list.add(q);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //get question by it's id
    //get all question in question bank
    public QuestionBank getQuestionById(String questionId, String teacherId, double settingPoint) {
        QuestionBank qBank = new QuestionBank();
        try {
            String sql = "SELECT [Id]\n"
                    + "      ,[SubjectId]\n"
                    + "      ,[Type]\n"
                    + "      ,[Prompt]\n"
                    + "      ,[Chapter]\n"
                    + "      ,[CreatedById]\n"
                    + "      ,[CreatedAt]\n"
                    + "      ,[Status]\n"
                    + "  FROM [dbo].[QuestionBank]\n"
                    + "Where Id = ? And CreatedById = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, questionId);
            statement.setObject(2, teacherId);
            resultSet = statement.executeQuery();
            QuestionBankChoiceDAO qBankChoiceDAO = new QuestionBankChoiceDAO();
            if (resultSet.next()) {
                qBank = new QuestionBank(resultSet.getInt("Id"),
                        resultSet.getString("SubjectId"),
                        resultSet.getInt("Type"),
                        resultSet.getString("Prompt"),
                        resultSet.getInt("Chapter"),
                        resultSet.getString("CreatedById"),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getInt("Status"),
                        qBankChoiceDAO.getChoicesByQuestionId(resultSet.getInt("Id")));
                qBank.setSettingPoint(settingPoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return qBank;
    }

    //insert question into questionbank
    public int insertQuestion(QuestionBank q, String teacherId) {

        String sql = """
        INSERT INTO [dbo].[QuestionBank]
                   ([SubjectId]
                   ,[Type]
                   ,[Prompt]
                   ,[Chapter]
                   ,[CreatedById]
                   ,[CreatedAt]
                   ,[Status])
                     OUTPUT INSERTED.Id
             VALUES
                   (?
                   ,?
                   ,?
                   ,?
                   ,?
                   ,GETDATE()
                   ,?)
        """;

        try {
            statement = connection.prepareStatement(sql);

            statement.setString(1, q.getSubjectId());
            statement.setInt(2, q.getType());
            statement.setString(3, q.getPrompt());
            statement.setInt(4, q.getChapter());
            statement.setObject(5, teacherId);
            statement.setInt(6, 2);

            resultSet = statement.executeQuery();
            if(resultSet.next()){
                return resultSet.getInt("Id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    //update question
//    public void updateQuestion(QuestionBank q) {
//
//        String sql = """
//        UPDATE QuestionBank
//        SET Prompt = ?, Level = ?, DefaultPoints = ?
//        WHERE Id = ?
//        """;
//
//        try {
//            PreparedStatement ps = connection.prepareStatement(sql);
//
//            ps.setString(1, q.getPrompt());
//            ps.setInt(2, q.getLevel());
//            ps.setDouble(3, q.getDefaultPoints());
//            ps.setInt(4, q.getId());
//
//            ps.executeUpdate();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
    /** Update question status: 0=pending, 1=approved, 2=rejected */
    public void updateQuestionStatus(int id, int status) {
        String sql = "UPDATE QuestionBank SET Status = ? WHERE Id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //delete question
    public void deleteQuestion(int id) {

        String sql = "DELETE FROM QuestionBank WHERE Id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //get random question in question bank
    public List<QuestionBank> getRandomQuestions(String subjectId, String createdById, int Chapter, int type, int numberQuestion, double pointPerQuestion) {

        List<QuestionBank> list = new ArrayList<>();

        // No Status filter: teachers can use their own questions regardless of approval.
        // For Essay (type=3): skip Chapter filter because Essay questions may have Chapter=0
        // (saved by older code), and essay questions are generally not chapter-specific.
        String chapterClause = (type == 3) ? "" : "  AND [Chapter] = ?\n";

        String sql = "  SELECT TOP (?) *\n"
                + "FROM QuestionBank\n"
                + "WHERE SubjectId = ?\n"
                + chapterClause
                + "  AND Type = ?\n"
                + "  AND CreatedById = ?\n"
                + "ORDER BY NEWID();";

        try {
            statement = connection.prepareStatement(sql);

            int paramIdx = 1;
            statement.setObject(paramIdx++, numberQuestion);
            statement.setObject(paramIdx++, subjectId);
            if (type != 3) {
                statement.setObject(paramIdx++, Chapter); // skip chapter param for Essay
            }
            statement.setObject(paramIdx++, type);
            statement.setObject(paramIdx++, createdById);
            resultSet = statement.executeQuery();

            QuestionBankChoiceDAO qBankChoiceDAO = new QuestionBankChoiceDAO();
            while (resultSet.next()) {
                QuestionBank q = new QuestionBank(resultSet.getInt("Id"),
                        resultSet.getString("SubjectId"),
                        resultSet.getInt("Type"),
                        resultSet.getString("Prompt"),
                        resultSet.getInt("Chapter"),
                        resultSet.getString("CreatedById"),
                        resultSet.getString("CreatedAt"),
                        resultSet.getInt("Status"),
                        qBankChoiceDAO.getChoicesByQuestionId(resultSet.getInt("Id")));

                q.setSettingPoint(pointPerQuestion);
                list.add(q);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

//    //get random questions by subject, type, level, number of question
//    public List<QuestionBank> getRandomQuestionBankBySubjectId() {
//        List<QuestionBank> listRandom = new ArrayList<>();
//        try {
//            String sql = "SELECT TOP (?) *\n"
//                    + "FROM [dbo].[QuestionBank]\n"
//                    + "WHERE Type = ?\n"
//                    + "  AND Level = ?\n"
//                    + "ORDER BY NEWID()";
//
//        } catch (Exception e) {
//        }
//    }
    /*
    *get list question bank by teacher'is and subject'is
    *use when create assignment
     */
    /**
     * Get questions for a teacher+subject. Pass status=-1 to include all statuses (Pending + Approved).
     */
    public List<QuestionBank> getListQuestionBankByTeacherAndSubject(String subjectId, String teacherId, int status) {
        List<QuestionBank> listQuestionBank = new ArrayList<>();
        try {
            // When status == -1, skip the Status filter so teachers see ALL their own questions
            String statusClause = (status == -1) ? "" : "And [Status] = " + status;
            String sql = "SELECT *\n"
                    + "FROM [dbo].[QuestionBank]\n"
                    + "Where [SubjectId] = ?\n"
                    + "And [CreatedById] = ?\n"
                    + ""
                    + statusClause;
            statement = connection.prepareStatement(sql);
            statement.setObject(1, subjectId);
            statement.setObject(2, teacherId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                QuestionBank qBank = new QuestionBank();
                qBank.setId(resultSet.getInt("Id"));
                qBank.setChapter(resultSet.getInt("Chapter"));
                qBank.setPrompt(resultSet.getString("Prompt"));
                qBank.setType(resultSet.getInt("Type"));
                listQuestionBank.add(qBank);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listQuestionBank;
    }

    /*
    *get list question bank by teacher id
    *display question bank of this teacher
     */
    public List<QuestionBank> getListQuestionBankByTeacherId(String teacherId, String status) {
        List<QuestionBank> listQuestionBank = new ArrayList<>();
        String statusPending = "";
        if (status.equalsIgnoreCase("pending")) {
            statusPending = "AND Status IN (0, 2)";
        }
        if (status.equalsIgnoreCase("all")) {
            statusPending = "AND Status = 1";
        }
        try {
            String sql = "SELECT [Id]\n"
                    + "      ,[SubjectId]\n"
                    + "      ,[Type]\n"
                    + "      ,[Prompt]\n"
                    + "      ,[Chapter]\n"
                    + "      ,[CreatedById]\n"
                    + "      ,[CreatedAt]\n"
                    + "      ,[Status]\n"
                    + "  FROM [dbo].[QuestionBank]\n"
                    + "Where CreatedById = ? " + statusPending;
            statement = connection.prepareStatement(sql);
            statement.setObject(1, teacherId);
            resultSet = statement.executeQuery();
            QuestionBankChoiceDAO qBankChoiceDAO = new QuestionBankChoiceDAO();
            while (resultSet.next()) {
                QuestionBank q = new QuestionBank(resultSet.getInt("Id"),
                        resultSet.getString("SubjectId"),
                        resultSet.getInt("Type"),
                        resultSet.getString("Prompt"),
                        resultSet.getInt("Chapter"),
                        resultSet.getString("CreatedById"),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getInt("Status"),
                        qBankChoiceDAO.getChoicesByQuestionId(resultSet.getInt("Id")));

                listQuestionBank.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listQuestionBank;
    }
}
