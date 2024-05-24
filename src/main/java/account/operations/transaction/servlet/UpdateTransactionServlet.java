package account.operations.transaction.servlet;

import account.database.Account;
import account.operations.credit.database.Credit;
import account.operations.credit.database.CreditDAO;
import account.operations.credit.servlet.UpdateCreditDataServlet;
import account.operations.transaction.database.Transaction;
import account.operations.transaction.database.TransactionDAO;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/updateTransactionServlet")
public class UpdateTransactionServlet extends HttpServlet {
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(UpdateTransactionServlet.class);
        LoggerUtils.setLogger(logger);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger.info("start UpdateTransactionServlet🚀");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUserSession");

        int currentAccountPosIndex = 0;
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("currentAccountIndex")) {
                    currentAccountPosIndex = Integer.parseInt(cookie.getValue());
                }
            }
        }
        int currentAccountIndex = user.getAccount(currentAccountPosIndex).getId();
        List<Transaction> transactions = TransactionDAO.getTransactionsDataByAccountId(currentAccountIndex);

        Account account = user.getAccount(currentAccountPosIndex);
        account.setTransactions(transactions);
        user.setAccount(currentAccountPosIndex, account);
        session.setAttribute("currentUserSession", user);

        logger.info("UpdateTransactionServlet finished✅");
    }
}
