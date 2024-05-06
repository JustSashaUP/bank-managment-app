package user.servlet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import utils.fileutil.LoggerUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serial;

@WebServlet("/logoutServlet")
public class LogoutServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;
    private static Logger logger;
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        logger = LogManager.getLogger(LogoutServlet.class);
        LoggerUtils.setLogger(logger);
        logger.info("Start LogoutServlet🚀");
        try(PrintWriter out = resp.getWriter()){
            if(req.getSession().getAttribute("currentUserSession") != null) {
                req.getSession().removeAttribute("currentUserSession");
                resp.sendRedirect("index.jsp");
            }else {
                resp.sendRedirect("homePage.jsp");
            }
        }
        logger.info("LogoutServlet finished✅");
    }
}
