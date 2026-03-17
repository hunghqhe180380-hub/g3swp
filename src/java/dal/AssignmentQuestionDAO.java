/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author hung2
 */
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.AssignmentQuestion;

public class AssignmentQuestionDAO extends DBContext {

    PreparedStatement statement;
    ResultSet resultSet;

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    public List<AssignmentQuestion> getQuestionsByAssignmentId(String assignmentId) {

        List<AssignmentQuestion> list = new ArrayList<>();

        try {

            String sql = "SELECT [Id]\n"
                    + "      ,[AssignmentId]\n"
                    + "      ,[Type]\n"
                    + "      ,[Prompt]\n"
                    + "      ,[Points]\n"
                    + "      ,[Order]\n"
                    + "      ,[Level]\n"
                    + "      ,[CreatedAt]\n"
                    + "      ,[SourceType]\n"
                    + "  FROM [dbo].[AssignmentQuestions]\n"
                    + "WHERE AssignmentId = ? ORDER BY [Order]";

            statement = connection.prepareStatement(sql);
            statement.setObject(1, assignmentId);

            resultSet = statement.executeQuery();
            AssignmentChoiceDAO asgChoiceDAO = new AssignmentChoiceDAO();
            while (resultSet.next()) {
                AssignmentQuestion q = new AssignmentQuestion(resultSet.getInt("Id"),
                        resultSet.getInt("AssignmentId"),
                        resultSet.getString("Type"),
                        resultSet.getString("Prompt"),
                        resultSet.getDouble("Points"),
                        resultSet.getInt("Order"),
                        resultSet.getInt("Level"),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getString("SourceType"),
                        asgChoiceDAO.getListChoiceByQuestionId(resultSet.getInt("Id")));

                list.add(q);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
