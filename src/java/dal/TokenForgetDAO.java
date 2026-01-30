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
import model.TokenForgetPassword;

/**
 *
 * @author hung2
 */
public class TokenForgetDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public String getFormatDate(LocalDateTime myDateObj) {
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDate = myDateObj.format(myFormatObj);
        return formattedDate;
    }

    public boolean insertTokenForget(TokenForgetPassword tokenForget) {
        try {
            String sql = "INSERT INTO [dbo].[TokenForgetPassword]\n"
                    + "           ([Id]\n"
                    + "           ,[Token]\n"
                    + "           ,[ExpiryTime]"
                    + "           ,[IsUsed]\n"
                    + "           ,[UserId])\n"
                    + "     VALUES\n"
                    + "           (?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?\n"
                    + "           ,?\n)";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, UUID.randomUUID());
            statement.setObject(2, tokenForget.getToken());
            statement.setObject(3, Timestamp.valueOf(getFormatDate(tokenForget.getExpiryTime())));
            statement.setObject(4, tokenForget.isIsUsed());
            statement.setObject(5, tokenForget.getUserID());
            return statement.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //valid token exist and not expiry time and IsUSed = 0
    public boolean isExistToken(String token) {
        try {
            String sql = "SELECT [Token]\n"
                    + "  FROM [POETWebDB].[dbo].[TokenForgetPassword]\n"
                    + "WHERE [Token] = ? and [IsUsed] = 0\n"
                    + "And ExpiryTime > GetDate()";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, token);
            resultSet = statement.executeQuery();
            return resultSet.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

     
}
