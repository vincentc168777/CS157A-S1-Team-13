package carClubJava;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
import java.time.Instant;

public class MysqlCon {

    public static List<String[]> getCars() {
        List<String[]> cars = new ArrayList<>();
        String user = "root";
        String password = "root";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/cheng?autoReconnect=true&useSSL=false",
                user, password
            );

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Cars");

            while (rs.next()) {
                cars.add(new String[]{ rs.getString(1), rs.getString(2) });
            }

            rs.close();
            stmt.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return cars;
    }
    /**
    * Hashes a plain-text password using SHA-256.
    * For production, consider using BCrypt (add bcrypt library to your project).
    *
    * @param plainPassword  The raw password string entered by the user.
    * @return  Hex-encoded SHA-256 hash string.
 */
    public static String hashPassword(String plainPassword) {
    try {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(plainPassword.getBytes(StandardCharsets.UTF_8));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) {
            hex.append(String.format("%02x", b));
        }
        return hex.toString();
    } catch (Exception e) {
        e.printStackTrace();
        return null;
    }
    }


    /**
    * Inserts a new user into the Users table.
    *
    * @param username     Unique username chosen by the user.
    * @param email        Unique email address.
    * @param hashedPass   Pre-hashed password (call hashPassword() first).
    * @param displayName  Optional display name.
    * @param bio          Optional short bio.
    * @param location     Optional city/state string.
    * @return  true if insert succeeded, false if it failed (e.g. duplicate username/email).
    */
    public static boolean registerUser(String username, String email, String hashedPass,
                                   String displayName, String bio, String location) {
        String url  = "jdbc:mysql://localhost:3306/cheng?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "INSERT INTO Users " +
                 "(Username, Email, Password, Display_Name, Bio, Location, Date_Created) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DriverManager.getConnection(url, user, pass);
            PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, hashedPass);
            ps.setString(4, displayName);
            ps.setString(5, bio);
            ps.setString(6, location);
            ps.setTimestamp(7, Timestamp.from(Instant.now()));

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
        // Duplicate username or email will land here
            e.printStackTrace();
            return false;
        }
    }
}