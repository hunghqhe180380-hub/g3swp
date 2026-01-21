/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

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
    //login
    public boolean isExistAccount(String name, String password) {
        String query = "";
        //verify user login via Email or UserName
        if (name.contains("@")) {
            query = "where [Email] = ?";
        } else {
            query = "where [UserName] = ?";
        }
        try {
            String sql = "select  [Email], [UserName], [PasswordHash] "
                    + "  from [dbo].[AspNetUsers]"
                    + query;
            statement = connection.prepareStatement(sql);
            statement.setObject(1, name);
            resultSet = statement.executeQuery();
            //validation Email/UserName and Password to allow login
            while (resultSet.next()) {
                if (resultSet.getObject("Email").equals(name) || resultSet.getObject("UserName").equals(name)) {
                    if(resultSet.getObject("PasswordHash").equals(password)){
                        //if correct information => allow to login
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //if not correct information => not allow to login
        return false;
    }
}
