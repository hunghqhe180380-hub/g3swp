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

    public List<Classroom> getAllClassroom() {
        String sql = "select a.*,b.FullName as TeacherName,"
                + "(select count(*) from [Enrollments] where ClassId = a.Id) as TotalStudent\n"
                + "from [Classrooms] as a\n"
                + "join [Users] as b on a.TeacherId = b.Id";
        List<Classroom> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
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
                classes.setSumOfStudent(resultSet.getInt("TotalStudent"));
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

    public List<Classroom> getClassInforByName(String string) {
        String sql = "SELECT a.*,b.FullName as TeacherName FROM [Classrooms] as a\n"
                + "JOIN [Users] as b on b.Id = a.TeacherId\n"
                + "WHERE LOWER(a.Name) LIKE ? OR LOWER(a.ClassCode) LIKE ?\n"
                + "OR LOWER(a.Subject) LIKE ? OR LOWER(b.FullName) LIKE ?";
        List<Classroom> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            String pattern = "%" + (string == null ? "" : string.toLowerCase()) + "%";
            statement.setObject(1, pattern);
            statement.setObject(2, pattern);
            statement.setObject(3, pattern);
            statement.setObject(4, pattern);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Classroom classroom = new Classroom();
                classroom.setId(resultSet.getInt("Id"));
                classroom.setName(resultSet.getString("Name"));
                classroom.setClassCode(resultSet.getString("ClassCode"));
                classroom.setSubject(resultSet.getString("Subject"));
                classroom.setTeacherId(resultSet.getString("TeacherId"));
                classroom.setTeacherName(resultSet.getString("TeacherName"));
                classroom.setCreatedAt(resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                classroom.setMaxStudent(resultSet.getInt("MaxStudents"));
                list.add(classroom);
            }
            resultSet.close();
            statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Classroom getClassInfoByClassId(String classId){
        String sql = "SELECT a.Name,"
                + "(SELECT COUNT(*) FROM [Enrollments] WHERE ClassId = a.Id) as TotalStudent\n"
                + "FROM [Classrooms] as a WHERE a.Id = ?";
        try{
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            resultSet = statement.executeQuery();
            if(resultSet.next()){
                Classroom cl = new Classroom();
                cl.setName(resultSet.getString("Name"));
                cl.setSumOfStudent(resultSet.getInt("TotalStudent"));
                return cl;
            }
            resultSet.close();
            statement.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
        return null;
    }
}