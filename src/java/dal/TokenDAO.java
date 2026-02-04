/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.sql.Timestamp;
import java.util.UUID;
import model.Token;

/**
 *
 * @author hung2
 */
public class TokenDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public String getFormatDate(LocalDateTime myDateObj) {
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDate = myDateObj.format(myFormatObj);
        return formattedDate;
    }

    public boolean insertToTokenDB(Token tokenForget, String action) {
        try {
            String sql = "INSERT INTO [dbo].[Token]\n"
                    + "           ([Id]\n"
                    + "           ,[Token]\n"
                    + "           ,[ExpiryTime]"
                    + "           ,[IsUsed]\n"
                    + "           ,[UserId]\n"
                    + "           ,[Email]"
                    + "           ,[Action])\n"
                    + "     VALUES\n"
                    + "           (?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?)";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, UUID.randomUUID());
            statement.setObject(2, tokenForget.getToken());
            statement.setObject(3, Timestamp.valueOf(getFormatDate(tokenForget.getExpiryTime())));
            statement.setObject(4, tokenForget.isIsUsed());
            statement.setObject(5, tokenForget.getUserID());
            statement.setObject(6, tokenForget.getEmail());
            statement.setObject(7, action);
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //valid token exist and not expiry time and IsUSed = 0
    public boolean isExistToken(String token, String action) {
        try {
            String sql = "SELECT [Token]\n"
                    + "  FROM [dbo].[Token]\n"
                    + "WHERE [Token] = ? and [IsUsed] = 0\n"
                    + "And ExpiryTime > GetDate()\n"
                    + "And [Action] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, token);
            statement.setObject(2, action);
            resultSet = statement.executeQuery();
            return resultSet.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //token have not used and expirytime
    public String getEmailByToken(String token, String action) {
        try {
            String sql = "SELECT [Email]\n"
                    + "  FROM [dbo].[Token]\n"
                    + "  where Token = ?\n"
                    //token is not expiry time to use
                    + "  And [ExpiryTime] > GETDATE()\n"
                    + "  And [IsUsed] = 0\n"
                    + "And [Action] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, token);
            statement.setObject(2, action);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("Email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //get email by token expiried time
    public String getEmailByTokenExpiryTime(String token, String action) {
        try {
            String sql = "SELECT [Email]\n"
                    + "  FROM [dbo].[Token]\n"
                    + "  where [ExpiryTime] < GETDATE()\n"
                    + "And [Token] = ?\n"
                    + "  And [Action] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, token);
            statement.setObject(2, action);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("Email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //set token is used
    public boolean setTokenIsUsed(String token, String action) {
        try {
            String sql = "UPDATE [dbo].[Token]\n"
                    + "   SET [IsUsed] = 1\n"
                    + " WHERE [Token] = ?\n"
                    + "And [Action] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, token);
            statement.setObject(2, action);
            statement.executeUpdate();
            return resultSet.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
