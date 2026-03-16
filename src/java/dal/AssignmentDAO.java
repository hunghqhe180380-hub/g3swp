package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.SubmissionListItem;
import model.Assignment;

/**
 * * * @author FPT
 */
public class AssignmentDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

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
                s.setStartedAt(resultSet.getTimestamp("StartedAt").toLocalDateTime());
                if (resultSet.getTimestamp("SubmittedAt") != null) {
                    s.setSubmittedAt(resultSet.getTimestamp("SubmittedAt").toLocalDateTime());
                }
                s.setStatus(resultSet.getString("Status"));
                s.setMcqScore(resultSet.getDouble("AutoScore"));
                s.setFinalScore(resultSet.getDouble("FinalScore"));
                s.setRequiresManual(resultSet.getBoolean("RequiresManualGrading"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //create assignment
    public void insertAssignment(Assignment a) {

        String sql = "INSERT INTO Assignments (Title,Description,Type,DurationMinutes,"
                + "MaxAttempts,ClassId,OpenAt,CloseAt,CreatedAt,CreatedById)"
                + " VALUES (?,?,?,?,?,?,?,?,?,?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, a.getTitle());
            st.setString(2, a.getDescription());
            st.setInt(3, a.getType());
            st.setInt(4, a.getDurationMinutes());
            st.setInt(5, a.getMaxAttempts());
            st.setInt(6, a.getClassId());
            st.setString(7, a.getOpenAt());
            st.setString(8, a.getCloseAt());
            st.setString(9, a.getCreatedAt());
            st.setString(10, a.getCreatedById());

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
