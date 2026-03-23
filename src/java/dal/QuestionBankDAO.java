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

        String sql = "  SELECT TOP (?) *\n"
                + "FROM QuestionBank\n"
                + "WHERE SubjectId = ?\n"
                + "  AND [Chapter] = ?\n"
                + "  AND Type = ?\n"
                + "  AND Status = 1\n"
                + "AND CreatedById = ?\n"
                + "ORDER BY NEWID();";

        try {
            statement = connection.prepareStatement(sql);

            statement.setObject(1, numberQuestion);
            statement.setObject(2, subjectId);
            statement.setObject(3, Chapter);
            statement.setObject(4, type);
            statement.setObject(5, createdById);
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
    public List<QuestionBank> getListQuestionBankByTeacherAndSubject(String subjectId, String teacherId, int status) {
        List<QuestionBank> listQuestionBank = new ArrayList<>();
        try {
            String sql = "SELECT *\n"
                    + "FROM [dbo].[QuestionBank]\n"
                    + "Where [SubjectId] = ?\n"
                    + "And [CreatedById] = ?\n"
                    + "And [Status] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, subjectId);
            statement.setObject(2, teacherId);
            statement.setObject(3, status);
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
