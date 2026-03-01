/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import model.Classroom;

/**
 *
 * @author hung2
 */
public class TeacherDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    //create new class
    public void createNewClass(String className,
             String subject,
             String teacherId,
             String studentLimit) {
        try {
            String sql = "INSERT INTO [dbo].[Classrooms]\n"
                    + "           ([Name]\n"
                    + "           ,[ClassCode]\n"
                    + "           ,[Subject]\n"
                    + "           ,[TeacherId]\n"
                    + "           ,[CreatedAt]\n"
                    + "           ,[MaxStudents])\n"
                    + "     VALUES\n"
                    + "           (?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,GETDATE()\n"
                    + "           ,?)";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, className);
            statement.setObject(2, generateClassCode());
            statement.setObject(3, subject);
            statement.setObject(4, teacherId);
            statement.setObject(5, studentLimit);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //generate class code
    private String generateClassCode() {

        Random random = new Random();

        // 2 chữ cái in hoa
        char firstLetter = (char) ('A' + random.nextInt(26));
        char secondLetter = (char) ('A' + random.nextInt(26));

        // 3 chữ số (000 - 999)
        int number = random.nextInt(1000);

        return "" + firstLetter + secondLetter + String.format("%03d", number);
    }

    public List<Classroom> getClassListByTeacherId(String teacherId) {

    List<Classroom> listClass = new ArrayList<>();

    String sql = "SELECT c.Id, c.Name, c.Subject, c.MaxStudents, "
            + "COUNT(e.UserId) AS TotalStudents "
            + "FROM Classrooms c "
            + "LEFT JOIN Enrollments e "
            + "ON c.Id = e.ClassId AND e.Status = 0 "
            + "WHERE c.TeacherId = ? "
            + "GROUP BY c.Id, c.Name, c.Subject, c.MaxStudents";

    try (PreparedStatement statement = connection.prepareStatement(sql)) {

        statement.setString(1, teacherId);
        ResultSet rs = statement.executeQuery();
        while (rs.next()) {
            Classroom cls = new Classroom();

            cls.setId(rs.getInt("Id"));
            cls.setName(rs.getString("Name"));
            cls.setSubject(rs.getString("Subject"));
            cls.setMaxStudent(rs.getInt("MaxStudents"));
            cls.setSum(rs.getInt("TotalStudents"));
            listClass.add(cls);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return listClass;
}
    
// check exist class by (is created by this teacher)
    

//get number sutdent joined this class 
    public int getSumStudentEnrolledByClassId(int classId) {
        int total = 0;
        try {
            String sql = "SELECT [UserId]\n"
                    + "      ,[Status]\n"
                    + "  FROM [dbo].[Enrollments]\n"
                    + "  where ClassId = ? AND [Status] = 0";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                total++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
}
