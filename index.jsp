<!DOCTYPE <!DOCTYPE html>

<%

    String status = (String)session.getAttribute("status");
    String results = (String)session.getAttribute("results");
    String updateResponse = (String)session.getAttribute("updateResponse");
    String queryResponse = (String)session.getAttribute("queryResponse");

    String[] mysqlColNamesArray = (String[])session.getAttribute("mysqlColNamesArray");
    Object[][] values = (Object[][])session.getAttribute("values");
    Integer rowCount = (Integer)session.getAttribute("rowCount");

    if (rowCount == null) rowCount = 0;
    if (status == null || status.equalsIgnoreCase("false")) status = "You are not connected to a database";
    else status = "You are connected to the project4 Enterprise System database";

    
    
%>

<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Three-Tier Distributed Web-Based Application</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" media="screen" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />
</head>
<body>
    <div class="ui container" >
        <div class="ui container" style="margin-top:50px;">
            <h1 class="ui header">Welcome to the Fall 2018 Project 4 Enterprise System</h1>
            <h2 class="ui header">A Remote Database Management System</h2>
        </div>
    
        <div class="ui divider"></div>
        <div class="ui ignorned warning message">
                <p><%= status %></p>
        </div>
        <br>
        <form class="ui form" action="/project4/project4servlet" method="GET">
            <div class="field">
                <textarea name="commandText"></textarea>
            </div>
            <div class="field">
                <input class="ui button" type="submit" value="Execute Command">
            </div>
        </form>
        <input class="ui button" type="submit" value="Clear Form" onclick="clearForm();">
        <br>

        <div class="ui divider"></div>
        <h2 class="ui header">Database Results:</h2>        
        <%
            if (mysqlColNamesArray != null) {
                out.print("<table class=\"ui celled table\" id=\"table\"> ");
                out.print("<thead>");
                out.print("<tr>");

                for (int i = 0; i < mysqlColNamesArray.length; i++) {
                    out.print("<th>" + mysqlColNamesArray[i] + "</th>");
                }
                
                out.print("</tr>");
                out.print("</thead>");

                out.print("<tbody>");
                for (int i = 0; i < rowCount; i++) {
                    out.print("<tr>");
                    for (int x = 0; x < values[i].length; x++) {
                        out.print("<td>" + values[i][x] + "</td>");
                    }
                    out.print("</tr>");
                }
                out.print("</tbody>");
     
                out.print("</table>");
                session.setAttribute("mysqlColNamesArray" , null);
                session.setAttribute("updateResponse", null);
            }

            if (queryResponse != null) {
                out.print("<div class=\"ui ignorned error message\">");
                out.print("<p>Error executing the SQL statement:</p>");
                out.print("<p>" + queryResponse + "</p></div>");
                session.setAttribute("queryResponse" , null);
                session.setAttribute("updateResponse", null);
            }

            if (updateResponse != null) {
                out.print("<div class=\"ui ignorned success message\">");
                    out.print("<p>" + updateResponse + "</p>");
                out.print("</div>");
            }
        %>
        
        <div class="ui divider"></div>

    </div>
</body>
<script>
    
    function clearForm() {
        console.log("pressed");
        var Table = document.getElementById("table");
        Table.remove(this);
    }

</script>
</html>