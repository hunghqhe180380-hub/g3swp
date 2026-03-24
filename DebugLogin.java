import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;

public class DebugLogin {
    public static void main(String[] args) throws Exception {
        String testUser = "binhnguyen";
        String testPass = "Binh061105@";
        
        // 1. Connect to DB
        String url = "jdbc:sqlserver://localhost:1433;databaseName=ABC;encrypt=true;trustServerCertificate=true;";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        Connection conn = DriverManager.getConnection(url, "sa", "123");
        System.out.println("=== DB Connected OK ===");
        
        // 2. Check current hash in DB
        PreparedStatement ps = conn.prepareStatement(
            "SELECT UserName, PasswordHash, LEN(PasswordHash) as HashLen, EmailConfirmed, IsDeleted " +
            "FROM Users WHERE UserName = ?"
        );
        ps.setString(1, testUser);
        ResultSet rs = ps.executeQuery();
        
        if (!rs.next()) {
            System.out.println("ERROR: User '" + testUser + "' NOT FOUND in DB!");
            conn.close();
            return;
        }
        
        String currentHash = rs.getString("PasswordHash");
        int hashLen = rs.getInt("HashLen");
        int emailConfirmed = rs.getInt("EmailConfirmed");
        int isDeleted = rs.getInt("IsDeleted");
        
        System.out.println("=== Current DB State ===");
        System.out.println("HashLen: " + hashLen);
        System.out.println("Hash prefix: " + currentHash.substring(0, Math.min(10, currentHash.length())));
        System.out.println("Hash suffix: " + currentHash.substring(Math.max(0, currentHash.length() - 6)));
        System.out.println("Full hash: " + currentHash);
        System.out.println("EmailConfirmed: " + emailConfirmed);
        System.out.println("IsDeleted: " + isDeleted);
        System.out.println("Is BCrypt: " + currentHash.startsWith("$2"));
        
        // 3. Test BCrypt verify
        System.out.println("\n=== BCrypt Verify Test ===");
        if (currentHash.startsWith("$2")) {
            boolean match = BCrypt.checkpw(testPass, currentHash);
            System.out.println("checkpw result: " + match);
        } else {
            System.out.println("Hash is NOT BCrypt format - will update");
        }
        
        // 4. Generate new hash and update
        System.out.println("\n=== Generating New Hash & Updating ===");
        String newHash = BCrypt.hashpw(testPass, BCrypt.gensalt(12));
        System.out.println("New hash: " + newHash);
        System.out.println("New hash len: " + newHash.length());
        System.out.println("Verify new: " + BCrypt.checkpw(testPass, newHash));
        
        PreparedStatement ps2 = conn.prepareStatement(
            "UPDATE Users SET PasswordHash = ? WHERE UserName = ?"
        );
        ps2.setString(1, newHash);
        ps2.setString(2, testUser);
        int rows = ps2.executeUpdate();
        System.out.println("Updated rows: " + rows);
        
        // 5. Read back and verify
        System.out.println("\n=== Re-read from DB & Final Verify ===");
        PreparedStatement ps3 = conn.prepareStatement(
            "SELECT PasswordHash, LEN(PasswordHash) as HashLen FROM Users WHERE UserName = ?"
        );
        ps3.setString(1, testUser);
        ResultSet rs3 = ps3.executeQuery();
        rs3.next();
        String storedHash = rs3.getString("PasswordHash");
        int storedLen = rs3.getInt("HashLen");
        System.out.println("Stored hash len: " + storedLen);
        System.out.println("Final verify: " + BCrypt.checkpw(testPass, storedHash));
        System.out.println("Stored == Generated: " + storedHash.equals(newHash));
        
        conn.close();
        System.out.println("\n=== DONE ===");
    }
}
