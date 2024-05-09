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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.Serial;
@WebServlet("/updateClientServlet")
public class UpdateClientServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;
    private static Logger logger;
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = new User();
        HttpSession currentUserSession = req.getSession();
        user = (User) currentUserSession.getAttribute("currentUserSession");
        user.setEmail(req.getParameter("email"));
        user.setPassword(req.getParameter("password"));
        logger = LogManager.getLogger(LoginServlet.class);
        LoggerUtils.setLogger(logger);

        logger.info("start UpdateClientServlet🚀");

        try
        {
            UserDAO.updateUser(user.getId(), user.getEmail(), user.getPassword());
            currentUserSession.setAttribute("currentUserSession", user);
        }
        catch(Exception e)
        {
            logger.error("Update client data servlet ERROR❌: " + e.getMessage());
        }
        logger.info("UpdateClientServlet finished✅");
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().println("<html><head><script>window.opener.location.reload();window.close();</script></head></html>");
    }
}