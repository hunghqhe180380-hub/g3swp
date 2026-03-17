/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.AssignmentChoice;

/**
 *
 * @author hung2
 */
public class AssignmentChoiceDAO extends DBContext {

    PreparedStatement statement;
    ResultSet resultSet;

    //get choices by assignment question id
    public List<AssignmentChoice> getListChoiceByQuestionId(int assignmentId) {
        List<AssignmentChoice> listChoice = new ArrayList<>();
        try {
            String sql = "SELECT [Id]\n"
                    + "      ,[QuestionId]\n"
                    + "      ,[Text]\n"
                    + "      ,[IsCorrect]\n"
                    + "      ,[Order]\n"
                    + "  FROM [dbo].[AssignmentChoices]\n"
                    + " Where QuestionId = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, assignmentId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                listChoice.add(new AssignmentChoice(resultSet.getInt("Id"),
                        resultSet.getInt("QuestionId"),
                        resultSet.getString("text"),
                        resultSet.getBoolean("IsCorrect"),
                        resultSet.getInt("Order")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listChoice;
    }
}
