package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.Classroom;

public class ClassroomDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    // ✅ LẤY TẤT CẢ CLASS + TÊN GIÁO VIÊN
    public List<Classroom> getAllClassroom() {
        String sql = "select a.*, b.FullName as TeacherName "
                   + "from [Classrooms] as a "
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
                classes.setCreatedAt(
                    resultSet.getTimestamp("CreatedAt")
                             .toLocalDateTime()
                             .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                );
                classes.setMaxStudent(resultSet.getInt("MaxStudents"));
                list.add(classes);
            }

            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ INSERT CLASSROOM (CONTROLLER ĐANG GỌI)
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
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ ĐẾM SỐ HỌC SINH TRONG LỚP
    public int getSumOfStudent(String classId) {
        String sql = "select count(*) as TotalStudent from [Enrollments] where ClassId = ?";
        int sum = 0;

        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, classId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                sum = resultSet.getInt("TotalStudent");
            }

            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sum;
    }

    // ✅ XÓA CLASSROOM
    public void deleteClassroom(String classId) {
        String sql = "delete from [Classrooms] where Id = ?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, classId);
            statement.executeUpdate();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

