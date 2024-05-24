package account.servlet;

import account.database.Account;
import account.database.AccountDAO;
import account.operations.credit.database.Credit;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import user.servlet.LoginServlet;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/updateAccountServlet")

public class UpdateAccountDataServlet extends HttpServlet {
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(UpdateAccountDataServlet.class);
        LoggerUtils.setLogger(logger);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger.info("start UpdateAccountServlet🚀");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUserSession");

        List<Account> accounts = AccountDAO.getAccountsDataByClientId(user.getId());

        user.setAccounts(accounts);
        session.setAttribute("currentUserSession", user);

        logger.info("UpdateAccountServlet finished✅");
    }
}