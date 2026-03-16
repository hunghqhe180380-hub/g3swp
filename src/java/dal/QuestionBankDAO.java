/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

    //get question by subject'id
    public List<QuestionBank> getQuestionsBySubject(String subjectId) {
        List<QuestionBank> list = new ArrayList<>();

        String sql = "SELECT * FROM QuestionBank WHERE SubjectId = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, subjectId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                QuestionBank q = new QuestionBank(
                        rs.getInt("Id"),
                        rs.getString("SubjectId"),
                        rs.getInt("Type"),
                        rs.getString("Prompt"),
                        rs.getInt("Level"),
                        rs.getDouble("DefaultPoints"),
                        rs.getString("CreatedById"),
                        rs.getString("CreatedAt")
                );

                list.add(q);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //get question by it's id
    public QuestionBank getQuestionById(int id) {

        String sql = "SELECT * FROM QuestionBank WHERE Id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new QuestionBank(
                        rs.getInt("Id"),
                        rs.getString("SubjectId"),
                        rs.getInt("Type"),
                        rs.getString("Prompt"),
                        rs.getInt("Level"),
                        rs.getDouble("DefaultPoints"),
                        rs.getString("CreatedById"),
                        rs.getString("CreatedAt")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    //insert question into questionbank
    public void insertQuestion(QuestionBank q) {

        String sql = """
        INSERT INTO QuestionBank
        (SubjectId, Type, Prompt, Level, DefaultPoints, CreatedById, CreatedAt)
        VALUES (?, ?, ?, ?, ?, ?, GETDATE())
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, q.getSubjectId());
            ps.setInt(2, q.getType());
            ps.setString(3, q.getPrompt());
            ps.setInt(4, q.getLevel());
            ps.setDouble(5, q.getDefaultPoints());
            ps.setString(6, q.getCreatedById());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //update question
    public void updateQuestion(QuestionBank q) {

        String sql = """
        UPDATE QuestionBank
        SET Prompt = ?, Level = ?, DefaultPoints = ?
        WHERE Id = ?
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, q.getPrompt());
            ps.setInt(2, q.getLevel());
            ps.setDouble(3, q.getDefaultPoints());
            ps.setInt(4, q.getId());

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
    public List<QuestionBank> getRandomQuestionsBySubject(String subjectId, int number) {

        List<QuestionBank> list = new ArrayList<>();

        String sql = """
        SELECT TOP (?) *
        FROM QuestionBank
        WHERE SubjectId = ?
        ORDER BY NEWID()
        """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, number);
            ps.setString(2, subjectId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                QuestionBank q = new QuestionBank(
                        rs.getInt("Id"),
                        rs.getString("SubjectId"),
                        rs.getInt("Type"),
                        rs.getString("Prompt"),
                        rs.getInt("Level"),
                        rs.getDouble("DefaultPoints"),
                        rs.getString("CreatedById"),
                        rs.getString("CreatedAt")
                );

                list.add(q);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
