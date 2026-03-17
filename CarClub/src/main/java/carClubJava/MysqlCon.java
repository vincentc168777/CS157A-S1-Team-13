package carClubJava;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;

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
}