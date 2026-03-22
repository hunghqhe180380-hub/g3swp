/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.QuestionBankChoice;

/**
 *
 * @author hung2
 */
public class QuestionBankChoiceDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    //get all choice of question by question'id
    public List<QuestionBankChoice> getChoicesByQuestionId(int questionId) {

        List<QuestionBankChoice> list = new ArrayList<>();

        String sql = """
        SELECT [Id]
              ,[QuestionBankId]
              ,[Text]
              ,[IsCorrect]
              ,[Order]
          FROM [dbo].[QuestionBankChoices]
        WHERE QuestionBankId = ?
        ORDER BY [Order]
        """;

        try {

           statement = connection.prepareStatement(sql);
            statement.setInt(1, questionId);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {

                QuestionBankChoice c = new QuestionBankChoice();

                c.setId(resultSet.getInt("Id"));
                c.setQuestionBankId(resultSet.getInt("QuestionBankId"));
                c.setText(resultSet.getString("Text"));
                System.out.println("xxxx: " + resultSet.getString("Text"));
                c.setIsCorrect(resultSet.getBoolean("IsCorrect"));
                c.setOrder(resultSet.getInt("Order"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

//    //create choice
//    public void insertChoice(QuestionBankChoice c) {
//
//        String sql = """
//        INSERT INTO QuestionBankChoices
//        (QuestionBankId, Text, IsCorrect, [Order])
//        VALUES (?, ?, ?, ?)
//        """;
//
//        try {
//
//            PreparedStatement ps = connection.prepareStatement(sql);
//
//            ps.setInt(1, c.getQuestionBankId());
//            ps.setString(2, c.getText());
//            ps.setBoolean(3, c.isCorrect());
//            ps.setInt(4, c.getOrder());
//
//            ps.executeUpdate();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
    //update choice
//    public void updateChoice(QuestionBankChoice c) {
//
//        String sql = """
//        UPDATE QuestionBankChoices
//        SET Text = ?, IsCorrect = ?, [Order] = ?
//        WHERE Id = ?
//        """;
//
//        try {
//
//            PreparedStatement ps = connection.prepareStatement(sql);
//
//            ps.setString(1, c.getText());
//            ps.setBoolean(2, c.isCorrect());
//            ps.setInt(3, c.getOrder());
//            ps.setInt(4, c.getId());
//
//            ps.executeUpdate();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
    //delete choice by question'id
    public void deleteChoicesByQuestionId(int questionId) {

        String sql = "DELETE FROM QuestionBankChoices WHERE QuestionBankId = ?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, questionId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
