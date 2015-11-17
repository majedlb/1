<%@page  import ="java.sql.*"%>
<%!
    public static Connection connect() {

        try {

            Class.forName("com.mysql.jdbc.Driver").newInstance();

            return DriverManager.getConnection("jdbc:mysql://localhost/stocdatabase", "root", "123456");
        } catch (Exception e) {
            return null;
        }

    }

    public static boolean close(Connection c) {
        try {
            c.close();
            return true;
        } catch (Exception e) {
            return false;
        }
    }


%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
          <h1>Transfer List</h1>
         <% try {

                Connection c = connect();
                Statement stmt = c.createStatement();
                ResultSet rs = stmt.executeQuery("Select * from transfer");

        %>
        <table border="1"> <tr><td>Transfer id</td><td>Source Stock</td><td>destination stock</td><td>source date</td><td>destination date</td><td>driver id</td><td>car number</td><td>validate destination stock</td><td>product id</td><td>product quantity</td><td>product model</td><tr>


        <% while (rs.next()) {%>
        


            <tr>
                <td><%out.println(rs.getString(1));%></td> 
                <td><%out.println(rs.getString(2));%></td> 
                <td><%out.println(rs.getString(3));%></td> 
                <td><%out.println(rs.getString(4));%></td> 
                     </tr>


       
        <%  }%> </table>  <%

                c.close();
            } catch (Exception e) {

            }
        %>
    </body>
</html>
