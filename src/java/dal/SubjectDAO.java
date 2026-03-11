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
import java.util.Random;
import model.Subject;

/**
 *
 * @author hung2
 */
public class SubjectDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    //get list subject (id, name, total classes, total teachers)
    public List<Subject> getListSubject() {
        List<Subject> listSubject = new ArrayList<>();
        try {
            String sql = "SELECT s.Id, s.subject_name, COUNT(c.teacherId) AS total_teacher, "
                    + "COUNT(c.Id) AS total_classes, s.is_active, s.create_at "
                    + "FROM Subjects s "
                    + "LEFT JOIN Classrooms c ON s.Id = c.SubjectId "
                    + "GROUP BY s.Id, s.subject_name, s.is_active, s.create_at";
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                listSubject.add(new Subject(resultSet.getString("Id"),
                        resultSet.getString("subject_name"),
                        resultSet.getInt("total_classes"),
                        resultSet.getInt("total_teacher"),
                        resultSet.getInt("is_active"),
                        resultSet.getTimestamp("create_at").toLocalDateTime()
                                .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return listSubject;
    }

    //create new subject
    public void createSubject(String subjectName) {
        try {
            String sql = "INSERT INTO [dbo].[Subjects]\n"
                    + "           ([Id]\n"
                    + "           ,[subject_name]\n"
                    + "           ,[is_active]\n"
                    + "           ,[create_at])\n"
                    + "     VALUES\n"
                    + "           (?\n"
                    + "           ,?\n"
                    + "           ,1\n"
                    + "           ,GETDATE())";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, generateSubjectId());
            statement.setObject(2, subjectName);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //generate subject's id 
    public String generateSubjectId() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random rand = new Random();

        StringBuilder id = new StringBuilder();

        for (int i = 0; i < 6; i++) {
            id.append(chars.charAt(rand.nextInt(chars.length())));
        }

        return id.toString();
    }
}
