package account.operations.credit.servlet;

import account.database.AccountDAO;
import account.operations.credit.database.CreditDAO;
import account.servlet.CreateAccountServlet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/createCreditServlet")
public class CreateCreditServlet extends HttpServlet {
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(CreateCreditServlet.class);
        LoggerUtils.setLogger(logger);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger.info("start CreateCreditServlet🚀");

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

        String amount = req.getParameter("amount");
        String term = req.getParameter("term");
        int status = 0;
        try
        {
            status = CreditDAO.createCredit(
                    currentUser.getAccount(currentAccountIndex).getId(),
                    Double.parseDouble(amount),
                    Integer.parseInt(term));
        }
        catch (Exception e)
        {
            logger.error("Creating credit servlet error❌: " + e.getMessage());
        }
        logger.info("CreateCreditServlet finished✅");
        if (status > 0) {
            req.setAttribute("successMessage", "Successfully!");
        } else {
            req.setAttribute("errorMessage", "Failed!");
        }
        req.getRequestDispatcher("creditForm.jsp").include(req, resp);
        //resp.sendRedirect("accountPage.jsp");
    }
}
