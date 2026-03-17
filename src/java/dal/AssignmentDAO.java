package dal;

import java.security.Timestamp;
import java.sql.*;
import java.sql.ResultSet;
import java.time.format.DateTimeFormatter;
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

    public List<Assignment> getListAssignmentByClassId(String classId) {
        List<Assignment> listAssignment = new ArrayList<>();

        try {
            String sql = "SELECT Id, Title, Description, Type, DurationMinutes, MaxAttempts, "
                    + "ClassId, OpenAt, CloseAt, CreatedAt, CreatedById "
                    + "FROM Assignments WHERE ClassId = ?";

            statement = connection.prepareStatement(sql);
            statement.setString(1, classId);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {

                Assignment a = new Assignment(
                        resultSet.getInt("Id"),
                        resultSet.getString("Title"),
                        resultSet.getString("Description"),
                        resultSet.getInt("Type"),
                        resultSet.getInt("DurationMinutes"),
                        resultSet.getInt("MaxAttempts"),
                        resultSet.getInt("ClassId"),
                        resultSet.getTimestamp("OpenAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getTimestamp("CloseAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getString("CreatedById")
                );

                listAssignment.add(a);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return listAssignment;
    }

    //get list submissions by classId
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

    //get assignment by ID
    public Assignment getAssignmentById(int id) {
        try {
            String sql = "SELECT Id, Title, Description, Type, DurationMinutes, MaxAttempts, "
                    + "ClassId, OpenAt, CloseAt, CreatedAt, CreatedById "
                    + "FROM Assignments WHERE Id = ?";

            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return new Assignment(
                        resultSet.getInt("Id"),
                        resultSet.getString("Title"),
                        resultSet.getString("Description"),
                        resultSet.getInt("Type"),
                        resultSet.getInt("DurationMinutes"),
                        resultSet.getInt("MaxAttempts"),
                        resultSet.getInt("ClassId"),
                        resultSet.getTimestamp("OpenAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getTimestamp("CloseAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")),
                        resultSet.getString("CreatedById")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //create assignment
    public void createAssignment(Assignment a) {

        String sql = "INSERT INTO Assignments (Title,Description,Type,DurationMinutes,"
                + "MaxAttempts,ClassId,OpenAt,CloseAt,CreatedAt,CreatedById)"
                + " VALUES (?,?,?,?,?,?,?,?,GETDATE(),?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setObject(1, a.getTitle());
            st.setObject(2, a.getDescription());
            st.setObject(3, a.getType());
            st.setObject(4, a.getDurationMinutes());
            st.setObject(5, a.getMaxAttempts());
            st.setObject(6, a.getClassId());
            java.sql.Timestamp openAt = null;
            java.sql.Timestamp closeAt = null;

            if (a.getOpenAt() != null && !a.getOpenAt().isEmpty()) {
                openAt = java.sql.Timestamp.valueOf(
                        a.getOpenAt().replace("T", " ") + ":00"
                );
            }

            if (a.getCloseAt() != null && !a.getCloseAt().isEmpty()) {
                closeAt = java.sql.Timestamp.valueOf(
                        a.getCloseAt().replace("T", " ") + ":00"
                );
            }

            st.setTimestamp(7, openAt);
            st.setTimestamp(8, closeAt);;
            st.setObject(9, a.getCreatedById());

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
