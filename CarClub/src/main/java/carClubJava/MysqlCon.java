package carClubJava;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
import java.time.Instant;

public class MysqlCon {
            /**
             * Permanently deletes a user account and their cars, in a transaction.
             *
             * @param userID The User_ID to delete.
             * @return true if the user row was deleted, false otherwise.
             *
             * TODO: When CarPhotos, Membership, Registration, etc. are implemented, delete those first.
             */
            public static boolean deleteAccount(int userID) {
                String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
                String user = "root";
                String pass = "root";

                try (Connection con = DriverManager.getConnection(url, user, pass)) {
                    con.setAutoCommit(false);
                    try {
                        // TODO: Delete from CarPhotos where User_ID = ?
                        // TODO: Delete from Membership where User_ID = ?
                        // TODO: Delete from Registration where User_ID = ?

                        // Delete user's cars
                        try (PreparedStatement psCars = con.prepareStatement("DELETE FROM Cars WHERE User_ID = ?")) {
                            psCars.setInt(1, userID);
                            psCars.executeUpdate();
                        }

                        // Delete user
                        int userRows;
                        try (PreparedStatement psUser = con.prepareStatement("DELETE FROM User WHERE User_ID = ?")) {
                            psUser.setInt(1, userID);
                            userRows = psUser.executeUpdate();
                        }

                        con.commit();
                        return userRows == 1;
                    } catch (Exception e) {
                        con.rollback();
                        e.printStackTrace();
                        return false;
                    } finally {
                        con.setAutoCommit(true);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    return false;
                }
            }
        /**
         * Deletes a car from the Cars table if the user owns it.
         *
         * @param carID   The Car_ID to delete.
         * @param userID  The User_ID of the owner (must match).
         * @return true if one row was deleted, false otherwise.
         *
         * TODO: When CarPhotos are implemented, delete related photos before deleting the car.
         */
        public static boolean deleteCar(int carID, int userID) {
            String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
            String user = "root";
            String pass = "root";

            String sql = "DELETE FROM Cars WHERE Car_ID = ? AND User_ID = ?";
            try (Connection con = DriverManager.getConnection(url, user, pass);
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, carID);
                ps.setInt(2, userID);
                int rows = ps.executeUpdate();
                return rows == 1;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
	
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

    /**
     * Updates a user's public profile fields.
     *
     * @param userID      The User_ID to update.
     * @param displayName New display name (can be empty string).
     * @param bio         New bio (can be empty string).
     * @param location    New city/state string (can be empty string).
     * @return true if the row was updated, false otherwise.
     */
    public static boolean updateProfile(int userID, String displayName, String bio, String location) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "UPDATE User SET Display_Name = ?, Bio = ?, Location = ? WHERE User_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, displayName);
            ps.setString(2, bio);
            ps.setString(3, location);
            ps.setInt(4, userID);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Fetches a single user's public profile by User_ID.
     *
     * @param userID The User_ID to look up.
     * @return String array [Username, Display_Name, Bio, Location, Date_Created],
     *         or null if not found.
     */
    public static String[] getUserProfile(int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT Username, Display_Name, Bio, Location, Date_Created " +
                     "FROM User WHERE User_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new String[]{
                    rs.getString("Username"),
                    rs.getString("Display_Name"),
                    rs.getString("Bio"),
                    rs.getString("Location"),
                    rs.getString("Date_Created")
                };
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Fetches all clubs from the Clubs table.
     * Columns: Club_ID, Manager_ID, Club_Name, Description, Location
     *
     * @return List of String arrays, one per club.
     */
    public static List<String[]> getClubs() {
        List<String[]> clubs = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT c.Club_ID, c.Manager_ID, c.Club_Name, c.Description, " +
                     "c.Location, u.Username AS Manager_Username " +
                     "FROM Clubs c JOIN User u ON c.Manager_ID = u.User_ID";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                clubs.add(new String[]{
                    rs.getString("Club_ID"),
                    rs.getString("Manager_ID"),
                    rs.getString("Club_Name"),
                    rs.getString("Description"),
                    rs.getString("Location"),
                    rs.getString("Manager_Username")
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return clubs;
    }
}