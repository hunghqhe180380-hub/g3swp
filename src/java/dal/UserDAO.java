/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

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
            String sql = "select a.EmailConfirmed, a.Id as UserID, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash, a.EmailConfirmed\n"
                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
                    + "  on a.Id = b.UserId\n"
                    + "  join [dbo].[Roles] as c\n"
                    + "  on b.RoleId = c.Id\n "
                    + "Where " + query + " and a.PasswordHash = ?";

            statement = connection.prepareStatement(sql);
            statement.setObject(1, name);
            statement.setObject(2, password);
            resultSet = statement.executeQuery();

            //verify Email and Password to allow login
            if (resultSet.next()) {
                return new User(resultSet.getString("UserID"),
                        resultSet.getString("RoleName"),
                        resultSet.getString("FullName"),
                        resultSet.getInt("EmailConfirmed")
                );

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

    //register new account
    public User isRegister(User user) {
        if (!isExistEmail(user.getEmail()) && !isExistUserName(user.getUserName())
                && !isExistAccID(user.getUserID())
                && !isExistAccountCode(user.getAccountCode())) {
            InserIntoUserDB(user);
            setRoleNewUser(user.getUserID());
        } else {
            return null;
        }
        return user;
    }

    //set role for new account (default role: Student)
    public void setRoleNewUser(String userID) {

        try {
            String sql
                    = "INSERT INTO [dbo].[UserRoles] (UserId, RoleId) "
                    + "VALUES (?, ?)";

            statement = connection.prepareStatement(sql);
            statement.setObject(1, userID);
            statement.setObject(2, "b7f22aea-e296-482e-987d-60b18cee7dac");

            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //insert new account's information to database
    public void InserIntoUserDB(User user) {
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
                    + "           (?\n" //Id
                    + "           ,?\n" //FullName
                    + "           ,?\n" //AccountCode
                    + "           ,?\n" //AvatarUrl
                    + "           ,?\n" //UserName
                    + "           ,?\n" //NormalizedUserName
                    + "           ,?\n" //Email
                    + "           ,?\n" //NormalizedEmail
                    + "           ,0\n" //EmailConfirmed
                    + "           ,?\n" //PasswordHash
                    + "           ,?\n" //PhoneNumber
                    + "           ,0\n" //PhoneNumberConfirmed
                    + "           ,1\n" //TwoFactorEnabled
                    + "           ,0\n" //LockoutEnabled
                    + "           ,0)"; //AccessFailedCount
            statement = connection.prepareStatement(sql);
            statement.setObject(1, user.getUserID());
            statement.setObject(2, user.getFullName());
            statement.setObject(3, user.getAccountCode());
            statement.setObject(4, "/uploads/avatars/avtProfile.png");
            statement.setObject(5, user.getUserName());
            statement.setObject(6, user.getUserName().toUpperCase());
            statement.setObject(7, user.getEmail());
            statement.setObject(8, user.getEmail().toUpperCase());
            statement.setObject(9, user.getPassword());
            statement.setObject(10, user.getPhoneNumber());
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //generate user ID
    public String generateID() {
        UUID uuid = UUID.randomUUID();
        return uuid.toString();
    }

    //generateAccCode
    public String generateAccCode() {
        String letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; // A–Z
        String result = "";

        //create 4 letter uppercases
        for (int i = 0; i < 4; i++) {
            int index = (int) (Math.random() * letters.length());
            result += letters.charAt(index);
        }

        //create 4 digits
        for (int i = 0; i < 4; i++) {
            int digit = (int) (Math.random() * 10);
            result += digit;
        }

        return result;
    }

    boolean isExistAccID(String userID) {
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

    private boolean isExistUserName(String userName) {
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

    public String getRoleIdByRoleName(String roleName) {
        String sql = "select Id from [Roles] where Name =?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, roleName);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("Id");
            }
            resultSet.close();
            statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * change role of user by user's id
     * @param userId id of user you want to change
     * @param roleId new role you want to change for the user
     */
    public void updateUserRole(String userId, String roleId) {
        String sql = "UPDATE [dbo].[UserRoles]\n"
                + "   SET [RoleId] = ?\n"
                + " WHERE UserId = ?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, roleId);
            statement.setObject(2, userId);
            statement.executeUpdate();
            statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<User> getAllUsers() {
        String sql = "SELECT a.*,c.Name as RoleName from [Users] as a\n"
                + "JOIN [UserRoles] as b on a.Id = b.UserId\n"
                + "JOIN [Roles] as c on b.RoleId = c.Id";
        List<User> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = new User();
                user.setUserID(resultSet.getString("Id"));
                user.setFullName(resultSet.getString("FullName"));
                user.setAccountCode(resultSet.getString("AccountCode"));
                user.setUrlImgProfile(resultSet.getString("AvatarUrl"));
                user.setUserName(resultSet.getString("UserName"));
                user.setEmail(resultSet.getString("Email"));
                user.setEmailConfirm(resultSet.getInt("EmailConfirmed"));
                user.setPassword(resultSet.getString("PasswordHash"));
//                user.setSecurityStamp(resultSet.getString("SecurityStamp"));
//                user.setConcurrencyStamp(resultSet.getString("Id"));
                user.setPhoneNumber(resultSet.getString("PhoneNumber"));
                user.setRole(resultSet.getString("RoleName"));
                list.add(user);
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteUser(String userId) {
        String sql = "delete from Users where Id = ?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userId);
            statement.executeUpdate();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String getUserIdByEmail(String email) {
        String userID = "";
        try {
            String sql = "SELECT  [Id]\n"
                    + "  FROM [POETWebDB].[dbo].[Users]\n"
                    + "  Where Email = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, email);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                userID = resultSet.getString("Id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userID;
    }

    /**
     * get user information even param just a character
     *
     * @param name an email/fullname/username
     * @return a list of user
     */
    public List<User> getUserInforByName(String name) {
        String sql = "SELECT a.*, c.Name as RoleName FROM [Users] as a\n"
                + "JOIN [UserRoles] as b on a.Id = b.UserId\n"
                + "JOIN [Roles] as c on b.RoleId = c.Id\n"
                + "WHERE LOWER(a.FullName) LIKE ? OR LOWER(a.UserName) LIKE ? OR LOWER(a.Email) LIKE ?";
        List<User> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            String searchPattern = "%" + (name == null ? "" : name.toLowerCase()) + "%";
            statement.setObject(1, searchPattern);
            statement.setObject(2, searchPattern);
            statement.setObject(3, searchPattern);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = new User();
                user.setUserID(resultSet.getString("Id"));
                user.setFullName(resultSet.getString("FullName"));
                user.setAccountCode(resultSet.getString("AccountCode"));
                user.setUrlImgProfile(resultSet.getString("AvatarUrl"));
                user.setUserName(resultSet.getString("UserName"));
                user.setEmail(resultSet.getString("Email"));
                user.setEmailConfirm(resultSet.getInt("EmailConfirmed"));
                user.setPassword(resultSet.getString("PasswordHash"));
                user.setPhoneNumber(resultSet.getString("PhoneNumber"));
                user.setRole(resultSet.getString("RoleName"));
                list.add(user);
            }
            resultSet.close();
            statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public String getUserNameByEmail(String email) {
        String userName = "";
        try {
            String sql = "SELECT [UserName]\n"
                    + "  FROM [POETWebDB].[dbo].[Users]\n"
                    + "  Where Email = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, email);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                userName = resultSet.getString("UserName");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userName;
    }


    /**
     * get user information even param just a character
     *
     * @param name an email/fullname/username
     * @return a list of user
     */
    public List<User> getUserInforByName(String name) {
        String sql = "SELECT a.*, c.Name as RoleName FROM [Users] as a\n"
                + "JOIN [UserRoles] as b on a.Id = b.UserId\n"
                + "JOIN [Roles] as c on b.RoleId = c.Id\n"
                + "WHERE LOWER(a.FullName) LIKE ? OR LOWER(a.UserName) LIKE ? OR LOWER(a.Email) LIKE ?";
        List<User> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            String searchPattern = "%" + (name == null ? "" : name.toLowerCase()) + "%";
            statement.setObject(1, searchPattern);
            statement.setObject(2, searchPattern);
            statement.setObject(3, searchPattern);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                User user = new User();
                user.setUserID(resultSet.getString("Id"));
                user.setFullName(resultSet.getString("FullName"));
                user.setAccountCode(resultSet.getString("AccountCode"));
                user.setUrlImgProfile(resultSet.getString("AvatarUrl"));
                user.setUserName(resultSet.getString("UserName"));
                user.setEmail(resultSet.getString("Email"));
                user.setEmailConfirm(resultSet.getInt("EmailConfirmed"));
                user.setPassword(resultSet.getString("PasswordHash"));
                user.setPhoneNumber(resultSet.getString("PhoneNumber"));
                user.setRole(resultSet.getString("RoleName"));
                list.add(user);
            }
            resultSet.close();
            statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}

//sql query string to get some importan user's information
//    String sql = "select a.Id, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash\n"
//                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
//                    + "  on a.Id = b.UserId\n"
//                    + "  join [dbo].[Roles] as c\n"
//                    + "  on b.RoleId = c.Id"
