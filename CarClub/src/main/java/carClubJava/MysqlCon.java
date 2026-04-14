package carClubJava;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
import java.time.Instant;

public class MysqlCon {
	
	/**
	 * Validates login credentials.
	 *
	 * @param username  Username entered by the user.
	 * @param hashedPass SHA-256 hashed password (call hashPassword() first).
	 * @return The User_ID if credentials match, or -1 if login fails.
	 */
	public static int loginUser(String username, String hashedPass) {
	    String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
	    String user = "root";
	    String pass = "root";

	    String sql = "SELECT User_ID FROM User WHERE Username = ? AND Password = ?";

	    try (Connection con = DriverManager.getConnection(url, user, pass);
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, username);
	        ps.setString(2, hashedPass);

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt("User_ID");
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1;
	}

	/**
	 * Fetches all cars from the Cars table.
	 * Columns: Car_ID, User_ID, Make, Model, Year, Description
	 *
	 * @return List of String arrays, one per car.
	 */
	public static List<String[]> getCars() {
	    List<String[]> cars = new ArrayList<>();
	    String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
	    String user = "root";
	    String pass = "root";

	    try (Connection con = DriverManager.getConnection(url, user, pass);
	         Statement stmt = con.createStatement();
	         ResultSet rs = stmt.executeQuery("SELECT Car_ID, User_ID, Make, Model, Year, Description FROM Cars")) {

	        while (rs.next()) {
	            cars.add(new String[]{
	                rs.getString("Car_ID"),
	                rs.getString("User_ID"),
	                rs.getString("Make"),
	                rs.getString("Model"),
	                rs.getString("Year"),
	                rs.getString("Description")
	            });
	        }

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
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "INSERT INTO User " +
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
    
    /**
     * Inserts a new club into the Clubs table.
     *
     * @param managerID   The User_ID of the user creating the club.
     * @param clubName    The name of the club.
     * @param description Optional club description.
     * @param location    Optional club location.
     * @return true if insert succeeded, false if it failed.
     */
    public static boolean createClub(int managerID, String clubName, String description, String location) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "INSERT INTO Clubs (Manager_ID, Club_Name, Description, Location) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, managerID);
            ps.setString(2, clubName);
            ps.setString(3, description);
            ps.setString(4, location);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Inserts a new car into the Cars table.
     *
     * @param userID      The User_ID of the owner.
     * @param make        Car make (e.g. "Toyota"). Required.
     * @param model       Car model (e.g. "Supra"). Required.
     * @param year        Model year (e.g. 2024). Required.
     * @param description Optional description / modifications.
     * @return true if insert succeeded, false otherwise.
     */
    public static boolean addCar(int userID, String make, String model, int year, String description) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "INSERT INTO Cars (User_ID, Make, Model, Year, Description) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ps.setString(2, make);
            ps.setString(3, model);
            ps.setInt(4, year);
            ps.setString(5, description);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}