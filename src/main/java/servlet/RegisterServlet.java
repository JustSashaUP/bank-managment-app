package servlet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;

/**
 * Servlet implementation class register
 */
@WebServlet("/registerServlet")
public class RegisterServlet extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    public RegisterServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String email = req.getParameter("email");
        String phoneNumber = req.getParameter("phoneNumber");
        String birthDate = req.getParameter("birthDate");
        String password = req.getParameter("password");

        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty()
        || phoneNumber.isEmpty() || birthDate.isEmpty() || password.isEmpty())
        {
            RequestDispatcher requestDispatcher = req.getRequestDispatcher("register.jsp");
            requestDispatcher.include(req, resp);
        }
        else
        {
            RequestDispatcher requestDispatcher = req.getRequestDispatcher("register_success.jsp");
            requestDispatcher.forward(req, resp);
        }
    }
}