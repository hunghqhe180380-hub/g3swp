package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // Gán thẳng giá trị từ file properties cũ của bạn vào đây
            String user = "admin";
            String pass = "1234567890";
            String url = "jdbc:sqlserver://localhost:1433;databaseName=POETDB;encrypt=true;trustServerCertificate=true;characterEncoding=UTF-8;";
            
            // Nạp Driver SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Thiết lập kết nối
            connection = DriverManager.getConnection(url, user, pass);
            
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Không tìm thấy Driver SQL Server!", ex);
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "Lỗi kết nối Cơ sở dữ liệu!", ex);
        }
    }

    public Connection getConnection() {
        return connection;
    }

    public static void main(String[] args) {
        DBContext dbContext = new DBContext();
        if (dbContext.connection != null) {
            System.out.println("Kết nối thành công: " + dbContext.connection);
        } else {
            System.out.println("Kết nối thất bại!");
        }
    }
}