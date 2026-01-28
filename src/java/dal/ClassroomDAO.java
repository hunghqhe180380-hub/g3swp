/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Classroom;

public class ClassroomDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public List<Classroom> getAllClassroom() {
        String sql = "SELECT * FROM [Classrooms]";
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

    // ✅ METHOD INSERT – CÁI MÀ CONTROLLER ĐANG GỌI
    public void insert(Classroom c) {
        String sql = """
            INSERT INTO Classrooms
            (Name, ClassCode, Subject, TeacherId, CreatedAt, MaxStudents)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, c.getName());
            statement.setString(2, c.getClassCode());
            statement.setString(3, c.getSubject());
            statement.setString(4, c.getTeacherId());
            statement.setTimestamp(5, Timestamp.valueOf(c.getCreatedAt()));
            statement.setInt(6, c.getMaxStudent());

            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void getTeacherNameById(String id) {
        // TODO
    }
}
