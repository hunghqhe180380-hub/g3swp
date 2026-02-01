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
public class MaterialDAO extends DBContext {

    protected PreparedStatement statement;
    protected ResultSet resultSet;

    public List<Material> getMaterialByClassId(String classId) {
        String sql = "SELECT * FROM [Materials] WHERE ClassId=?";
        List<Material> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Material material = new Material();  
                material.setId(resultSet.getInt("Id"));
                material.setTitle(resultSet.getString("Title"));
                material.setProvider(resultSet.getString("Provider"));
                material.setCreatedAt(resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                list.add(material);
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Classroom getClassInfoByClassId(String classId) {
        String sql = "SELECT a.Name,"
                + "(SELECT COUNT(*) FROM [Materials] WHERE ClassId = a.Id) as TotalMaterial\n"
                + "FROM [Classrooms] as a WHERE a.Id = ?";
        Classroom cl = new Classroom();
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, classId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {                
                cl.setName(resultSet.getString("Name"));
                cl.setSum(resultSet.getInt("TotalMaterial"));
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cl;
    }

    public List<Material> getMaterialByName(String name, String classId) {
        String sql = "SELECT Title,Provider,CreatedAt FROM [Materials] "
                + "WHERE (LOWER(Title) LIKE ? OR LOWER(Provider) LIKE ?) and ClassId =?";
        List<Material> list = new ArrayList<>();
        try {
            statement = connection.prepareStatement(sql);
            String searchPattern = "%" + (name == null ? "" : name.toLowerCase()) + "%";
            statement.setObject(1, searchPattern);
            statement.setObject(2, searchPattern);
            statement.setObject(3, classId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                Material material = new Material();                
                material.setId(resultSet.getInt("Id"));
                material.setTitle(resultSet.getString("Title"));
                material.setProvider(resultSet.getString("Provider"));
                material.setCreatedAt(resultSet.getTimestamp("CreatedAt").toLocalDateTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                list.add(material);
            }
            resultSet.close();
            statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteMaterialById(String id, String classId) {
        String sql = "delete from [Materials] where Id =? and classId =?";
        try {
            statement = connection.prepareStatement(sql);
            statement.setObject(1, id);
            statement.setObject(2, classId);
            statement.executeUpdate();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
