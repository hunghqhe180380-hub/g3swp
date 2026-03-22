package controller.classroom;

import dal.ClassroomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import model.Classroom;
import model.User;
import util.PagingUtil;

@WebServlet(name = "ClassListController", urlPatterns = {"/classroom/manage/class-list"})
public class ClassListController extends HttpServlet {

    private ClassroomDAO dao;

    @Override
    public void init() {
        dao = new ClassroomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String search = request.getParameter("search");
        HttpSession ses = request.getSession();
        User user = (User) ses.getAttribute("user");
        if(!user.getRole().equalsIgnoreCase("Admin")){
            response.sendRedirect(request.getContextPath() + "/account/dashboard");
            return;
        }
        List<Classroom> classes = dao.getAllClassBySearch(search);
        sort(request, classes);
        paging(request, classes);

        request.setAttribute("search",  search);
        request.setAttribute("classes", classes);
        request.getRequestDispatcher("/view/classroom/list-classroom.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void sort(HttpServletRequest request, List<Classroom> classes)
            throws ServletException, IOException {
        int clState = 0;
        int teState = 0;
        int tiState = 0;        
        try {
            clState = Integer.parseInt(request.getParameter("txtClassName"));
            teState = Integer.parseInt(request.getParameter("txtTeacherName"));
            tiState = Integer.parseInt(request.getParameter("txtCreateAt"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (clState != 0) {
            Comparator<Classroom> cmp =
                Comparator.comparing(Classroom::getName, String.CASE_INSENSITIVE_ORDER);
            Collections.sort(classes, clState == 2 ? cmp.reversed() : cmp);

        } else if (teState != 0) {
            Comparator<Classroom> cmp =
                Comparator.comparing(Classroom::getTeacherName, String.CASE_INSENSITIVE_ORDER);
            Collections.sort(classes, teState == 2 ? cmp.reversed() : cmp);

        } else if (tiState != 0) {
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            Comparator<Classroom> cmp = (c1, c2) ->
                LocalDateTime.parse(c1.getCreatedAt(), fmt)
                             .compareTo(LocalDateTime.parse(c2.getCreatedAt(), fmt));
            Collections.sort(classes, tiState == 2 ? cmp.reversed() : cmp);
        }
    }

    private void paging(HttpServletRequest request, List<Classroom> classes)
            throws ServletException, IOException {
        int nrpp = Integer.parseInt(request.getServletContext().getInitParameter("paging.class"));
        int size = classes.size();        
        int index = 0;
        try {
            index = Integer.parseInt(request.getParameter("index"));
            index = index < 0 ? 0 : index;
        } catch (Exception e) {
            index = 0;
        }
        PagingUtil page = new PagingUtil(size, nrpp, index);
        page.calc();

        request.setAttribute("page", page);
        request.setAttribute("nrpp", nrpp);
    }

    private static int parseIntSafe(String val, int fallback) {
        if (val == null) return fallback;
        try { return Integer.parseInt(val.trim()); }
        catch (NumberFormatException e) { return fallback; }
    }
}
