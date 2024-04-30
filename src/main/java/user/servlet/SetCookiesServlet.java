package user.servlet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.UserDAO;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/setCookiesServlet")
public class SetCookiesServlet extends HttpServlet {
    private UserDAO userDAO;
    private static Logger logger;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger = LogManager.getLogger(LoginServlet.class);
        LoggerUtils.setLogger(logger);
        logger.info("Start SetCookiesServlet");

        userDAO = new UserDAO();

        String value = String.format("%d", userDAO.getUserId(req.getParameter("email")));
        Cookie cookie = new Cookie("auntId", value);

        logger.info("SET user cookies: " + value);

        cookie.setMaxAge(-1);
        resp.addCookie(cookie);

        logger.info("SetCookiesServlet finished");
        req.getRequestDispatcher("/getCookiesServlet").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
