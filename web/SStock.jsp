<%@page  import ="java.sql.*"%>
<%!
    public static Connection connect() {

        try {

            Class.forName("com.mysql.jdbc.Driver").newInstance();

            return DriverManager.getConnection("jdbc:mysql://localhost/stocdatabase", "root", "root");
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
        <title>Stock</title>
    </head>
    <body>
        <h1 align="center"><a href='Stkinfo.jsp'>Stock Information </a>&nbsp;&nbsp;&nbsp;&nbsp;  <a href='Stkq.jsp'>Stock Limited Quantity </a></h1>

        <h1>Stock List</h1>
        <% int counterpid = 0;
            String stocname = "";
            int cout = 0;
            int cout2 = 0;
            int cout3 = 0;
            int cout4 = 0;
            String sourstock = "";
            int catfk = 0;
            String pname = "";
            int prixx = 0;
            try {

                Connection c = connect();
                Statement stmt = c.createStatement();

                int sss = Integer.parseInt(session.getAttribute("theName").toString());
                ResultSet rs = stmt.executeQuery("select s.stockid,s.Stockname,p.idproduct,p.productname,p.productQuantity,p.productmodel from stocdatabase.stock s,stocdatabase.stocpro sp,stocdatabase.product p where s.Stockid=sp.stocid and p.idproduct=sp.prodid1 and s.Stockid<>" + sss + "");

        %>

        <table border =1><tr><td>Stock id</td><td>Stock name</td><td>Product ID</td><td>Product Name</td><td>Product Quantity</td><td>Product Model</td></tr>

            <% while (rs.next()) {%> 




            <tr>
                <td><%out.println(rs.getString(1));%></td> 
                <td><%out.println(rs.getString(2));%></td> 
                <td><%out.println(rs.getString(3));%></td> 
                <td><%out.println(rs.getString(4));%></td> 
                <td><%out.println(rs.getString(5));%></td>
                <td><%out.println(rs.getString(6));%></td> 
            </tr>



            <%  }%></table> <%

                    c.close();
                } catch (Exception e) {

                }
            %>
        <h1>Getting Product From Other Stocks</h1>    
        <form name="name1" action="#" method="POST">
            <table border="1">


                <tr>
                    <td>Current Stock Name:</td>
                    <td><input type="text" name="stocksource" value="" size="50" autocomplete="off"/></td>
                </tr>

                <tr>
                    <td>Order Date :</td>
                    <td><input type="text" name="odate" value="" size="50" autocomplete="off"/></td>
                </tr>

                <tr>
                    <td>Destination Stock Name:</td>
                    <td><input type="text" name="stockdestination" value="" size="50" autocomplete="off"/></td>
                </tr>

                <tr>
                    <td>Car number :</td>
                    <td><input type="text" name="cnumber" value="" size="50" autocomplete="off"/></td>
                </tr>

                <tr>
                    <td>driver id:</td>
                    <td><input type="text" name="did" value="" size="50" autocomplete="off"/></td>
                </tr>

                <tr>
                    <td>product id:</td>
                    <td><input type="text" name="pid" value="" size="50" autocomplete="off"/></td>
                </tr>
                <tr>
                    <td>product model:</td>
                    <td><input type="text" name="pmodel" value="" size="50" autocomplete="off"/></td>
                </tr>
                <tr>
                    <td>product Quantity :</td>
                    <td><input type="text" name="pquantity" value="" size="50" autocomplete="off"/></td>
                </tr>

                <tr>
                    <td><input type="submit" value="Add" name="btnadd"/></td>
                    <td><input type="reset" value="Reset" name="btnreset" /></td>
                </tr>

            </table>
        </form>

        <% if (request.getMethod().equals("POST")) {
                String stocksource, odate, stockdestination, cnumber, did, pid, pquantity, pmodel;
                stocksource = request.getParameter("stocksource");
                odate = request.getParameter("odate");
                stockdestination = request.getParameter("stockdestination");
                cnumber = request.getParameter("cnumber");
                did = request.getParameter("did");
                pid = request.getParameter("pid");
                pmodel = request.getParameter("pmodel");
                pquantity = request.getParameter("pquantity");

                try {
                    Connection c = connect();
if (!stocksource.equalsIgnoreCase(null) || !stockdestination.equalsIgnoreCase(null)){
                    String sql = "insert into stocdatabase.transfer(sourcestock,sourcedate,destinationstock,driverid,carnumber,productid,productQuantity,productmodel)  values ('" + stocksource + "','" + odate + "','" + stockdestination + "'," + did + ",'" + cnumber + "'," + pid + "," + pquantity + ",'" + pmodel + "')";

                    Statement stmt1 = c.createStatement();
                    stmt1.executeUpdate(sql);
}
                    c.close();

                } catch (Exception e) {
                    out.print(e.getMessage());
                }
            }%>
        <h1>Transfer Need Validation</h1>

        <% try {

                Connection c = connect();
                Statement stmt = c.createStatement();
                int sss = Integer.parseInt(session.getAttribute("theName").toString());
                ResultSet rs1 = stmt.executeQuery("select Stockname from stocdatabase.stock where Stockid=" + sss + "");
                while (rs1.next()) {
                    stocname = rs1.getString(1);
                    request.setAttribute("stocname1", stocname);

                }
                //out.println(request.getAttribute("stocname1"));
                ResultSet rs = stmt.executeQuery("select * from transfer where destinationstock='" + request.getAttribute("stocname1").toString() + "' and validatedestinationstock is null");
        %>
        <table border="1"> <tr><td>Transfer id</td><td>Source Stock</td><td>destination stock</td><td>source date</td><td>destination date</td><td>driver id</td><td>car number</td><td>validate destination stock</td><td>product id</td><td>product quantity</td><td>product model</td><tr>

                <% while (rs.next()) {%>
            <tr>
                <td><%out.println(rs.getString(1));%></td> 
                <td><%out.println(rs.getString(2));%></td> 
                <td><%out.println(rs.getString(3));%></td> 
                <td><%out.println(rs.getString(4));%></td> 
                <td><%out.println(rs.getString(5));%></td>
                <td><%out.println(rs.getString(6));%></td> 
                <td><%out.println(rs.getString(7));%></td> 
                <td><%out.println(rs.getString(8));%></td> 
                <td><%out.println(rs.getString(9));%></td> 
                <td><%out.println(rs.getString(10));%></td>  
                <td><%out.println(rs.getString(11));%></td>  
            </tr>

            <%  } %></table> <%
                    c.close();
                } catch (Exception e) {

                }


            %>
        <h1>Validate Product Ordered by Other Stock</h1>    
        <form name="name1" action="#" method="POST">
            <table border="1">


                <tr>
                    <td>Transfer ID :</td>
                    <td><input type="text" name="TID" value="" size="50" autocomplete="off"/></td>
                </tr>


                <tr>
                    <td><input type="submit" value="Add" name="btnadd"/></td>
                    <td><input type="reset" value="Reset" name="btnreset" /></td>
                </tr>

            </table>
        </form>

        <% int pid2, pq2, realpq;
            String model1;

            if (request.getMethod().equals("POST")) {
                String TID1;
                TID1 = request.getParameter("TID");

                try {

                    Connection c = connect();
                    Statement stmt16 = c.createStatement();
                    out.println(request.getParameter("TID"));
                    ResultSet rs = stmt16.executeQuery("select transferid,sourcestock,sourcedate,destinationstock,driverid,carnumber,productid,productQuantity,productmodel from transfer where transferid=" + Integer.parseInt(request.getParameter("TID").toString()) + "");

                    while (rs.next()) {
                        pid2 = Integer.parseInt(rs.getString(7));
                        request.setAttribute("prodid2", pid2);
                        pq2 = Integer.parseInt(rs.getString(8));
                        sourstock = rs.getString(2);

                        request.setAttribute("Sourcestockname", sourstock);
                        request.setAttribute("prodq2", pq2);
                        model1 = rs.getString(9);
                        request.setAttribute("prodmodel", model1);
                        out.println(request.getAttribute("prodid2"));
                    }
                    Statement stmt99 = c.createStatement();
                    ResultSet rte = stmt99.executeQuery("SELECT Stockid FROM stocdatabase.stock where Stockname='" + request.getAttribute("Sourcestockname").toString() + "';");
                    while (rte.next()) {
                        request.setAttribute("Sourcestock", rte.getString(1));

                    }
                    int pid = Integer.parseInt(request.getAttribute("prodid2").toString());
                    Statement stmt1 = c.createStatement();
                    ResultSet rs1 = stmt1.executeQuery("Select productQuantity from stocdatabase.product where idproduct=" + pid + "");
                    while (rs1.next()) {

                        realpq = Integer.parseInt(rs1.getString(1));
                        request.setAttribute("realpq1", realpq);
                        out.println(realpq);
                    }

                    int s = Integer.parseInt(request.getAttribute("realpq1").toString()) - Integer.parseInt(request.getAttribute("prodq2").toString());
                    out.print(s);
                    request.setAttribute("qs", s);
                    if (s < 0) {

                        out.println("we dont have enough quantity");
                      String sql2 = "update  stocdatabase.transfer  set validatedestinationstock='" + "quantity problem" + "' where transferid=" + Integer.parseInt(request.getParameter("TID").toString()) + "";

                        Statement stmt2 = c.createStatement();
                        stmt2.executeUpdate(sql2);

                    } else if (s >= 0) {
                        int r = Integer.parseInt(request.getAttribute("qs").toString());
                        if (s < 4) {
                            out.println("Alert you reached Product Limit");
                        }
                        String sql = "update  stocdatabase.product  set productQuantity=" + r + " where idproduct=" + Integer.parseInt(request.getAttribute("prodid2").toString()) + "";

                        Statement stmt2 = c.createStatement();
                        stmt2.executeUpdate(sql);

                        Statement stmt5125 = c.createStatement();
                        out.println("Source Stock" + Integer.parseInt(request.getAttribute("Sourcestock").toString()));
                        out.println("Product Model" + request.getAttribute("prodmodel").toString());
                        ResultSet rs5125 = stmt5125.executeQuery("Select count(idproduct) from stocdatabase.stock s,stocdatabase.stocpro sp,stocdatabase.product p where s.Stockid=sp.stocid and p.idproduct=sp.prodid1 and s.Stockid= " + Integer.parseInt(request.getAttribute("Sourcestock").toString()) + " and  productmodel='" + request.getAttribute("prodmodel").toString() + "'");
                        while (rs5125.next()) {

                            cout2 = Integer.parseInt(rs5125.getString(1));
                            // cout3 = Integer.parseInt(rs5125.getString(2));
                            //  cout4 = Integer.parseInt(rs5125.getString(3));
                            request.setAttribute("pmodelexist", cout2);
                            //   request.setAttribute("pmodelquantity", cout3);
                            //  request.setAttribute("pid", cout4);
                            out.println("inside loop" + cout2);
                        }
                        String modeld = request.getAttribute("pmodelexist").toString();

                        //String modeld2 = "";
                        //String modeld1 = "";
                        int modelq = Integer.parseInt(request.getAttribute("pmodelexist").toString());
                        out.println("MODEL Q  " + modelq);
                        if (modelq > 0) {
                            Statement stmtq5125 = c.createStatement();
                            ResultSet rsq5125 = stmtq5125.executeQuery("Select count(idproduct) ,productQuantity,idproduct from stocdatabase.stock s,stocdatabase.stocpro sp,stocdatabase.product p where s.Stockid=sp.stocid and p.idproduct=sp.prodid1 and s.Stockid= " + Integer.parseInt(request.getAttribute("Sourcestock").toString()) + " and  productmodel='" + request.getAttribute("prodmodel").toString() + "'");

                            while (rsq5125.next()) {
                                cout3 = Integer.parseInt(rs5125.getString(2));
                                cout4 = Integer.parseInt(rs5125.getString(3));
                                request.setAttribute("pmodelquantity", cout3);
                                request.setAttribute("pid", cout4);

                            }

                            String modeld1 = request.getAttribute("pmodelquantity").toString();
                            String modeld2 = request.getAttribute("pid").toString();
                            int modelq2 = Integer.parseInt(modeld2);
                            int modelq1 = Integer.parseInt(modeld1) + Integer.parseInt(request.getAttribute("prodq2").toString());
                            out.println(" Model Exist " + modelq1 + "  " + modelq2 + " ");

                            String sqlm = "update  stocdatabase.product  set productQuantity=" + modelq1 + " where idproduct=" + modelq2 + "";

                            Statement stmt15 = c.createStatement();
                            stmt15.executeUpdate(sqlm);
                            String xx=new java.util.Date()+" ";
                            request.setAttribute(xx, "o");
                                  String sql2 = "update  stocdatabase.transfer  set destinationdate='"+xx+"',validatedestinationstock='" + "Validated"+"'  where transferid=" + Integer.parseInt(request.getParameter("TID").toString()) + "";

                        Statement stmt2020 = c.createStatement();
                        stmt2020.executeUpdate(sql2);

                        } else if (modelq == 0) {
                            out.println(Integer.parseInt(request.getAttribute("prodid2").toString()));
                            Statement stmt25 = c.createStatement();
                            ResultSet rs25 = stmt25.executeQuery("Select idproduct,productname,productmodel,productQuantity,prix,Rdate,catfk from product where idproduct=" + Integer.parseInt(request.getAttribute("prodid2").toString()) + "");
                            while (rs25.next()) {
                                catfk = Integer.parseInt(rs25.getString(7));
                                pname = rs25.getString(2);
                                prixx = Integer.parseInt(rs25.getString(5));
                                request.setAttribute("category", catfk);
                                request.setAttribute("prodname", pname);

                            }

                            String sql500 = "insert into stocdatabase.product(catfk,productname,productmodel,productQuantity)  values (" + Integer.parseInt(request.getAttribute("category").toString()) + ",'" + request.getAttribute("prodname").toString() + "','" + request.getAttribute("prodmodel").toString() + "'," + Integer.parseInt(request.getAttribute("prodq2").toString()) + ")";
                            Statement stmt151 = c.createStatement();

                            stmt151.executeUpdate(sql500);

                            Statement stmt3 = c.createStatement();
                            ResultSet rs3 = stmt3.executeQuery("Select count(idproduct) from stocdatabase.product");

                            while (rs3.next()) {
                                counterpid = Integer.parseInt(rs3.getString(1));
                                request.setAttribute("pid1", counterpid);

                            }
                            String sssdw = request.getAttribute("pid1").toString();
                            int sedaserqw = Integer.parseInt(sssdw);
                            out.println(sedaserqw);

                            String sql121 = "insert into stocdatabase.stocpro(Stocid,prodid1)  values (" + Integer.parseInt(request.getAttribute("Sourcestock").toString()) + "," + sssdw + ")";

                            Statement stmt200 = c.createStatement();
                            stmt200.executeUpdate(sql121);
                       String xx=new java.util.Date()+" ";
                            request.setAttribute(xx, "o");
                            
                             String sql2 = "update  stocdatabase.transfer  set destinationdate='"+xx+"',validatedestinationstock='" + "Validated" + "' where transferid=" + Integer.parseInt(request.getParameter("TID").toString()) + "";

                        Statement stmt2020 = c.createStatement();
                        stmt2020.executeUpdate(sql2);
                            

                        }

                    }

                    c.close();

                } catch (Exception e) {
                    out.print(e.getMessage());
                }
            }%>






    </body>
</html>
