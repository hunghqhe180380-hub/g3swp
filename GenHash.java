import org.mindrot.jbcrypt.BCrypt;
import java.io.*;

public class GenHash {
    public static void main(String[] args) throws Exception {
        String raw = "Binh061105@";
        String hash = BCrypt.hashpw(raw, BCrypt.gensalt(12));
        
        System.out.println("Hash length: " + hash.length());
        System.out.println("Verify OK: " + BCrypt.checkpw(raw, hash));
        
        // Write SQL to file
        String sql = "UPDATE [dbo].[Users] SET [PasswordHash] = '" + hash + "' WHERE [UserName] = 'binhnguyen'";
        
        FileWriter fw = new FileWriter("update_password.sql");
        fw.write(sql);
        fw.close();
        
        System.out.println("SQL written to update_password.sql");
        System.out.println("Hash: " + hash);
    }
}
