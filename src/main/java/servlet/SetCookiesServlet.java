package servlet;

import database.User;
import database.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/setCookiesServlet")
public class SetCookiesServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("set Cookies");
        userDAO = new UserDAO();

        String value = String.format("%d", userDAO.getUserId(req.getParameter("email")));

        Cookie cookie = new Cookie("user_id", value);

        cookie.setMaxAge(-1);
        resp.addCookie(cookie);

        resp.sendRedirect("homePage.jsp");
        System.out.println("Done!");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("post");
        doGet(req, resp);
    }
}
