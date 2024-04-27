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
import java.text.ParseException;

/**
 * Servlet implementation class register
 */
@WebServlet("/registerServlet")
public class RegisterServlet extends HttpServlet {
    private static UserDAO userDAO;
    @Serial
    private static final long serialVersionUID = 1L;

    public RegisterServlet() {
        super();
    }

    public void init()
    {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = new User();
        user.setFirstName(req.getParameter("firstName"));
        user.setLastName(req.getParameter("lastName"));
        user.setEmail(req.getParameter("email"));
        user.setPhoneNumber(req.getParameter("phoneNumber"));
        user.setPassword(req.getParameter("password"));
        try {
            user.setBirthDate(req.getParameter("birthDate"));
            userDAO.registerUser(user);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        RequestDispatcher requestDispatcher = req.getRequestDispatcher("register_success.jsp");
        requestDispatcher.forward(req, resp);
    }
}