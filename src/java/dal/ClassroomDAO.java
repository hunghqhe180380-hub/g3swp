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
public class ClassroomDAO extends DBContext{
    protected PreparedStatement statement;
    protected ResultSet resultSet;
    
    public List<Classroom> getAllClassroom(){
        String sql = "select a.*,b.FullName as TeacherName from [Classrooms] as a\n"
                + "join [Users] as b on a.TeacherId = b.Id";
        List<Classroom> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Classroom classes = new Classroom();
                classes.setId(resultSet.getString("Id"));
                classes.setName(resultSet.getString("Name"));
                classes.setClassCode(resultSet.getString("ClassCode"));
                classes.setSubject(resultSet.getString("Subject"));
                classes.setTeacherId(resultSet.getString("TeacherId"));
                classes.setTeacherName(resultSet.getString("TeacherName"));
                classes.setCreatedAt(resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                classes.setMaxStudent(resultSet.getInt("MaxStudents"));
                list.add(classes);
            }
            statement.close();
            resultSet.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int getSumOfStudent(String classId){
        String sql = "select count(*) as TotalStudent from [Enrollments] where ClassId = ?";
        int sum = 0;
        try{
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            resultSet = statement.executeQuery();
            if(resultSet.next()){
                sum = resultSet.getInt("TotalStudent");
            }
            resultSet.close();
            statement.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
        return sum;
    }
    
    public void deleteClassroom(String classId){
        String sql = "delete from [Classrooms] where Id = ?";
        try{
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            statement.executeUpdate();
            statement.close();
        }catch(SQLException e){
            e.printStackTrace();
        }
    }
}
