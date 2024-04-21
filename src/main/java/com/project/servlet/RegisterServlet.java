package com.project.servlet;

import com.project.database.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class register
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
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