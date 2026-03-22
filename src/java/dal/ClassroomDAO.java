/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.Classroom;

public class ClassroomDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public List<Classroom> getAllClassBySearch(String search) {
        boolean hasSearch = isNotBlank(search);
        StringBuilder sql = new StringBuilder(BASE_SELECT).append("WHERE 1=1");
        if (hasSearch) sql.append(searchClause());
        sql.append(" ORDER BY a.CreatedAt DESC");

        List<Classroom> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.toLowerCase() + "%";
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
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