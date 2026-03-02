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

    // ── Base SELECT shared by all read queries ─────────────────────────────
    private static final String BASE_SELECT =
        "SELECT a.Id, a.Name, a.ClassCode, a.Subject, a.TeacherId, " +
        "       a.CreatedAt, a.MaxStudents, " +
        "       b.FullName AS TeacherName, " +
        "       (SELECT COUNT(*) FROM [Enrollments] e WHERE e.ClassId = a.Id) AS TotalStudent " +
        "FROM [Classrooms] a " +
        "JOIN [Users] b ON a.TeacherId = b.Id ";

    // ─────────────────────────────────────────────────────────────────────
    //  COUNT  (for pagination metadata)
    // ─────────────────────────────────────────────────────────────────────

    public int countAllClasses(String search) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM [Classrooms] a " +
            "JOIN [Users] b ON a.TeacherId = b.Id WHERE 1=1"
        );
        boolean hasSearch = isNotBlank(search);
        if (hasSearch) sql.append(searchClause());

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            if (hasSearch) bindSearch(ps, 1, search);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ─────────────────────────────────────────────────────────────────────
    //  PAGED LIST  (SQL-level OFFSET / FETCH)
    // ─────────────────────────────────────────────────────────────────────

    public List<Classroom> getClassesPaged(String search,
                                           String sortCol, String sortDir,
                                           int offset, int pageSize) {
        String orderBy = switch (sortCol == null ? "" : sortCol.toLowerCase()) {
            case "name"    -> "a.Name";
            case "teacher" -> "b.FullName";
            default        -> "a.CreatedAt";
        };
        String dir = "asc".equalsIgnoreCase(sortDir) ? "ASC" : "DESC";

        boolean hasSearch = isNotBlank(search);
        StringBuilder sql = new StringBuilder(BASE_SELECT).append("WHERE 1=1");
        if (hasSearch) sql.append(searchClause());
        sql.append(" ORDER BY ").append(orderBy).append(" ").append(dir);
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Classroom> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasSearch) idx = bindSearch(ps, idx, search);
            ps.setInt(idx++, offset);
            ps.setInt(idx,   pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ─────────────────────────────────────────────────────────────────────
    //  ALL + SEARCH  (in-memory sort + PagingUtil approach)
    // ─────────────────────────────────────────────────────────────────────

    public List<Classroom> getAllClassBySearch(String search) {
        boolean hasSearch = isNotBlank(search);
        StringBuilder sql = new StringBuilder(BASE_SELECT).append("WHERE 1=1");
        if (hasSearch) sql.append(searchClause());
        sql.append(" ORDER BY a.CreatedAt DESC");

        List<Classroom> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            if (hasSearch) bindSearch(ps, 1, search);
            try (ResultSet rs = ps.executeQuery()) {
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
        String sql = "UPDATE [Classrooms] SET Name=?, Subject=?, MaxStudents=? WHERE Id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getSubject());
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

    // ─────────────────────────────────────────────────────────────────────
    //  PRIVATE HELPERS
    // ─────────────────────────────────────────────────────────────────────

    private Classroom mapRow(ResultSet rs) throws SQLException {
        Classroom c = new Classroom();
        c.setId(rs.getInt("Id"));
        c.setName(rs.getString("Name"));
        c.setClassCode(rs.getString("ClassCode"));
        c.setSubject(rs.getString("Subject"));
        c.setTeacherId(rs.getString("TeacherId"));
        c.setTeacherName(rs.getString("TeacherName"));
        if (rs.getTimestamp("CreatedAt") != null)
            c.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime().format(FMT));
        c.setMaxStudent(rs.getInt("MaxStudents"));
        c.setSum(rs.getInt("TotalStudent"));
        return c;
    }

    private static String searchClause() {
        return " AND (LOWER(a.Name) LIKE ? OR LOWER(a.ClassCode) LIKE ?" +
               " OR LOWER(a.Subject) LIKE ? OR LOWER(b.FullName) LIKE ?)";
    }

    /** Bind 4 LIKE params; returns next available param index. */
    private static int bindSearch(PreparedStatement ps, int start, String search)
            throws SQLException {
        String p = "%" + search.trim().toLowerCase() + "%";
        ps.setString(start,   p);
        ps.setString(start+1, p);
        ps.setString(start+2, p);
        ps.setString(start+3, p);
        return start + 4;
    }

    private static boolean isNotBlank(String s) {
        return s != null && !s.trim().isEmpty();
    }
}
