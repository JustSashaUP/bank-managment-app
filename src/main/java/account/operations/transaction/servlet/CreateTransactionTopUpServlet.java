package account.operations.transaction.servlet;

import account.operations.transaction.database.TransactionDAO;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/createTopUpServlet")
public class CreateTransactionTopUpServlet extends HttpServlet {
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(CreateTransactionTopUpServlet.class);
        LoggerUtils.setLogger(logger);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger.info("start CreateTransactionTopUpServlet🚀");

        HttpSession currentUserSession = req.getSession();
        User currentUser = (User) currentUserSession.getAttribute("currentUserSession");

        Cookie[] cookies = req.getCookies();
        int currentAccountIndex = 0;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("currentAccountIndex")) {
                    currentAccountIndex = Integer.parseInt(cookie.getValue());
                    break;
                }
            }
        }

        int id = currentUser.getAccount(currentAccountIndex).getId();
        String amount = req.getParameter("amount");
        try
        {
            TransactionDAO.accountTopUp(id, Double.parseDouble(amount));
        }
        catch (Exception e)
        {
            logger.error("Creating transaction servlet error❌: " + e.getMessage());
        }
        logger.info("CreateTransactionTopUpServlet finished✅");
    }
}
