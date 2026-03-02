package controller.classroom;

import dal.ClassroomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import model.Classroom;
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

        List<Classroom> classes = dao.getAllClassBySearch(search);
        sort(request, classes);
        paging(request, classes);

        request.setAttribute("search",  search);
        request.setAttribute("classes", classes);

        request.getRequestDispatcher("/View/classroom/list-admin.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Sort in-memory by clicked column; state: 0=none, 1=ASC, 2=DESC
    private void sort(HttpServletRequest request, List<Classroom> classes) {
        int clState = parseIntSafe(request.getParameter("txtClassName"),   0);
        int teState = parseIntSafe(request.getParameter("txtTeacherName"), 0);
        int tiState = parseIntSafe(request.getParameter("txtCreateAt"),    0);

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

    // Build PagingUtil from list size + nrpp context param + current page index
    private void paging(HttpServletRequest request, List<Classroom> classes) {
        int nrpp  = parseIntSafe(request.getServletContext().getInitParameter("nrpp"), 10);
        int index = Math.max(parseIntSafe(request.getParameter("index"), 0), 0);

        PagingUtil page = new PagingUtil(classes.size(), nrpp, index);
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
