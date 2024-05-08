package account.servlet;

import account.database.AccountDAO;
import database.DBWorker;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import user.servlet.LoginServlet;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/createAccountServlet")
public class CreateAccountServlet extends HttpServlet {
    private static Logger logger;
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger = LogManager.getLogger(LoginServlet.class);
        LoggerUtils.setLogger(logger);

        logger.info("start CreateAccountServlet🚀");

        HttpSession currentUserSession = req.getSession();
        User currentUser = (User) currentUserSession.getAttribute("currentUserSession");
        String currencyTitle = req.getParameter("title");
        try
        {
            AccountDAO.createAccount(currentUser, currencyTitle);
        }
        catch (Exception e)
        {
            logger.error("Login error❌: " + e.getMessage());
            System.out.println("Login error❌: " + e.getMessage());
        }
        logger.info("CreateAccountServlet finished✅");
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().println("<html><head><script>window.opener.location.reload();window.close();</script></head></html>");
    }
}