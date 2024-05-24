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
        logger = LogManager.getLogger(SetCookiesServlet.class);
        LoggerUtils.setLogger(logger);
        logger.info("Start SetCookiesServlet🚀");

        userDAO = new UserDAO();

        String auntId = String.format("%d", userDAO.getUserId(req.getParameter("email")));

        Cookie cookieAccount = new Cookie("currentAccountIndex", "0");
        Cookie cookieCredit = new Cookie("currentCreditIndex", "0");
        Cookie cookieDeposit = new Cookie("currentDepositIndex", "0");
        Cookie cookie = new Cookie("auntId", auntId);

        logger.info("SET user cookies✔️: " + auntId);
        logger.info("SET account cookies✔️: " + cookieAccount.getValue());
        logger.info("SET credit cookies✔️: " + cookieCredit.getValue());
        logger.info("SET deposit cookies✔️: " + cookieDeposit.getValue());

        cookie.setMaxAge(-1);
        cookieAccount.setMaxAge(-1);
        cookieCredit.setMaxAge(-1);
        cookieDeposit.setMaxAge(-1);

        resp.addCookie(cookie);
        resp.addCookie(cookieAccount);
        resp.addCookie(cookieCredit);
        resp.addCookie(cookieDeposit);

        logger.info("SetCookiesServlet finished✅");
        resp.sendRedirect("homePage.jsp");
        //req.getRequestDispatcher("/getCookiesServlet").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
