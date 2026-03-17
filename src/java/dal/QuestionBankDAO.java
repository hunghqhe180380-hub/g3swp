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
                    + "      ,[Level]\n"
                    + "      ,[CreatedById]\n"
                    + "      ,[CreatedAt]\n"
                    + "      ,[IsPublic]\n"
                    + "  FROM [dbo].[QuestionBank]";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            QuestionBankChoiceDAO qBankChoiceDAO = new QuestionBankChoiceDAO();
            while (resultSet.next()) {
                QuestionBank q = new QuestionBank(resultSet.getInt("Id"),
                        resultSet.getString("SubjectId"),
                        resultSet.getInt("Type"),
                        resultSet.getString("Prompt"),
                        resultSet.getInt("Level"),
                        resultSet.getString("CreatedById"),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getInt("IsPublic"),
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
    public QuestionBank getQuestionById(String questionId) {
        QuestionBank qBank = new QuestionBank();
        try {
            String sql = "SELECT [Id]\n"
                    + "      ,[SubjectId]\n"
                    + "      ,[Type]\n"
                    + "      ,[Prompt]\n"
                    + "      ,[Level]\n"
                    + "      ,[CreatedById]\n"
                    + "      ,[CreatedAt]\n"
                    + "      ,[IsPublic]\n"
                    + "  FROM [dbo].[QuestionBank]\n"
                    + "Where Id = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, questionId);
            resultSet = statement.executeQuery();
            QuestionBankChoiceDAO qBankChoiceDAO = new QuestionBankChoiceDAO();
            if (resultSet.next()) {
                qBank = new QuestionBank(resultSet.getInt("Id"),
                        resultSet.getString("SubjectId"),
                        resultSet.getInt("Type"),
                        resultSet.getString("Prompt"),
                        resultSet.getInt("Level"),
                        resultSet.getString("CreatedById"),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getInt("IsPublic"),
                        qBankChoiceDAO.getChoicesByQuestionId(resultSet.getInt("Id")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return qBank;
    }

    //insert question into questionbank
    public void insertQuestion(QuestionBank q) {

        String sql = """
        INSERT INTO QuestionBank
        (SubjectId, Type, Prompt, Level, DefaultPoints, CreatedById, CreatedAt)
        VALUES (?, ?, ?, ?, ?, ?, GETDATE())
        """;

        try {
////            PreparedStatement ps = connection.prepareStatement(sql);
////
////            ps.setString(1, q.getSubjectId());
////            ps.setInt(2, q.getType());
////            ps.setString(3, q.getPrompt());
////            ps.setInt(4, q.getLevel());
////            ps.setDouble(5, q.getDefaultPoints());
////            ps.setString(6, q.getCreatedById());
//
//            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
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
    public List<QuestionBank> getRandomQuestions(String subjectId, int level, int type, int numberQuestion, double pointPerQuestion) {

        List<QuestionBank> list = new ArrayList<>();

        String sql = "  SELECT TOP (?) *\n"
                + "FROM QuestionBank\n"
                + "WHERE SubjectId = ?\n"
                + "  AND Level = ?\n"
                + "  AND Type = ?\n"
                + "  AND IsPublic = 1\n"
                + "ORDER BY NEWID();";

        try {
            statement = connection.prepareStatement(sql);

            statement.setObject(1, numberQuestion);
            statement.setObject(2, subjectId);
            statement.setObject(3, level);
            statement.setObject(4, type);
            resultSet = statement.executeQuery();

            QuestionBankChoiceDAO qBankChoiceDAO = new QuestionBankChoiceDAO();
            while (resultSet.next()) {
                QuestionBank q = new QuestionBank(resultSet.getInt("Id"),
                        resultSet.getString("SubjectId"),
                        resultSet.getInt("Type"),
                        resultSet.getString("Prompt"),
                        resultSet.getInt("Level"),
                        resultSet.getString("CreatedById"),
                        resultSet.getString("CreatedAt"),
                        resultSet.getInt("IsPublic"),
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
}
