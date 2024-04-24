package servlet;

import database.User;
import database.UserDAO;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;

/**
 * Servlet implementation class login
 */
@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = new User();
        UserDAO userDAO = new UserDAO();

        user.setEmail(req.getParameter("email"));
        user.setPassword(req.getParameter("password"));

        boolean loginStatus = false;
        try
        {
            loginStatus = userDAO.validate(user);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        if (loginStatus)
        {
            System.out.println("Login successfully!");
            RequestDispatcher requestDispatcher = req.getRequestDispatcher("login_success.jsp");
            requestDispatcher.forward(req, resp);
        }
        else
        {
            System.out.println("Try again!");
            req.setAttribute("ErrorMessage", "Incorrect email or password. Please try again.");
            RequestDispatcher requestDispatcher = req.getRequestDispatcher("login.jsp");
            requestDispatcher.forward(req, resp);
        }
    }
}
