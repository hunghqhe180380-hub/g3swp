/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
            String sql = "SELECT [ClassId]\n"
                    + ",c.Name\n"
                    + "      ,[RoleInClass]\n"
                    + "      ,c.Subject\n"
                    + "      ,c.MaxStudents\n"
                    + "  FROM [dbo].[Enrollments] e\n"
                    + "  JOIN [dbo].[Classrooms] c\n"
                    + "  on e.ClassId = c.Id\n"
                    + "  where UserId = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Classroom cls = new Classroom();
                cls.setClassCode(userId);
                cls.setName(resultSet.getString("Name"));
                cls.setSubject(resultSet.getString("Subject"));
                cls.setMaxStudent(resultSet.getInt("MaxStudents"));
                cls.setSum(teacherDAO.getSumStudentEnrolledByClassId(resultSet.getInt("ClassId")));
                listClassroom.add(cls);
            }
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
            if(resultSet.next()){
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
            statement.executeQuery();
        } catch (Exception e) {
            e.printStackTrace();
        }
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
