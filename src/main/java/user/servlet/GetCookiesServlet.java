package user.servlet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/getCookiesServlet")
public class GetCookiesServlet extends HttpServlet {
    private static Logger logger;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger = LogManager.getLogger(GetCookiesServlet.class);
        LoggerUtils.setLogger(logger);
        logger.info("Start GetCookiesServlet🚀");

        Cookie[] cookies = req.getCookies();
        HttpSession session = req.getSession();

        if (cookies != null)
        {
            for (Cookie cookie : cookies)
            {
                if (cookie.getName().equals("auntId"))
                {
                    if (session.isNew())
                    {
                        String cookieValue = cookie.getValue();
                        session.setAttribute("auntId", cookieValue);
                    }
                    break;
                }
            }
        }
        logger.info("GetCookiesServlet finished✅");
        resp.sendRedirect("homePage.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}