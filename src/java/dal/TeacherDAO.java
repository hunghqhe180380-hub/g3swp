/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.format.DateTimeFormatter;
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
    public String createNewClass(String className,
            String subject,
            String teacherId,
            String studentLimit) {
        String genClassCode = generateClassCode();
        try {
            String sql = "INSERT INTO [dbo].[Classrooms]\n"
                    + "           ([Name]\n"
                    + "           ,[ClassCode]\n"
                    + "           ,[Subject]\n"
                    + "           ,[TeacherId]\n"
                    + "           ,[CreatedAt]\n"
                    + "           ,[MaxStudents]\n"
                    + "           ,[TimeExpiryClassCode])"
                    + "     VALUES\n"
                    + "           (?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,GETDATE()\n"
                    + "           ,?\n"
                    + "           ,DATEADD(MINUTE, 2, GETDATE())"
                    + ")";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, className);
            statement.setObject(2, genClassCode);
            statement.setObject(3, subject);
            statement.setObject(4, teacherId);
            statement.setObject(5, studentLimit);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return genClassCode;
    }

    //check class  exist
    public boolean isExistClass(String teacherId, String className, String subject) {
        String sql = "SELECT [Name], [Subject], [TeacherId] FROM [dbo].[Classrooms]\n"
                + "where [Name] = ? and [Subject] = ? and [TeacherId] = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, className);
            ps.setString(2, subject);
            ps.setString(3, teacherId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //generate class code
    public String generateClassCode() {

        Random random = new Random();

        // 3 chữ cái in hoa
        char firstLetter = (char) ('A' + random.nextInt(26));
        char secondLetter = (char) ('A' + random.nextInt(26));
        char thirdLetter = (char) ('A' + random.nextInt(26));

        // 3 chữ số (000 - 999)
        int number = random.nextInt(1000);

        return "" + firstLetter + secondLetter + thirdLetter + String.format("%03d", number);
    }

    //get techer's class list by teacher's id
    public List<Classroom> getClassListByTeacherId(String teacherId) {

        List<Classroom> listClass = new ArrayList<>();

        String sql = "SELECT c.Id, CASE \n"
                + "        WHEN c.TimeExpiryClassCode < GETDATE() THEN NULL\n"
                + "        ELSE c.ClassCode\n"
                + "    END AS ClassCode, c.TimeExpiryClassCode,c.Name, c.Subject, c.MaxStudents, c.CreatedAt, \n"
                + "                  COUNT(e.UserId) AS TotalStudents \n"
                + "                              FROM Classrooms c\n"
                + "                            LEFT JOIN Enrollments e\n"
                + "                               ON c.Id = e.ClassId AND e.Status = 0 \n"
                + "				WHERE c.TeacherId = ?\n"
                + "                GROUP BY c.Id, c.Name, c.Subject, c.MaxStudents, c.ClassCode, c.CreatedAt, c.TimeExpiryClassCode";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, teacherId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Classroom cls = new Classroom();
                cls.setId(resultSet.getInt("Id"));
                cls.setName(resultSet.getString("Name"));
                cls.setSubject(resultSet.getString("Subject"));
                cls.setMaxStudent(resultSet.getInt("MaxStudents"));
                cls.setSum(resultSet.getInt("TotalStudents"));
                cls.setClassCode(resultSet.getString("ClassCode"));
                cls.setCreatedAt(resultSet.getTimestamp("CreatedAt")
                                .toLocalDateTime()
                                .format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
                );
                if (resultSet.getTimestamp("TimeExpiryClassCode") != null) {
                    cls.setTimeExpiryClassCode(
                            resultSet.getTimestamp("TimeExpiryClassCode")
                                    .toLocalDateTime()
                                    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                    );
                }
                listClass.add(cls);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return listClass;
    }

    //check class is full slot?
    public boolean isClassFull(String classCode) {
        try {
            String sql = "SELECT c.ClassCode, c.Id, c.Name, c.Subject, c.MaxStudents, \n"
                    + "                COUNT(e.UserId) AS TotalStudents\n"
                    + "                FROM Classrooms c \n"
                    + "                LEFT JOIN Enrollments e \n"
                    + "                ON c.Id = e.ClassId AND e.Status = 0 \n"
                    + "                Where c.ClassCode = ? \n"
                    + "                GROUP BY c.Id, c.Name, c.Subject, c.MaxStudents, c.ClassCode";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classCode);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                int max = resultSet.getInt("MaxStudents");
                int sum = resultSet.getInt("TotalStudents");
                return sum >= max;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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

    //update classcode of this teacher by classId
    public void setNewClassCode(String newClassCode, String classId) {
        try {
            String sql = "UPDATE [dbo].[Classrooms]\n"
                    + "   SET [ClassCode] = ?,\n"
                    + "      [TimeExpiryClassCode] = DATEADD(MINUTE, 2, GETDATE())\n"
                    + " WHERE [Id] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, newClassCode);
            statement.setObject(2, classId);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
