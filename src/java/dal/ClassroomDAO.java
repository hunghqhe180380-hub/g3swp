/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        String sql = "select * from [Classrooms]";
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
                classes.setCreatedAt(resultSet.getTimestamp("CreatedAt").toLocalDateTime());
                classes.setMaxStudent(resultSet.getInt("MaxStudents"));
                list.add(classes);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public void getTeacherNameById(String id){
        
    }
}
