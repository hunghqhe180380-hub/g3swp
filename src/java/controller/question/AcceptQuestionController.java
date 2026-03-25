package controller.question;

import dal.QuestionBankDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.QuestionBank;
import util.PagingUtil;

public class AcceptQuestionController extends HttpServlet {

    private static final int NRPP = 10; // rows per page

    // ── GET: show list ────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        QuestionBankDAO dao = new QuestionBankDAO();

        // --- read filter/sort params ---
        String search = nvl(request.getParameter("search"));
        String status = nvl(request.getParameter("status"));
        String type   = nvl(request.getParameter("type"));
        String sort   = nvl(request.getParameter("sort"));
        String dir    = nvl(request.getParameter("dir"));
        int    index  = parseInt(request.getParameter("index"), 0);

        // default sort
        if (sort.isEmpty()) sort = "id";
        if (dir.isEmpty())  dir  = "desc";

        // --- fetch filtered list ---
        List<QuestionBank> allList = dao.getFilteredQuestions(search, status, type, sort, dir);

        // --- stats (always on full data) ---
        int[] stats = dao.getQuestionStats();  // [pending, approved, rejected]

        // --- paging ---
        PagingUtil page = new PagingUtil(allList.size(), NRPP, index);
        page.calc();

        // --- set attributes ---
        request.setAttribute("listSubject",  allList);   // JSP iterates listSubject
        request.setAttribute("listQuestion", allList);   // for total count fn:length
        request.setAttribute("page",         page);
        request.setAttribute("search",       search);
        request.setAttribute("status",       status);
        request.setAttribute("type",         type);
        request.setAttribute("sort",         sort);
        request.setAttribute("dir",          dir);
        request.setAttribute("statPending",  stats[2]);
        request.setAttribute("statApproved", stats[1]);
        request.setAttribute("statRejected", stats[0]);
        request.setAttribute("statTotal",    stats[0] + stats[1] + stats[2]);

        request.getRequestDispatcher("/view/question/accept_question.jsp")
               .forward(request, response);
    }

    // ── POST: approve / reject / bulk ─────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        QuestionBankDAO dao = new QuestionBankDAO();
        String action = nvl(request.getParameter("action"));

        if (action.equals("approve") || action.equals("reject")) {
            // single action
            int newStatus = "approve".equals(action) ? 1 : 0;
            String qid = request.getParameter("questionId");
            if (qid != null) dao.updateQuestionStatus(parseInt(qid, -1), newStatus);

        } else if (action.equals("bulk-approve") || action.equals("bulk-reject")) {
            // bulk: multiple questionIds[]
            int newStatus = "bulk-approve".equals(action) ? 1 : 0;
            String[] ids = request.getParameterValues("questionIds[]");
            if (ids != null) {
                for (String id : ids) {
                    dao.updateQuestionStatus(parseInt(id, -1), newStatus);
                }
            }
        }

        // preserve filters on redirect
        String search = nvl(request.getParameter("search"));
        String status = nvl(request.getParameter("filterStatus"));
        String type   = nvl(request.getParameter("filterType"));
        String sort   = nvl(request.getParameter("sort"));
        String dir    = nvl(request.getParameter("dir"));
        int    index  = parseInt(request.getParameter("index"), 0);

        StringBuilder redirect = new StringBuilder(
                request.getContextPath() + "/question/manage/accept-question?index=" + index);
        if (!search.isEmpty()) redirect.append("&search=").append(java.net.URLEncoder.encode(search, "UTF-8"));
        if (!status.isEmpty()) redirect.append("&status=").append(status);
        if (!type.isEmpty())   redirect.append("&type=").append(type);
        if (!sort.isEmpty())   redirect.append("&sort=").append(sort);
        if (!dir.isEmpty())    redirect.append("&dir=").append(dir);

        response.sendRedirect(redirect.toString());
    }

    // ── helpers ───────────────────────────────────────────────────────────────
    private String nvl(String s) { return s == null ? "" : s.trim(); }
    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}
