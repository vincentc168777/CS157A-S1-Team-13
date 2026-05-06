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
                        // 1. Remove other users' registrations for events in clubs this user manages
                        try (PreparedStatement ps = con.prepareStatement(
                                "DELETE FROM Event_Registration WHERE Event_ID IN " +
                                "(SELECT e.Event_ID FROM Events e JOIN Clubs c ON e.Club_ID = c.Club_ID WHERE c.Manager_ID = ?)")) {
                            ps.setInt(1, userID); ps.executeUpdate();
                        }

                        // 2. Delete events belonging to clubs this user manages
                        try (PreparedStatement ps = con.prepareStatement(
                                "DELETE FROM Events WHERE Club_ID IN (SELECT Club_ID FROM Clubs WHERE Manager_ID = ?)")) {
                            ps.setInt(1, userID); ps.executeUpdate();
                        }

                        // 3. Remove other users' memberships from clubs this user manages
                        try (PreparedStatement ps = con.prepareStatement(
                                "DELETE FROM club_membership WHERE Club_ID IN (SELECT Club_ID FROM Clubs WHERE Manager_ID = ?)")) {
                            ps.setInt(1, userID); ps.executeUpdate();
                        }

                        // 4. Delete clubs this user manages
                        try (PreparedStatement ps = con.prepareStatement("DELETE FROM Clubs WHERE Manager_ID = ?")) {
                            ps.setInt(1, userID); ps.executeUpdate();
                        }

                        // 5. Delete this user's own event registrations
                        try (PreparedStatement ps = con.prepareStatement("DELETE FROM Event_Registration WHERE User_ID = ?")) {
                            ps.setInt(1, userID); ps.executeUpdate();
                        }

                        // 6. Delete this user's club memberships
                        try (PreparedStatement ps = con.prepareStatement("DELETE FROM club_membership WHERE User_ID = ?")) {
                            ps.setInt(1, userID); ps.executeUpdate();
                        }

                        // 7. Delete this user's cars
                        try (PreparedStatement ps = con.prepareStatement("DELETE FROM Cars WHERE User_ID = ?")) {
                            ps.setInt(1, userID); ps.executeUpdate();
                        }

                        // 8. Delete the user row
                        int userRows;
                        try (PreparedStatement ps = con.prepareStatement("DELETE FROM User WHERE User_ID = ?")) {
                            ps.setInt(1, userID);
                            userRows = ps.executeUpdate();
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

    public static List<String[]> getUserClubs(int userID) {
        List<String[]> clubs = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";
        String sql  = "SELECT c.Club_ID, c.Manager_ID, c.Club_Name, c.Description, " +
                      "c.Location, u.Username AS Manager_Username " +
                      "FROM Clubs c JOIN User u ON c.Manager_ID = u.User_ID " +
                      "WHERE c.Manager_ID = ? " +
                      "OR c.Club_ID IN (SELECT Club_ID FROM club_membership WHERE User_ID = ?) " +
                      "ORDER BY c.Club_Name";
        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, userID);
            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return clubs;
    }

    public static boolean joinClub(int clubID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";
        String sql  = "INSERT IGNORE INTO club_membership (Club_ID, User_ID) VALUES (?, ?)";
        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, clubID);
            ps.setInt(2, userID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean leaveClub(int clubID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";
        String sql  = "DELETE FROM club_membership WHERE Club_ID = ? AND User_ID = ?";
        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, clubID);
            ps.setInt(2, userID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean isUserInClub(int clubID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";
        String sql  = "SELECT 1 FROM club_membership WHERE Club_ID = ? AND User_ID = ?";
        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, clubID);
            ps.setInt(2, userID);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static int getClubMemberCount(int clubID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";
        String sql  = "SELECT COUNT(*) FROM club_membership WHERE Club_ID = ?";
        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, clubID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Searches clubs in the Clubs table by keyword.
     * Searches in Club_Name, Description, and Location.
     * Columns: Club_ID, Manager_ID, Club_Name, Description, Location, Manager_Username
     *
     * @param keyword The search keyword.
     * @return List of String arrays, one per matching club.
     */
    public static List<String[]> searchClubs(String keyword) {
        List<String[]> clubs = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT c.Club_ID, c.Manager_ID, c.Club_Name, c.Description, " +
                     "c.Location, u.Username AS Manager_Username " +
                     "FROM Clubs c JOIN User u ON c.Manager_ID = u.User_ID " +
                     "WHERE c.Club_Name LIKE ? OR c.Description LIKE ? OR c.Location LIKE ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
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
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return clubs;
    }
    
    /**
     * Creates a new event tied to a club.
     * Only the club's manager should call this (enforce in JSP).
     *
     * @param clubID      The Club_ID hosting the event.
     * @param eventName   Name of the event. Required.
     * @param eventDate   Date string in "YYYY-MM-DD" format. Required.
     * @param location    Physical location. Required.
     * @param eventType   "Car Show", "Race", or "Meetup". Required.
     * @param description Optional extra details.
     * @return true if insert succeeded.
     */
    public static boolean createEvent(int clubID, String eventName, String eventDate,
                                      String location, String eventType, String description) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "INSERT INTO Events (Club_ID, Event_Name, Event_Date, Location, Event_Type, Description) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clubID);
            ps.setString(2, eventName);
            ps.setDate(3, java.sql.Date.valueOf(eventDate));
            ps.setString(4, location);
            ps.setString(5, eventType);
            ps.setString(6, description.isEmpty() ? null : description);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing event.
     * Caller must verify the logged-in user manages the event's club.
     *
     * @return true if one row was updated.
     */
    public static boolean updateEvent(int eventID, String eventName, String eventDate,
                                      String location, String eventType, String description) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "UPDATE Events SET Event_Name=?, Event_Date=?, Location=?, Event_Type=?, Description=? " +
                     "WHERE Event_ID=?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, eventName);
            ps.setDate(2, java.sql.Date.valueOf(eventDate));
            ps.setString(3, location);
            ps.setString(4, eventType);
            ps.setString(5, description.isEmpty() ? null : description);
            ps.setInt(6, eventID);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes an event and its registrations in a transaction.
     * Caller must verify ownership before calling.
     *
     * @return true if the event row was deleted.
     */
    public static boolean deleteEvent(int eventID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            con.setAutoCommit(false);
            try {
                // Delete registrations first (FK constraint)
                try (PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM Event_Registration WHERE Event_ID = ?")) {
                    ps.setInt(1, eventID);
                    ps.executeUpdate();
                }
                // Delete event
                int rows;
                try (PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM Events WHERE Event_ID = ?")) {
                    ps.setInt(1, eventID);
                    rows = ps.executeUpdate();
                }
                con.commit();
                return rows == 1;
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
     * Returns all events, joined with their club name.
     * Columns: [0]=Event_ID, [1]=Club_ID, [2]=Club_Name, [3]=Event_Name,
     *           [4]=Event_Date, [5]=Event_Type, [6]=Location, [7]=Description,
     *           [8]=Manager_ID
     */
    public static List<String[]> getEvents() {
        List<String[]> events = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT e.Event_ID, e.Club_ID, c.Club_Name, e.Event_Name, " +
                     "e.Event_Date, e.Event_Type, e.Location, e.Description, c.Manager_ID " +
                     "FROM Events e JOIN Clubs c ON e.Club_ID = c.Club_ID " +
                     "ORDER BY e.Event_Date ASC";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                events.add(new String[]{
                    rs.getString("Event_ID"),
                    rs.getString("Club_ID"),
                    rs.getString("Club_Name"),
                    rs.getString("Event_Name"),
                    rs.getString("Event_Date"),
                    rs.getString("Event_Type"),
                    rs.getString("Location"),
                    rs.getString("Description"),
                    rs.getString("Manager_ID")
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Searches events by keyword across name, type, location, and club name.
     * Same column order as getEvents().
     */
    public static List<String[]> searchEvents(String keyword) {
        List<String[]> events = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT e.Event_ID, e.Club_ID, c.Club_Name, e.Event_Name, " +
                     "e.Event_Date, e.Event_Type, e.Location, e.Description, c.Manager_ID " +
                     "FROM Events e JOIN Clubs c ON e.Club_ID = c.Club_ID " +
                     "WHERE e.Event_Name LIKE ? OR e.Event_Type LIKE ? " +
                     "   OR e.Location LIKE ? OR c.Club_Name LIKE ? " +
                     "ORDER BY e.Event_Date ASC";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            String p = "%" + keyword + "%";
            ps.setString(1, p); ps.setString(2, p);
            ps.setString(3, p); ps.setString(4, p);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    events.add(new String[]{
                        rs.getString("Event_ID"),
                        rs.getString("Club_ID"),
                        rs.getString("Club_Name"),
                        rs.getString("Event_Name"),
                        rs.getString("Event_Date"),
                        rs.getString("Event_Type"),
                        rs.getString("Location"),
                        rs.getString("Description"),
                        rs.getString("Manager_ID")
                    });
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    /**
     * Registers a user for an event (INSERT IGNORE prevents duplicates).
     *
     * @return true if a new registration was inserted.
     */
    public static boolean registerForEvent(int eventID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "INSERT IGNORE INTO Event_Registration (Event_ID, User_ID) VALUES (?, ?)";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventID);
            ps.setInt(2, userID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cancels a user's registration for an event.
     *
     * @return true if the row was removed.
     */
    public static boolean unregisterFromEvent(int eventID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "DELETE FROM Event_Registration WHERE Event_ID = ? AND User_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventID);
            ps.setInt(2, userID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks whether a user is already registered for an event.
     */
    public static boolean isUserRegisteredForEvent(int eventID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT 1 FROM Event_Registration WHERE Event_ID = ? AND User_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventID);
            ps.setInt(2, userID);
            return ps.executeQuery().next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns the attendee count for an event.
     */
    public static int getEventAttendeeCount(int eventID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT COUNT(*) FROM Event_Registration WHERE Event_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Returns only the clubs managed by a specific user.
     * Used to populate the "host club" dropdown on the create-event form.
     * Columns: [0]=Club_ID, [1]=Club_Name
     */
    public static List<String[]> getManagedClubs(int managerID) {
        List<String[]> clubs = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT Club_ID, Club_Name FROM Clubs WHERE Manager_ID = ? ORDER BY Club_Name";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, managerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    clubs.add(new String[]{
                        rs.getString("Club_ID"),
                        rs.getString("Club_Name")
                    });
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return clubs;
    }

    /**
     * Returns a single event row by Event_ID.
     * Same column order as getEvents(): [0..8]
     */
    public static String[] getEventByID(int eventID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT e.Event_ID, e.Club_ID, c.Club_Name, e.Event_Name, " +
                     "e.Event_Date, e.Event_Type, e.Location, e.Description, c.Manager_ID " +
                     "FROM Events e JOIN Clubs c ON e.Club_ID = c.Club_ID " +
                     "WHERE e.Event_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new String[]{
                    rs.getString("Event_ID"),
                    rs.getString("Club_ID"),
                    rs.getString("Club_Name"),
                    rs.getString("Event_Name"),
                    rs.getString("Event_Date"),
                    rs.getString("Event_Type"),
                    rs.getString("Location"),
                    rs.getString("Description"),
                    rs.getString("Manager_ID")
                };
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
 // ═══════════════════════════════════════════════════════════════
    //  CAR PHOTOS
    // ═══════════════════════════════════════════════════════════════

    /**
     * Adds a photo URL to a car the logged-in user owns.
     *
     * @param carID    The Car_ID to attach the photo to.
     * @param userID   The User_ID of the requester (ownership check).
     * @param photoURL The URL string to store.
     * @return true if inserted, false if ownership check failed or DB error.
     */
    public static boolean addCarPhoto(int carID, int userID, String photoURL) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        // Ownership check: only the car's owner may add photos
        String checkSQL = "SELECT 1 FROM Cars WHERE Car_ID = ? AND User_ID = ?";
        String insertSQL = "INSERT INTO CarPhotos (Car_ID, Photo_URL) VALUES (?, ?)";

        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            try (PreparedStatement check = con.prepareStatement(checkSQL)) {
                check.setInt(1, carID);
                check.setInt(2, userID);
                if (!check.executeQuery().next()) return false; // not the owner
            }
            try (PreparedStatement ps = con.prepareStatement(insertSQL)) {
                ps.setInt(1, carID);
                ps.setString(2, photoURL);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns all photos for a given car.
     * Columns: [0]=Photo_ID, [1]=Car_ID, [2]=Photo_URL
     */
    public static List<String[]> getCarPhotos(int carID) {
        List<String[]> photos = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT Photo_ID, Car_ID, Photo_URL FROM CarPhotos WHERE Car_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, carID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    photos.add(new String[]{
                        rs.getString("Photo_ID"),
                        rs.getString("Car_ID"),
                        rs.getString("Photo_URL")
                    });
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return photos;
    }

    /**
     * Deletes a car photo if the requesting user owns the car it belongs to.
     *
     * @param photoID The Photo_ID to delete.
     * @param userID  The User_ID of the requester (ownership check via Cars table).
     * @return true if deleted, false otherwise.
     */
    public static boolean deleteCarPhoto(int photoID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        // Only delete if the photo's car belongs to userID
        String sql = "DELETE cp FROM CarPhotos cp " +
                     "JOIN Cars c ON cp.Car_ID = c.Car_ID " +
                     "WHERE cp.Photo_ID = ? AND c.User_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, photoID);
            ps.setInt(2, userID);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns all cars owned by a user, for use in photo-upload dropdowns.
     * Columns: [0]=Car_ID, [1]=Make, [2]=Model, [3]=Year
     */
    public static List<String[]> getUserCars(int userID) {
        List<String[]> cars = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT Car_ID, Make, Model, Year FROM Cars WHERE User_ID = ? ORDER BY Year DESC";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    cars.add(new String[]{
                        rs.getString("Car_ID"),
                        rs.getString("Make"),
                        rs.getString("Model"),
                        rs.getString("Year")
                    });
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cars;
    }

    // ═══════════════════════════════════════════════════════════════
    //  EVENT PHOTOS
    // ═══════════════════════════════════════════════════════════════

    /**
     * Adds a photo URL to an event, only if the logged-in user manages the event's club.
     *
     * @param eventID  The Event_ID to attach the photo to.
     * @param userID   The User_ID of the requester (club manager check).
     * @param photoURL The URL string to store.
     * @return true if inserted, false if permission denied or DB error.
     */
    public static boolean addEventPhoto(int eventID, int userID, String photoURL) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        // Permission check: only the club's manager may add event photos
        String checkSQL = "SELECT 1 FROM Events e JOIN Clubs c ON e.Club_ID = c.Club_ID " +
                          "WHERE e.Event_ID = ? AND c.Manager_ID = ?";
        String insertSQL = "INSERT INTO EventPhotos (Event_ID, Photo_URL) VALUES (?, ?)";

        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            try (PreparedStatement check = con.prepareStatement(checkSQL)) {
                check.setInt(1, eventID);
                check.setInt(2, userID);
                if (!check.executeQuery().next()) return false; // not the manager
            }
            try (PreparedStatement ps = con.prepareStatement(insertSQL)) {
                ps.setInt(1, eventID);
                ps.setString(2, photoURL);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns all photos for a given event.
     * Columns: [0]=Photo_ID, [1]=Event_ID, [2]=Photo_URL
     */
    public static List<String[]> getEventPhotos(int eventID) {
        List<String[]> photos = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT Photo_ID, Event_ID, Photo_URL FROM EventPhotos WHERE Event_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, eventID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    photos.add(new String[]{
                        rs.getString("Photo_ID"),
                        rs.getString("Event_ID"),
                        rs.getString("Photo_URL")
                    });
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return photos;
    }

    /**
     * Deletes an event photo if the requesting user manages the event's club.
     *
     * @param photoID The Photo_ID to delete.
     * @param userID  The User_ID of the requester (manager check).
     * @return true if deleted, false otherwise.
     */
    public static boolean deleteEventPhoto(int photoID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "DELETE ep FROM EventPhotos ep " +
                     "JOIN Events e ON ep.Event_ID = e.Event_ID " +
                     "JOIN Clubs c ON e.Club_ID = c.Club_ID " +
                     "WHERE ep.Photo_ID = ? AND c.Manager_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, photoID);
            ps.setInt(2, userID);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  SPONSORS
    // ═══════════════════════════════════════════════════════════════

    /**
     * Returns all companies available as potential sponsors.
     * Columns: [0]=Company_ID, [1]=Company_Name
     */
    public static List<String[]> getAllCompanies() {
        List<String[]> companies = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT Company_ID, Company_Name FROM Company ORDER BY Company_Name";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                companies.add(new String[]{
                    rs.getString("Company_ID"),
                    rs.getString("Company_Name")
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return companies;
    }

    /**
     * Returns all sponsors currently linked to an event.
     * Columns: [0]=Company_ID, [1]=Company_Name
     */
    public static List<String[]> getEventSponsors(int eventID) {
        List<String[]> sponsors = new ArrayList<>();
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT c.Company_ID, c.Company_Name FROM Sponsors s " +
                     "JOIN Company c ON s.Company_ID = c.Company_ID " +
                     "WHERE s.Event_ID = ? ORDER BY c.Company_Name";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, eventID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    sponsors.add(new String[]{
                        rs.getString("Company_ID"),
                        rs.getString("Company_Name")
                    });
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sponsors;
    }

    /**
     * Links a company as a sponsor for an event.
     * Only the club manager of the event may call this (enforce in JSP).
     * INSERT IGNORE prevents duplicate sponsor records.
     *
     * @param eventID   The Event_ID to sponsor.
     * @param companyID The Company_ID to add as a sponsor.
     * @param userID    The User_ID of the requester (club manager check).
     * @return true if the sponsor link was created (or already existed).
     */
    public static boolean addSponsor(int eventID, int companyID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        // Permission check: only the club manager may manage sponsors
        String checkSQL = "SELECT 1 FROM Events e JOIN Clubs c ON e.Club_ID = c.Club_ID " +
                          "WHERE e.Event_ID = ? AND c.Manager_ID = ?";
        String insertSQL = "INSERT IGNORE INTO Sponsors (Company_ID, Event_ID) VALUES (?, ?)";

        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            try (PreparedStatement check = con.prepareStatement(checkSQL)) {
                check.setInt(1, eventID);
                check.setInt(2, userID);
                if (!check.executeQuery().next()) return false;
            }
            try (PreparedStatement ps = con.prepareStatement(insertSQL)) {
                ps.setInt(1, companyID);
                ps.setInt(2, eventID);
                ps.executeUpdate();
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Removes a company's sponsorship from an event.
     * Only the club manager may call this (enforce in JSP).
     *
     * @param eventID   The Event_ID.
     * @param companyID The Company_ID to remove.
     * @param userID    The User_ID of the requester (club manager check).
     * @return true if the sponsor link was removed.
     */
    public static boolean removeSponsor(int eventID, int companyID, int userID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        // Permission check
        String checkSQL = "SELECT 1 FROM Events e JOIN Clubs c ON e.Club_ID = c.Club_ID " +
                          "WHERE e.Event_ID = ? AND c.Manager_ID = ?";
        String deleteSQL = "DELETE FROM Sponsors WHERE Company_ID = ? AND Event_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass)) {
            try (PreparedStatement check = con.prepareStatement(checkSQL)) {
                check.setInt(1, eventID);
                check.setInt(2, userID);
                if (!check.executeQuery().next()) return false;
            }
            try (PreparedStatement ps = con.prepareStatement(deleteSQL)) {
                ps.setInt(1, companyID);
                ps.setInt(2, eventID);
                return ps.executeUpdate() == 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks if a company is already a sponsor for an event.
     */
    public static boolean isSponsor(int eventID, int companyID) {
        String url  = "jdbc:mysql://localhost:3306/carclub?autoReconnect=true&useSSL=false";
        String user = "root";
        String pass = "root";

        String sql = "SELECT 1 FROM Sponsors WHERE Event_ID = ? AND Company_ID = ?";

        try (Connection con = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, eventID);
            ps.setInt(2, companyID);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}