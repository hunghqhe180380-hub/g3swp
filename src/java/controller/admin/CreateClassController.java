/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;
/**
 *
 * @author Dung
 */
import dal.ClassroomDAO;
import model.Classroom;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CreateClassController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // mở form tạo lớp (Teacher)
        request.getRequestDispatcher("Teacher/create-class.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // lấy dữ liệu từ form
        String className = request.getParameter("className");
        String description = request.getParameter("description");

        // tạo object
        Classroom c = new Classroom();
        c.setClassName(className);
        c.setDescription(description);

        // lưu DB
        ClassroomDAO dao = new ClassroomDAO();
        dao.insert(c);

        // quay về dashboard teacher
        response.sendRedirect("teacher/dashboard.jsp");
    }
}

