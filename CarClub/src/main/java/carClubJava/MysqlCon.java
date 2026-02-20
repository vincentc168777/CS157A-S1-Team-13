package carClubJava;

import java.sql.*;

public class MysqlCon {
    public static void main(String[] args) {
        try {
        	Class.forName("com.mysql.jdbc.Driver");
        	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/cheng?autoReconnect=true&useSSL=false","root","root");
        	//here cheng is database name, root is username and password
        	Statement stmt=con.createStatement();
        	ResultSet rs=stmt.executeQuery("select * from Student");
        	while(rs.next())
        	System.out.println(rs.getInt(1)+" "+rs.getString(2)+" "+rs.getString(3));
        	rs.close();
            stmt.close();
        	con.close();
            System.out.println("Connection closed.");
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }
}