/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.PasswordService;

/**
 *
 * @author hung2
 */
public class PasswordDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    //update new password when user reset password
    public void resetPassword(String email, String rawPassword) {
        //encrypt password before update to database
        PasswordService passService = new PasswordService();
        String newPassword = passService.encryptPassword(rawPassword);
        try {
            String sql = "UPDATE [dbo].[Users]\n"
                    + "   SET \n"
                    + "      [PasswordHash] = ?\n"
                    + " WHERE [Email] = ?";
            statement = connection.prepareStatement(sql);
            statement.setObject(1, newPassword);
            statement.setObject(2, email);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    //get password of user from database
    public String getPassword(String userName){
        String condition = "";
        if(userName.contains("@")){
            condition = "Where [Email] = ? ";
        } else {
            condition = "Where [UserName] = ? ";
        }
        try {
            String sql = "Select [PasswordHash]\n"
                    + "From [POETWebDB].[dbo].[Users]\n"
                    + condition;
            statement = connection.prepareStatement(sql);
            statement.setObject(1, userName);
            resultSet = statement.executeQuery();
            if(resultSet.next()){
                return resultSet.getString("PasswordHash");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
