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
import model.Classroom;

/**
 *
 * @author hung2
 */
public class StudentDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    //get list joined classes of student by student's id
    public List<Classroom> getListClassJoined(String userId) {
        List<Classroom> listClassroom = new ArrayList<>();
        TeacherDAO teacherDAO = new TeacherDAO();
        try {
            String sql = "SELECT \n"
                    + "    e.ClassId,\n"
                    + "    c.Name AS Class_name,\n"
                    + "    c.CreatedAt,\n"
                    + "    t.Id AS TeacherId,\n"
                    + "    t.FullName AS TeacherName,\n"
                    + "    s.subject_name,\n"
                    + "    s.Id AS subject_id,\n"
                    + "    c.MaxStudents\n"
                    + "FROM Enrollments e\n"
                    + "\n"
                    + "JOIN Classrooms c\n"
                    + "    ON c.Id = e.ClassId\n"
                    + "\n"
                    + "LEFT JOIN Subjects s\n"
                    + "    ON c.SubjectId = s.Id\n"
                    + "\n"
                    + "LEFT JOIN Users t\n"
                    + "    ON c.TeacherId = t.Id\n"
                    + "\n"
                    + "WHERE e.UserId = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                System.out.println("+++");
                Classroom cls = new Classroom();
                System.out.println("ClasId: " + resultSet.getInt("ClassId"));
                cls.setId(resultSet.getInt("ClassId"));
                cls.setName(resultSet.getString("Class_name"));
                cls.setSubjectName(resultSet.getString("subject_name"));
                cls.setSubjectId(resultSet.getString("subject_id"));
                cls.setTeacherId(resultSet.getString("TeacherId"));
                cls.setTeacherName(resultSet.getString("TeacherName"));
                cls.setCreatedAt(resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                cls.setMaxStudent(resultSet.getInt("MaxStudents"));
                cls.setSum(getTotalStudentByClassId(resultSet.getInt("ClassId")));
                listClassroom.add(cls);
            }
            System.out.println("ListClassroommomo: " + listClassroom.size());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listClassroom;
    }

    //check student already join class?
    public boolean isJoinedClass(String userId, String classCode) {
        ClassroomDAO clsDAO = new ClassroomDAO();
        String classId = clsDAO.getClassIdByCode(classCode);
        try {
            String sql = "SELECT[ClassId]\n"
                    + "      ,[UserId]\n"
                    + "  FROM [dbo].[Enrollments]\n"
                    + "  where UserId = ? and ClassId = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userId);
            statement.setObject(2, classId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //join class
    public void joinClass(String classId, String userId) {
        try {
            String sql = "INSERT INTO [dbo].[Enrollments]\n"
                    + "           ([ClassId]\n"
                    + "           ,[UserId]\n"
                    + "           ,[RoleInClass]\n"
                    + "           ,[JoinedAt]\n"
                    + "           ,[Status])\n"
                    + "     VALUES\n"
                    + "           (?\n"
                    + "           ,?\n"
                    + "           ,'Student'\n"
                    + "           ,GETDATE()\n"
                    + "           ,0)";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            statement.setObject(2, userId);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //leave class
    public void leaveClassByClassId(String userId, String classId) {
        try {
            String sql = "DELETE FROM [dbo].[Enrollments]\n"
                    + "      WHERE UserId = ? AND ClassId = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userId);
            statement.setObject(2, classId);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //get totalStudent in this class
    public int getTotalStudentByClassId(int classId) {
        int sum = 0;
        try {
            String sql = "SELECT COUNT(*) FROM Enrollments WHERE ClassId = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setObject(1, classId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                sum = rs.getInt(1);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return sum;
    }

//    private Classroom getClassById(String classId) {
//        Classroom cls = new Classroom();
//        try {
//            String sql = "";
//            statement = connection.prepareStatement(sql);
//            statement.setObject(1, classId);
//            resultSet = statement.executeQuery();
//            while (resultSet.next()) {
//                cls = new Classroom(sql,
//                        sql,
//                        getSumStudentEnrolledByClassId(classId));
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return cls;
//    }
}
