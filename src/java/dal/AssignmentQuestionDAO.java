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
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.AssignmentQuestion;
import model.QuestionBankChoice;
import model.QuestionBank;

public class AssignmentQuestionDAO extends DBContext {

    PreparedStatement statement;
    ResultSet resultSet;

    public List<AssignmentQuestion> getQuestionsByAssignmentId(String assignmentId) {

        List<AssignmentQuestion> list = new ArrayList<>();

        try {

            String sql = "SELECT [Id]\n"
                    + "      ,[AssignmentId]\n"
                    + "      ,[Type]\n"
                    + "      ,[Prompt]\n"
                    + "      ,[Points]\n"
                    + "      ,[Order]\n"
                    + "      ,[Chapter]\n"
                    + "      ,[CreatedAt]\n"
                    + "  FROM [dbo].[AssignmentQuestions]\n"
                    + "WHERE AssignmentId = ? ORDER BY [Order]";

            statement = connection.prepareStatement(sql);
            statement.setObject(1, assignmentId);

            resultSet = statement.executeQuery();

            // SQL Server does NOT support MARS (Multiple Active Result Sets).
            // We must read ALL rows into memory BEFORE calling any helper DAO
            // that opens another query on the same connection.
            List<Object[]> rows = new ArrayList<>();
            while (resultSet.next()) {
                Object[] row = new Object[8];
                row[0] = resultSet.getInt("Id");
                row[1] = resultSet.getInt("AssignmentId");
                row[2] = resultSet.getString("Type");
                row[3] = resultSet.getString("Prompt");
                row[4] = resultSet.getDouble("Points");
                row[5] = resultSet.getInt("Order");
                row[6] = resultSet.getInt("Chapter");
                row[7] = resultSet.getTimestamp("CreatedAt")
                               .toLocalDateTime()
                               .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
                rows.add(row);
            }
            resultSet.close();
            statement.close();

            // Now it is safe to run per-question choice queries on the same connection
            AssignmentChoiceDAO asgChoiceDAO = new AssignmentChoiceDAO();
            for (Object[] row : rows) {
                int qId = (int) row[0];
                AssignmentQuestion q = new AssignmentQuestion(
                        qId,
                        (int)    row[1],
                        (String) row[2],
                        (String) row[3],
                        (double) row[4],
                        (int)    row[5],
                        (int)    row[6],
                        (String) row[7],
                        asgChoiceDAO.getListChoiceByQuestionId(qId));
                list.add(q);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //insert question to assignment question AND copy its choices
    public void insertQuestion(int assignmentId, QuestionBank qBank) {
        try {
            // 1. Insert into AssignmentQuestions and get the new ID back
            String sql = "INSERT INTO [dbo].[AssignmentQuestions]\n"
                    + "(\n"
                    + "    [AssignmentId],\n"
                    + "    [Type],\n"
                    + "    [Prompt],\n"
                    + "    [Points],\n"
                    + "    [Order],\n"
                    + "    [Chapter],\n"
                    + "    [CreatedAt]\n"
                    + ")\n"
                    + "OUTPUT INSERTED.Id\n"
                    + "VALUES\n"
                    + "(\n"
                    + "    ?,\n"
                    + "    ?,\n"
                    + "    ?,\n"
                    + "    ?,\n"
                    + "    (\n"
                    + "        SELECT ISNULL(MAX([Order]), 0) + 1\n"
                    + "        FROM [dbo].[AssignmentQuestions]\n"
                    + "        WHERE AssignmentId = ?\n"
                    + "    ),\n"
                    + "    ?,\n"
                    + "    GETDATE()\n"
                    + ");";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, assignmentId);
            statement.setObject(2, qBank.getType());
            statement.setObject(3, qBank.getPrompt());
            statement.setObject(4, qBank.getSettingPoint());
            statement.setObject(5, assignmentId);
            statement.setObject(6, qBank.getChapter());

            resultSet = statement.executeQuery();
            int newQuestionId = 0;
            if (resultSet.next()) {
                newQuestionId = resultSet.getInt(1);
            }
            resultSet.close();
            statement.close();

            // 2. Copy choices from QuestionBankChoices → AssignmentChoices
            if (newQuestionId > 0 && qBank.getListQuestionBankChoice() != null) {
                for (QuestionBankChoice c : qBank.getListQuestionBankChoice()) {
                    insertChoiceForQuestion(newQuestionId, c.getText(), c.isIsCorrect(), c.getOrder());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** Insert a single choice into AssignmentChoices for the given AssignmentQuestion id */
    private void insertChoiceForQuestion(int questionId, String text, boolean isCorrect, int order) {
        try {
            String sql = "INSERT INTO [dbo].[AssignmentChoices] ([QuestionId],[Text],[IsCorrect],[Order]) "
                    + "VALUES (?,?,?,?)";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, questionId);
            ps.setString(2, text);
            ps.setBoolean(3, isCorrect);
            ps.setInt(4, order);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
