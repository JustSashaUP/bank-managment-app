package account.operations.deposit.servlet;

import account.database.Account;
import account.operations.credit.database.Credit;
import account.operations.credit.database.CreditDAO;
import account.operations.credit.servlet.UpdateCreditDataServlet;
import account.operations.deposit.database.Deposit;
import account.operations.deposit.database.DepositDAO;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
@WebServlet("/updateDepositServlet")
public class UpdateDepositDataServlet extends HttpServlet {
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
        logger.info("start UpdateDepositServlet🚀");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUserSession");

        int currentAccountPosIndex = 0;
        int currentDepositPosIndex = 0;
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("currentAccountIndex")) {
                    currentAccountPosIndex = Integer.parseInt(cookie.getValue());
                }
                if (cookie.getName().equals("currentDepositIndex")) {
                    currentDepositPosIndex = Integer.parseInt(cookie.getValue());
                }
            }
        }
        int currentAccountIndex = user.getAccount(currentAccountPosIndex).getId();
        List<Deposit> deposits = DepositDAO.getDepositsDataByAccountId(currentAccountIndex);

        Account account = user.getAccount(currentAccountPosIndex);
        account.setDeposits(deposits);
        user.setAccount(currentAccountPosIndex, account);
        session.setAttribute("currentUserSession", user);

        logger.info("UpdateDepositServlet finished✅");
    }
}
