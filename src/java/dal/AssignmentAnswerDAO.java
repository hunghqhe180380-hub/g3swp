package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.AssignmentAnswer;

/**
 *
 * @author hung2
 */
public class AssignmentAnswerDAO extends DBContext {

    PreparedStatement statement;
    ResultSet resultSet;

    /**
     * Insert a new answer for an attempt/question (called on Finish only)
     * For MCQ: saves selectedChoiceId and isCorrect
     * For Essay: saves textAnswer, isCorrect = null (teacher grades later)
     */
    public void saveAnswer(int attemptId, int questionId, Integer selectedChoiceId, String textAnswer, Boolean isCorrect) {
        try {
            String sql = "INSERT INTO AssignmentAnswers (AttemptId, QuestionId, SelectedChoiceId, TextAnswer, IsCorrect) "
                    + "VALUES (?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            statement.setInt(2, questionId);
            statement.setObject(3, selectedChoiceId);
            statement.setString(4, textAnswer);
            statement.setObject(5, isCorrect);
            statement.executeUpdate();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Get all answers for an attempt
     */
    public List<AssignmentAnswer> getAnswersByAttemptId(int attemptId) {
        List<AssignmentAnswer> list = new ArrayList<>();
        try {
            String sql = "SELECT Id, AttemptId, QuestionId, SelectedChoiceId, TextAnswer, IsCorrect, TeacherComment "
                    + "FROM AssignmentAnswers WHERE AttemptId = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, attemptId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                AssignmentAnswer answer = new AssignmentAnswer();
                answer.setId(resultSet.getInt("Id"));
                answer.setAttemptId(resultSet.getInt("AttemptId"));
                answer.setQuestionId(resultSet.getInt("QuestionId"));
                answer.setSelectedChoiceId(resultSet.getObject("SelectedChoiceId", Integer.class));
                answer.setTextAnswer(resultSet.getString("TextAnswer"));
                answer.setIsCorrect(resultSet.getObject("IsCorrect", Boolean.class));
                list.add(answer);
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
