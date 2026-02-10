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

/**
 *
 * @author BINH
 */
public class ClassroomDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public List<Classroom> getAllClassroom(String search) {
        String sql = "select a.*,b.FullName as TeacherName,"
                + "(select count(*) from [Enrollments] where ClassId = a.Id) as TotalStudent\n"
                + "from [Classrooms] as a\n"
                + "join [Users] as b on a.TeacherId = b.Id";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (LOWER(a.Name) LIKE ? OR LOWER(a.ClassCode) LIKE ? OR LOWER(a.Subject) LIKE ? OR LOWER(b.FullName) LIKE ?)";
        }
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
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Classroom classes = new Classroom();
                classes.setId(resultSet.getInt("Id"));
                classes.setName(resultSet.getString("Name"));
                classes.setClassCode(resultSet.getString("ClassCode"));
                classes.setSubject(resultSet.getString("Subject"));
                classes.setTeacherId(resultSet.getString("TeacherId"));
                classes.setTeacherName(resultSet.getString("TeacherName"));
                classes.setCreatedAt(resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                classes.setMaxStudent(resultSet.getInt("MaxStudents"));
                classes.setSum(resultSet.getInt("TotalStudent"));
                list.add(classes);
            }
            statement.close();
            resultSet.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteClassroom(String classId) {
        String sql = "delete from [Classrooms] where Id = ?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            statement.executeUpdate();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    

}
