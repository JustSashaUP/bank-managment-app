package user.servlet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import user.database.UserDAO;
import utils.fileutil.LoggerUtils;

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
    @Serial
    private static final long serialVersionUID = 1L;
    private static UserDAO userDAO;
    private static User user;
    private static Logger logger;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        userDAO = new UserDAO();
        user = new User();
        logger = LogManager.getLogger(LoginServlet.class);
        LoggerUtils.setLogger(logger);

        logger.info("start RegisterServlet");

        user.setFirstName(req.getParameter("firstName"));
        user.setLastName(req.getParameter("lastName"));
        user.setEmail(req.getParameter("email"));
        user.setPhoneNumber(req.getParameter("phoneNumber"));
        user.setPassword(req.getParameter("password"));
        try {
            user.setBirthDate(req.getParameter("birthDate"));
            if (!(userDAO.validate(user)))
            {
                userDAO.registerUser(user);
                logger.info("Register successfully!");
                req.getRequestDispatcher("register_success.jsp").forward(req, resp);
                return;
            }
        } catch (ParseException e) {
            logger.error("RegisterServlet ERROR: " + e.getMessage());
            System.out.println("RegisterServlet ERROR: " + e.getMessage());
        }
        logger.warn("User already member!");
        req.setAttribute("errorMessage", "User already member!");
        req.getRequestDispatcher("register.jsp").forward(req, resp);
        logger.info("RegisterServlet finished");
    }
}