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
import util.PasswordService;

/**
 *
 * @author hung2
 */
public class UserDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    //login (this function not check email confirm)
    public User isLogin(String name, String rawPassword) {
        //verify user login via email or username
        String query = "";
        if (name.contains("@")) {
            query = "a.Email = ? ";
        } else {
            query = "a.UserName = ? ";
        }

        //get password hash of this username/email
        String passwordHash = getPasswordHash(name);
        System.out.println("PsHHH: " + passwordHash);
        //if Email/User Name is not exist
        if (passwordHash == null) {
            return null;
        };
        //compare hashedpassword with input password
        PasswordService passwordService = new PasswordService();
        System.out.println("Rsss: " + passwordService.checkPassword(rawPassword, passwordHash));
        //if match => get information of this user
        if (passwordService.checkPassword(rawPassword, passwordHash)) {
            try {
                //get user's information from database SSMS
                String sql = "select a.EmailConfirmed, a.Id as UserID, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash, a.EmailConfirmed\n"
                        + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
                        + "  on a.Id = b.UserId\n"
                        + "  join [dbo].[Roles] as c\n"
                        + "  on b.RoleId = c.Id\n "
                        + "Where " + query + " and isDeleted = 0";

                statement = connection.prepareStatement(sql);
                statement.setObject(1, name);
                resultSet = statement.executeQuery();
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
        };
        //invalid username/email or password
        return null;
    }

    //get password hash by email
    public String getPasswordHash(String userName) {
        String query = "";
        if (userName.contains("@")) {
            query = "Where [Email] = ? ";
        } else {
            query = "Where [UserName] = ? ";
        }
        try {
            String sql = "Select [PasswordHash]\n"
                    + "from [users]\n"
                    + query;
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userName);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("PasswordHash");
            };
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
        //userID, userName, fullName, email, phoneNumber, accountCode
        try {
            String sql = "select a.AvatarUrl, a.Id as UserID, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash, a.AccountCode\n"
                    + "                  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
                    + "                  on a.Id = b.UserId\n"
                    + "              join [dbo].[Roles] as c\n"
                    + "               on b.RoleId = c.Id\n"
                    + "Where a.id = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userID);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return new User(resultSet.getString("AvatarUrl"),
                        userID,
                        resultSet.getNString("RoleName"),
                        resultSet.getString("UserName"),
                        resultSet.getString("FullName"),
                        resultSet.getString("Email"),
                        resultSet.getString("PhoneNumber"),
                        resultSet.getString("AccountCode"));
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
            //encrypt password then insert to database
            PasswordService passwordService = new PasswordService();
            String password = passwordService.encryptPassword(user.getPassword());
            user.setPassword(password);
            System.out.println("DBInsertUser: " + InserIntoUserDB(user));
            System.out.println("DB SetRoleNewUSer: " + setRoleNewUser(user.getUserID()));
        } else {
            return null;
        }
        return user;
    }

    //set role for new account (default role: Student)
    public boolean setRoleNewUser(String userID) {

        try {
            String sql
                    = "INSERT INTO [dbo].[UserRoles] (UserId, RoleId) "
                    + "VALUES (?, ?)";

            statement = connection.prepareStatement(sql);
            statement.setObject(1, userID);
            statement.setObject(2, "b7f22aea-e296-482e-987d-60b18cee7dac");
            statement.executeUpdate();
            return resultSet.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //insert new account's information to database
    public boolean InserIntoUserDB(User user) {
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
            return resultSet.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
                    + "  FROM [dbo].[Users]"
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
                    + "  FROM [dbo].[Users]"
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
                    + "  FROM [dbo].[Users]"
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
                    + "  FROM [dbo].[Users]"
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
     *
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

    public List<User> getAllUsers(String search, String[] roles) {
        String sql = "SELECT a.*,c.Name as RoleName from [Users] as a\n"
                + "JOIN [UserRoles] as b on a.Id = b.UserId\n"
                + "JOIN [Roles] as c on b.RoleId = c.Id\n"
                + "Where 1=1 ";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (LOWER(a.FullName) LIKE ? OR LOWER(a.UserName) LIKE ? OR LOWER(a.Email) LIKE ?)";
        }
        boolean hasRoles = (roles != null && roles.length > 0);
        if (hasRoles) {
            sql += (" AND c.Name IN (");
            for (int i = 0; i < roles.length; i++) {
                sql += ("?");
                if (i < roles.length - 1) {
                    sql += (",");
                }
            }
            sql += (") ");
        }
        List<User> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.toLowerCase() + "%";
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
            }
            if (hasRoles) {
                for (String r : roles) {
                    statement.setObject(paramIndex++, r);
                }
            }
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
                user.setIsDeleted(resultSet.getInt("isDeleted"));
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

    public void changeUserStatus(String userId, String status) {
        if (status.equals("0")) {
            status = "1";
        } else {
            status = "0";
        }
        String sql = "UPDATE [Users] \n"
                + "SET [isDeleted] = ?\n"
                + "WHERE Id = ?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(2, userId);
            statement.setObject(1, status);
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
                    + "  FROM [dbo].[Users]\n"
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

    public String getUserNameByEmail(String email) {
        String userName = "";
        try {
            String sql = "SELECT [UserName]\n"
                    + "  FROM [dbo].[Users]\n"
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

    //get userID by token request
    public String getUserIdByTokenRequest(String token, String action) {
        try {
            String sql = "SELECT [UserId]\n"
                    + "  FROM [dbo].[Token]\n"
                    + "  Where [IsUsed] = 0\n"
                    + "  And [Action] = ?\n"
                    + "  And [Token] = ?\n"
                    + "  And [ExpiryTime] > GETDATE();";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, action);
            statement.setObject(2, token);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("UserId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //get Email by UserID
    public String getEmailByUserId(String userID) {
        try {
            String sql = "SELECT [Email]\n"
                    + "  FROM [dbo].[Users]\n"
                    + "  where [Id] = ? ";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userID);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("Email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //get email by user name
    public String getEmailByUserName(String userName) {
        try {
            String sql = "";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userName);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("Email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isConfirmEmail(String email) {
        try {
            String sql = "SELECT[Email],[EmailConfirmed]\n"
                    + "                  FROM [dbo].[Users]\n"
                    + "                    where [Email] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, email);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getBoolean("EmailConfirmed");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //set confirmed email
    public boolean setConfimedEmail(String email) {
        try {
            String sql = "UPDATE [dbo].[Users]\n"
                    + "SET [EmailConfirmed] = 1\n"
                    + "Where [Email] = ?\n";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, email);
            statement.executeUpdate();
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int updateProfile(String userId, String fullName, String phoneNumber, String avatarUrl) {
        boolean updateAvatar = (avatarUrl != null && !avatarUrl.isBlank());

        String sql = updateAvatar
                ? "UPDATE [dbo].[Users] SET [FullName]=?, [PhoneNumber]=?, [AvatarUrl]=? WHERE [Id]=?"
                : "UPDATE [dbo].[Users] SET [FullName]=?, [PhoneNumber]=? WHERE [Id]=?";

        fullName = (fullName == null) ? "" : fullName.trim();
        phoneNumber = (phoneNumber == null) ? "" : phoneNumber.trim();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phoneNumber);

            if (updateAvatar) {
                ps.setString(3, avatarUrl);
                ps.setString(4, userId);
            } else {
                ps.setString(3, userId);
            }

            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("updateProfile failed: " + e.getMessage(), e);
        }
    }

    //get url image path from fb
    public String getAvatarUrlByUserID(String userID) {
        try {
            String sql = "SELECT [AvatarUrl]\n"
                    + "  FROM [POETWebDB].[dbo].[Users]\n"
                    + "\n"
                    + "  where Id = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userID);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("AvatarUrl");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
//sql query string to get some importan user's information
//    String sql = "select a.Id, c.Name as RoleName, a.UserName, a.FullName, a.Email, a.PhoneNumber, a.PasswordHash\n"
//                    + "  from [dbo].[Users] as a join  [dbo].[UserRoles] as b\n"
//                    + "  on a.Id = b.UserId\n"
//                    + "  join [dbo].[Roles] as c\n"
//                    + "  on b.RoleId = c.Id"
