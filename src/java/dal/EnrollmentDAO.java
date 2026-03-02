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
import model.*;

/**
 *
 * @author BINH
 */
public class EnrollmentDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public List<Enrollment> getEnrollmentByClassId(String search, String classId, String[] status) {
        String sql = "SELECT a.*,b.* FROM [Enrollments] as a\n"
                + "JOIN [Users] as b ON a.UserId = b.Id\n"                
                + "WHERE a.ClassId =?";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (LOWER(b.FullName) LIKE ? OR LOWER(b.UserName) LIKE ? OR LOWER(b.Email) LIKE ?)";
        }
        boolean hasStatus = (status != null && status.length > 0);
        if (hasStatus) {
            sql += (" AND a.Status IN (");
            for (int i = 0; i < status.length; i++) {
                sql += ("?");
                if (i < status.length - 1) {
                    sql += (",");
                }
            }
            sql += (") ");
        }
        List<Enrollment> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            int paramIndex = 2;
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.toLowerCase() + "%";
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
            }
            if (hasStatus) {
                for (String s : status) {
                    statement.setObject(paramIndex++, s);
                }
            }
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Enrollment enroll = new Enrollment();
                enroll.setId(resultSet.getInt("Id"));
                enroll.setClassId(resultSet.getInt("ClassId"));
                enroll.setUserId(resultSet.getString("UserId"));
                enroll.setUser(new User(resultSet.getString("UserName"), resultSet.getString("FullName"), resultSet.getString("Email")));
                enroll.setRoleInClass(resultSet.getString("RoleInClass"));
                enroll.setJoinedAt(resultSet.getTimestamp("JoinedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                enroll.setStatus(resultSet.getInt("Status"));
                list.add(enroll);
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

//    public List<Enrollment> getUserInforByName(String name, String classId) {
//        String sql = "SELECT a.*,b.FullName,b.UserName,b.Email FROM [Enrollments] as a\n"
//                + "JOIN [Users] as b ON a.UserId = b.Id\n"
//                + "WHERE (LOWER(b.FullName) LIKE ? OR LOWER(b.UserName) LIKE ? OR LOWER(b.Email) LIKE ?) and a.ClassId =?";
//        List<Enrollment> list = new ArrayList<>();
//        try {
//            statement = connection.prepareStatement(sql);
//            String searchPattern = "%" + (name == null ? "" : name.toLowerCase()) + "%";
//            statement.setObject(1, searchPattern);
//            statement.setObject(2, searchPattern);
//            statement.setObject(3, searchPattern);
//            statement.setObject(4, classId);
//            resultSet = statement.executeQuery();
//            while (resultSet.next()) {
//                Enrollment enroll = new Enrollment();
//                enroll.setId(resultSet.getInt("Id"));
//                enroll.setClassId(resultSet.getInt("ClassId"));
//                enroll.setUserId(resultSet.getString("UserId"));
//                enroll.setUser(new User(resultSet.getString("UserName"), resultSet.getString("FullName"), resultSet.getString("Email")));
//                enroll.setRoleInClass(resultSet.getString("RoleInClass"));
//                enroll.setJoinedAt(resultSet.getTimestamp("JoinedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
//                enroll.setStatus(resultSet.getInt("Status"));
//                list.add(enroll);
//            }
//            resultSet.close();
//            statement.close();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }

    public void kickOutStudent(String userId, String classId) {
        String sql = "delete from [Enrollments] where userId =? and classId =?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userId);
            statement.setObject(2, classId);
            statement.executeUpdate();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void changeStudentStatus(String userId, String classId, String status) {
        if (status.equals("0")) {
            status = "1";
        } else {
            status = "0";
        }
        String sql = "UPDATE [Enrollments]\n"
                + "SET [Status] = ?\n"
                + "WHERE userId =? and classId =?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(2, userId);
            statement.setObject(3, classId);
            statement.setObject(1, status);
            statement.executeUpdate();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }    

    public boolean isUnenroll(String userId, String classId) {
        boolean enroll = false;
        String sql = "SELECT Status from [Enrollments] WHERE UserId =? and ClassId =?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userId);
            statement.setObject(2, classId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                enroll = resultSet.getBoolean("Status") ? true : false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return enroll;
    }

}
