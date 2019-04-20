/*
    Name: Rolando Murillo
    Course: CNT 4714 – Fall 2018 – Project Four
    Assignment title: A Three-Tier Distributed Web-Based Application
    Date: November 18, 2018
*/


import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.table.AbstractTableModel;
import java.io.IOException;
import java.sql.*;


public class Project4Servlet extends HttpServlet {

    private MySQLModel mySQLModel;

    private MySQLModel initMySQLModel() {
        return new MySQLModel();
    }

    private String connectDB() {
        String url = mySQLModel.databaseURLOptions[0];
        String result = mySQLModel.connectToDatabase("root", "alittlebirdie00", url);

        return result;
    }

    private String executeQuery(String command) {
        return mySQLModel.executeSQLQuery(command);
    }

    private String executeUpdate(String command) {
        return mySQLModel.executeSQLUpdate(command);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (mySQLModel == null) {
            mySQLModel = initMySQLModel();
        }

        String connectionResultStatus = connectDB();

        String commandString = req.getParameter("commandText");
        String[] wordsInCommand = commandString.split(" ", 2);

        // Select Command
        if (wordsInCommand[0].equalsIgnoreCase("select")) {
            String queryResponse = executeQuery(commandString);
            HttpSession session = req.getSession();
            // If there was a null response, that means no error message was returned from the model.
            // So continue with parsing the results.
            if (queryResponse == null) {


                String[] colNames = new String[mySQLModel.getColumnCount()];
                session.setAttribute("count", mySQLModel.getColumnCount());

                for (int i = 0; i < mySQLModel.getColumnCount(); i++) {
                    colNames[i] = mySQLModel.getColumnName(i);
                }

                Object[][] values = new Object[mySQLModel.getRowCount()][mySQLModel.getColumnCount()];

                for (int i = 0; i < values.length; i++) {
                    for (int x = 0; x < values[i].length; x++) {
                        values[i][x] = mySQLModel.getValueAt(i, x);
                    }
                }

                session.setAttribute("mysqlColNamesArray", colNames);
                session.setAttribute("rowCount", mySQLModel.getRowCount());
                session.setAttribute("values", values);
            }
            // If there is a response, that means that there was an error message after trying to
            // execute the query
            else {
                session.setAttribute("queryResponse", queryResponse);
            }
        }
        // Command does not begin with select. Must be an update type command
        else {
            String updateResponse = executeUpdate(commandString);
            HttpSession session = req.getSession();
            session.setAttribute("updateResponse", "Response: " + updateResponse);
        }

        HttpSession session = req.getSession();
        session.setAttribute("status", "Status: " + connectionResultStatus);
        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/index.jsp");
        dispatcher.forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

    }
}
