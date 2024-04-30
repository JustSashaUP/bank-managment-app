package user.servlet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import user.database.UserDAO;
import utils.fileutil.LoggerUtils;

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
    private static Logger logger;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = new User();
        UserDAO userDAO = new UserDAO();
        logger = LogManager.getLogger(LoginServlet.class);
        LoggerUtils.setLogger(logger);

        logger.info("start LoginServlet");

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
            logger.info("Login successfully!");
            req.getRequestDispatcher("/setCookiesServlet").forward(req, resp);
        }
        else
        {
            logger.warn("Login invalid data!");
            req.setAttribute("errorMessage", "Incorrect email or password. Please try again.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
        logger.info("LoginServlet finished");
    }
}