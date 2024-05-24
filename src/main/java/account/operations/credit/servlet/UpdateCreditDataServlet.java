package account.operations.credit.servlet;

import account.database.Account;
import account.operations.credit.database.Credit;
import account.operations.credit.database.CreditDAO;
import account.servlet.UpdateAccountDataServlet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
@WebServlet("/updateCreditServlet")
public class UpdateCreditDataServlet extends HttpServlet {
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(UpdateCreditDataServlet.class);
        LoggerUtils.setLogger(logger);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger.info("start UpdateCreditServlet🚀");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUserSession");

        int currentAccountPosIndex = 0;
        int currentCreditPosIndex = 0;
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("currentAccountIndex")) {
                    currentAccountPosIndex = Integer.parseInt(cookie.getValue());
                }
                if (cookie.getName().equals("currentCreditIndex")) {
                    currentCreditPosIndex = Integer.parseInt(cookie.getValue());
                }
            }
        }
        int currentAccountIndex = user.getAccount(currentAccountPosIndex).getId();
        List<Credit> credits = CreditDAO.getCreditsDataByAccountId(currentAccountIndex);

        Account account = user.getAccount(currentAccountPosIndex);
        account.setCredits(credits);
        user.setAccount(currentAccountPosIndex, account);
        session.setAttribute("currentUserSession", user);

        logger.info("UpdateCreditServlet finished✅");
    }
}