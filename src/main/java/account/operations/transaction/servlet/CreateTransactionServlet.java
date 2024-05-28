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

@WebServlet("/createTransactionServlet")
public class CreateTransactionServlet extends HttpServlet {
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(CreateTransactionServlet.class);
        LoggerUtils.setLogger(logger);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger.info("start CreateTransactionServlet🚀");

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
        String cardNumber = req.getParameter("card_number");
        int status = 0;
        try
        {
            status = TransactionDAO.transfer(id, Double.parseDouble(amount), cardNumber);
        }
        catch (Exception e)
        {
            logger.error("Creating transaction servlet error❌: " + e.getMessage());
        }
        logger.info("CreateTransactionServlet finished✅");
        if (status > 0) {
            req.setAttribute("successMessage", "Successfully!");
        } else {
            req.setAttribute("errorMessage", "Failed!");
        }
        req.getRequestDispatcher("transactionPage.jsp").include(req, resp);
    }
}
