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

        //verify user login via email or username
        String query = "";
        if (name.contains("@")) {
            query = "a.Email = ? ";
        } else {
            query = "a.UserName = ? ";
        }

        try {
            //get user's information from database SSMS
            String sql = "select a.Id as UserID, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash, a.EmailConfirmed\n"
                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
                    + "  on a.Id = b.UserId\n"
                    + "  join [dbo].[Roles] as c\n"
                    + "  on b.RoleId = c.Id\n "
                    + "Where " + query + " and a.PasswordHash = ? and a.EmailConfirmed = 1";

            statement = connection.prepareStatement(sql);
            statement.setObject(1, name);
            statement.setObject(2, password);
            resultSet = statement.executeQuery();

            //verify Email and Password to allow login
            if (resultSet.next()) {
                return new User(resultSet.getString("UserID"),
                        resultSet.getString("RoleName"),
                        resultSet.getString("FullName"));

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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

    public User isRegister(User user) {
        // exist account ? 'denide register' : 'allow register'
        if (isExistEmail(user.getEmail()) && !isExistUserName(user.getUserName())
                && isExistAccID(user.getUserID())
                && isExistAccountCode(user.getAccountCode())) {
            return null;
        } else {
            try {
                String sql = "INSERT INTO [dbo].[Users]\n"
                        + "           ([Id]\n"
                        + "           ,[FullName]\n"
                        + "           ,[AccountCode]\n"
                        + "          ,[AvatarUrl]\n"
                        + "           ,[UserName]\n"
                        + "           ,[NormalizedUserName]\n"
                        + "           ,[Email]\n"
                        + "           ,[NormalizedEmail]\n"
                        + "           ,[EmailConfirmed]\n"
                        + "           ,[PasswordHash]\n"
                        + "           ,[PhoneNumber]\n"
                        + "           ,[PhoneNumberConfirmed]\n"
                        + "           ,[TwoFactorEnabled]\n"
                        + "           ,[LockoutEnabled]\n"
                        + "           ,[AccessFailedCount])\n"
                        + "     VALUES\n"
                        + "           ('hqhe180380'\n"
                        + "           ,'Hoang Quoc Hung'\n"
                        + "           ,'HQHEHQHE'\n"
                        + "           ,'/uploads/avatars/avtProfile.png'\n"
                        + "           ,'hunghqhe180380'\n"
                        + "           ,'HUNGHQHE180380'\n"
                        + "           ,'hunghqhe180380@gmail.com'\n"
                        + "           ,'HUNGHQHE180380@GMAIL.COM'\n"
                        + "           ,1\n"
                        + "           ,11111111\n"
                        + "           ,'0123456789'\n"
                        + "           ,0\n"
                        + "           ,1\n"
                        + "           ,0\n"
                        + "           ,0)";

            } catch (Exception e) {
            }
        }
        return user;
    }

    public boolean isExistAccID(String userID) {
        try {
            String sql = "SELECT [Id]\n"
                    + "  FROM [POETWebDB].[dbo].[Users]"
                    + "  Where [Id] = ? ";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userID);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isExistAccountCode(String accountCode) {
        try {
            String sql = "SELECT [AccountCode]\n"
                    + "  FROM [POETWebDB].[dbo].[Users]"
                    + "  Where [AccountCode] = ? ";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, accountCode);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isExistEmail(String email) {
        try {
            String sql = "SELECT [Email]\n"
                    + "  FROM [POETWebDB].[dbo].[Users]"
                    + "  Where [Email] = ? ";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, email);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isExistUserName(String userName) {
        try {
            String sql = "SELECT [UserName]\n"
                    + "  FROM [POETWebDB].[dbo].[Users]"
                    + "  Where [UserName] = ? ";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userName);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
//sql query string to get some importan user's information
//    String sql = "select a.Id, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash\n"
//                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
//                    + "  on a.Id = b.UserId\n"
//                    + "  join [dbo].[Roles] as c\n"
//                    + "  on b.RoleId = c.Id"
