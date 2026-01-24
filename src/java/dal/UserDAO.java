/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author hung2
 */
public class UserDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    // register => confirm email
    // login => only allow login if email is confirmed 
    
    //login success ? return userID and this role : null 
    public User isLogin(String name, String password) {
        //verify user login via email
        try {
            //get user's information from database SSMS
              String sql = "select a.Id as UserID, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash\n"
                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
                    + "  on a.Id = b.UserId\n"
                    + "  join [dbo].[Roles] as c\n"
                    + "  on b.RoleId = c.Id\n "
                    + "where [Email] = ?" + " and a.PasswordHash = ? ";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, name);
            statement.setObject(2, password);
            resultSet = statement.executeQuery();
            //verify Email and Password to allow login
            if(resultSet.next()){
                return new User(resultSet.getString("UserID"),
                        resultSet.getString("RoleName"),
                        resultSet.getString("FullName"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //if not correct Email or Password => not allow to login
        return null;
    }

    //get user's id and role
    public String getUserID(String name, String passWord) {
        String query = "";
        //verify user login via Email or UserName
        if (name.contains("@")) {
            query = "where [Email] = ?";
        } else {
            query = "where [UserName] = ?";
        }
        try {
            //get user's ID from database SSMS
            String sql = "select  a.Id\n"
                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
                    + "  on a.Id = b.UserId\n"
                    + "  join [dbo].[Roles] as c\n"
                    + "  on b.RoleId = c.Id \n"
                    + query + " and a.PasswordHash = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, name);
            statement.setObject(2, passWord);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return (String) resultSet.getObject("Id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    //get user's infor by user's ID
    public User getUserInforByID(String userID) {
        try {
            String sql = "select a.Id, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash\n"
                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
                    + "  on a.Id = b.UserId\n"
                    + "  join [dbo].[Roles] as c\n"
                    + "  on b.RoleId = c.Id\n"
                    + "  where a.Id = ? ";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userID);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return new User(userID,
                        resultSet.getString("RoleName"),
                        resultSet.getString("UserName"),
                        resultSet.getString("FullName"),
                        resultSet.getString("Email"),
                        resultSet.getString("PhoneNumber"),
                        resultSet.getString("PasswordHash"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //not found user
        return null;
    }

    //get user's role by this id
    public String getRoleByID(String userID) {
        try {
            String sql = "select a.Id, c.Name as RoleName\n"
                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
                    + "  on a.Id = b.UserId\n"
                    + "  join [dbo].[Roles] as c\n"
                    + "  on b.RoleId = c.Id\n"
                    + "  where a.Id = ? ";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userID);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("RoleName");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //not found user
        return null;
    }

}

//sql query string to get some importan user's information
//    String sql = "select a.Id, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash\n"
//                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
//                    + "  on a.Id = b.UserId\n"
//                    + "  join [dbo].[Roles] as c\n"
//                    + "  on b.RoleId = c.Id"
