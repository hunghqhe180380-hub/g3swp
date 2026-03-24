package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.Classroom;

public class ClassroomDAO extends DBContext {

    private static final DateTimeFormatter FMT =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private static final String BASE_SELECT =
        "SELECT a.Id, a.Name, a.ClassCode, a.SubjectId, a.TeacherId, " +
        "       b.FullName AS TeacherName, a.CreatedAt, a.MaxStudents, " +
        "       a.Status, a.TimeExpiryClassCode, " +
        "       (SELECT COUNT(*) FROM Enrollments e WHERE e.ClassId = a.Id) AS TotalStudent, " +
        "       ISNULL(s.subject_name, a.SubjectId) AS SubjectName " +
        "FROM Classrooms a " +
        "LEFT JOIN Users b ON a.TeacherId = b.Id " +
        "LEFT JOIN Subjects s ON a.SubjectId = s.Id ";

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public List<Classroom> getAllClassBySearch(String search) {
        boolean hasSearch = isNotBlank(search);
        StringBuilder sql = new StringBuilder(BASE_SELECT).append("WHERE 1=1");
        if (hasSearch) sql.append(searchClause());
        sql.append(" ORDER BY a.CreatedAt DESC");

        List<Classroom> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            if (hasSearch) {
                bindSearch(statement, paramIndex, search);
            }
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ─────────────────────────────────────────────────────────────────────
    //  TEACHER-SCOPED LIST
    // ─────────────────────────────────────────────────────────────────────

    public List<Classroom> getClassesByTeacher(String teacherId) {
        String sql = BASE_SELECT + "WHERE a.TeacherId = ? ORDER BY a.CreatedAt DESC";
        List<Classroom> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, teacherId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ─────────────────────────────────────────────────────────────────────
    //  SINGLE RECORD
    // ─────────────────────────────────────────────────────────────────────

    public Classroom getClassById(int classId) {
        String sql = BASE_SELECT + "WHERE a.Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, classId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Classroom getClassInfoByClassId(String classId) {
        try { return getClassById(Integer.parseInt(classId)); }
        catch (NumberFormatException e) { return null; }
    }

    // ─────────────────────────────────────────────────────────────────────
    //  WRITE OPERATIONS
    // ─────────────────────────────────────────────────────────────────────

    public boolean updateClassroom(Classroom c) {
        String sql = "UPDATE [Classrooms] SET Name=?, SubjectId=?, MaxStudents=? WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getSubjectId());
            ps.setInt(3, c.getMaxStudent());
            ps.setInt(4, c.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public void deleteClassroom(String classId) {
        String sql = "DELETE FROM [Classrooms] WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(classId));
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public String getClassIdByCode(String classCode) {
        String sql = "SELECT Id FROM [Classrooms] WHERE ClassCode=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, classCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("Id");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /** Set classroom status: 0=active, 1=deactivated */
    public void setClassroomStatus(String classId, int status) {
        String sql = "UPDATE [Classrooms] SET Status=? WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, Integer.parseInt(classId));
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    /** Returns true if there is at least one active enrollment in the class */
    public boolean hasStudentInClass(String classId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE ClassId=? AND Status=0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(classId));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Returns true if the student is enrolled in the class */
    public boolean isStudentInClass(String userId, String classId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE UserId=? AND ClassId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setInt(2, Integer.parseInt(classId));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Returns true if the teacher created the class */
    public boolean isClassCreatedByTeacher(String userId, String classId) {
        String sql = "SELECT COUNT(*) FROM Classrooms WHERE TeacherId=? AND Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setInt(2, Integer.parseInt(classId));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Clear expired class codes */
    public void clearExpiredClassCode() {
        String sql = "UPDATE Classrooms SET ClassCode=NULL " +
                     "WHERE TimeExpiryClassCode IS NOT NULL AND TimeExpiryClassCode < GETDATE()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // ─────────────────────────────────────────────────────────────────────
    //  PRIVATE HELPERS
    // ─────────────────────────────────────────────────────────────────────

    private Classroom mapRow(ResultSet rs) throws SQLException {
        Classroom c = new Classroom();
        c.setId(rs.getInt("Id"));
        c.setName(rs.getString("Name"));
        c.setClassCode(rs.getString("ClassCode"));
        c.setSubjectId(rs.getString("SubjectId"));
        // Use the resolved subject name from LEFT JOIN Subjects
        try { c.setSubject(rs.getString("SubjectName")); } catch (SQLException ignored) {
            c.setSubject(rs.getString("SubjectId"));
        }

        c.setTeacherId(rs.getString("TeacherId"));
        c.setTeacherName(rs.getString("TeacherName"));
        if (rs.getTimestamp("CreatedAt") != null)
            c.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime().format(FMT));
        c.setMaxStudent(rs.getInt("MaxStudents"));
        c.setSum(rs.getInt("TotalStudent"));
        try { c.setStatus(rs.getBoolean("Status") ? 1 : 0); } catch (SQLException ignored) {}
        try {
            if (rs.getTimestamp("TimeExpiryClassCode") != null)
                c.setTimeExpiryClassCode(rs.getTimestamp("TimeExpiryClassCode")
                        .toLocalDateTime().format(FMT));
        } catch (SQLException ignored) {}
        return c;
    }

    private static String searchClause() {
        // SQL Server with default collation is already case-insensitive — no need for LOWER()
        // Search by class name, class code, teacher name, and subject name
        return " AND (a.Name LIKE ? OR a.ClassCode LIKE ?" +
               " OR b.FullName LIKE ? OR ISNULL(s.subject_name, a.SubjectId) LIKE ?)";
    }

    private static int bindSearch(PreparedStatement ps, int start, String search)
            throws SQLException {
        String p = "%" + search.trim().toLowerCase() + "%";
        // Dùng setNString để hỗ trợ tìm kiếm Tiếng Việt có dấu (truyền param dưới dạng NVARCHAR)
        ps.setNString(start,   p);
        ps.setNString(start+1, p);
        ps.setNString(start+2, p);
        ps.setNString(start+3, p);
        return start + 4;
    }

    private static boolean isNotBlank(String s) {
        return s != null && !s.trim().isEmpty();
    }
}