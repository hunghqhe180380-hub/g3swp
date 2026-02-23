package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.*;

/**
 * MaterialDAO – JDBC data access for Materials table.
 * Includes list, findById, insert (upload), update (edit), delete.
 */
public class MaterialDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    // ── existing methods (unchanged) ─────────────────────────────────────────

    public List<Material> getMaterialByClassId(String search, String classId) {
        String sql = "SELECT * FROM [Materials] WHERE ClassId=?";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (LOWER(Title) LIKE ? OR LOWER(Provider) LIKE ?)";
        }
        List<Material> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            int paramIndex = 2;
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.toLowerCase() + "%";
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                list.add(mapFull(resultSet));
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Classroom getClassInfoByClassId(String classId) {
        String sql = "SELECT a.*, "
                + "(SELECT COUNT(*) FROM [Materials] WHERE ClassId = a.Id) as TotalMaterial "
                + "FROM [Classrooms] as a WHERE a.Id = ?";
        Classroom cl = new Classroom();
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                cl.setId(resultSet.getInt("Id"));
                cl.setName(resultSet.getString("Name"));
                cl.setSum(resultSet.getInt("TotalMaterial"));
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cl;
    }

    public void deleteMaterialById(String id, String classId) {
        String sql = "DELETE FROM [Materials] WHERE Id=? AND ClassId=?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, id);
            statement.setObject(2, classId);
            statement.executeUpdate();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ── new methods ──────────────────────────────────────────────────────────

    /** Find a single material by its primary key. Returns null if not found. */
    public Material findById(int id) {
        String sql = "SELECT * FROM [Materials] WHERE Id=?";
        Material m = null;
        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                m = mapFull(resultSet);
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return m;
    }

    /**
     * Insert a new material row.
     * Mirrors C# Create POST logic: sets all fields including file/url/note metadata.
     */
    public boolean insertMaterial(Material m) {
        String sql = "INSERT INTO [Materials] "
                + "(ClassId, Title, Description, FileUrl, OriginalFileName, FileSizeBytes, "
                + " ExternalUrl, Provider, MediaKind, ThumbnailUrl, Category, IndexContent, "
                + " CreatedAt, CreatedById) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, m.getClassId());
            statement.setString(2, m.getTitle());
            statement.setString(3, m.getDescription());
            statement.setString(4, m.getFileUrl());
            statement.setString(5, m.getOriginalFileName());
            if (m.getFileSize() > 0) {
                statement.setLong(6, m.getFileSize());
            } else {
                statement.setNull(6, java.sql.Types.BIGINT);
            }
            statement.setString(7, m.getExternalUrl());
            statement.setString(8, m.getProvider());
            statement.setString(9, m.getMediaKind());
            statement.setString(10, m.getThumbnailUrl());
            statement.setString(11, m.getCategory());
            statement.setString(12, m.getIndexContent());
            statement.setTimestamp(13, Timestamp.valueOf(LocalDateTime.now()));
            statement.setString(14, m.getCreatedById());
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update an existing material row.
     * Mirrors C# Edit POST logic: updates editable fields + file/url/note metadata.
     */
    public boolean updateMaterial(Material m) {
        String sql = "UPDATE [Materials] SET "
                + "Title=?, Description=?, Category=?, IndexContent=?, "
                + "FileUrl=?, OriginalFileName=?, FileSizeBytes=?, "
                + "ExternalUrl=?, Provider=?, MediaKind=?, ThumbnailUrl=?, "
                + "UpdatedAt=? "
                + "WHERE Id=?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, m.getTitle());
            statement.setString(2, m.getDescription());
            statement.setString(3, m.getCategory());
            statement.setString(4, m.getIndexContent());
            statement.setString(5, m.getFileUrl());
            statement.setString(6, m.getOriginalFileName());
            if (m.getFileSize() > 0) {
                statement.setLong(7, m.getFileSize());
            } else {
                statement.setNull(7, java.sql.Types.BIGINT);
            }
            statement.setString(8, m.getExternalUrl());
            statement.setString(9, m.getProvider());
            statement.setString(10, m.getMediaKind());
            statement.setString(11, m.getThumbnailUrl());
            statement.setTimestamp(12, Timestamp.valueOf(LocalDateTime.now()));
            statement.setInt(13, m.getId());
            int rows = statement.executeUpdate();
            statement.close();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Get Classroom by its int Id (for owner/name lookup). */
    public Classroom getClassById(int classId) {
        String sql = "SELECT * FROM [Classrooms] WHERE Id=?";
        Classroom cl = null;
        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, classId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                cl = new Classroom();
                cl.setId(resultSet.getInt("Id"));
                cl.setName(resultSet.getString("Name"));
                cl.setTeacherId(resultSet.getString("TeacherId"));
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cl;
    }

    // ── private mapper ───────────────────────────────────────────────────────

    private Material mapFull(ResultSet rs) throws SQLException {
        Material m = new Material();
        m.setId(rs.getInt("Id"));
        m.setClassId(rs.getInt("ClassId"));
        m.setTitle(rs.getString("Title"));
        m.setDescription(rs.getString("Description"));
        m.setFileUrl(rs.getString("FileUrl"));
        m.setOriginalFileName(rs.getString("OriginalFileName"));
        long sz = rs.getLong("FileSizeBytes");
        m.setFileSize(rs.wasNull() ? 0 : sz);
        m.setExternalUrl(rs.getString("ExternalUrl"));
        m.setProvider(rs.getString("Provider"));
        m.setMediaKind(rs.getString("MediaKind"));
        m.setThumbnailUrl(rs.getString("ThumbnailUrl"));
        m.setCategory(rs.getString("Category"));
        m.setIndexContent(rs.getString("IndexContent"));
        m.setCreatedById(rs.getString("CreatedById"));

        Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) {
            m.setCreatedAt(ts.toLocalDateTime()
                    .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
        }
        Timestamp uts = rs.getTimestamp("UpdatedAt");
        if (uts != null) {
            m.setUpdateAt(uts.toLocalDateTime()
                    .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
        }
        return m;
    }
}
