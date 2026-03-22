/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.classroom;

import controller.teacher.CreateClassController;
import dal.ClassroomDAO;
import dal.SubjectDAO;
import dal.TeacherDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Classroom;
import model.Subject;
import model.User;

/**
 *
 * @author BINH
 */
public class EditClassController extends HttpServlet {

    private ClassroomDAO dao;

    public void init() {
        dao = new ClassroomDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditClassController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditClassController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("classId");
        //get class's info by class's id
        Classroom classes = dao.getClassInfoByClassId(classId);
        //get list subject from database
        SubjectDAO subjectDAO = new SubjectDAO();
        //get subject's name by id
        String subjectName = subjectDAO.getSubjectNameById(classes.getSubjectId());
        List<Subject> listSubject = subjectDAO.getListSubject();
        //get total student joined this class
        request.setAttribute("totalStudent", classes.getSum());
        request.setAttribute("subjectName", subjectName);
        request.setAttribute("subjectId", classes.getSubjectId());
        request.setAttribute("listSubject", listSubject);
        request.setAttribute("classroom", classes);
        request.getRequestDispatcher("/view/classroom/edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String classId = request.getParameter("classId");
        String className = request.getParameter("name");
        String subjectId = request.getParameter("subjectId");
        String maxStudents = request.getParameter("maxStudents");
        String studentJoined = request.getParameter("studentJoined");
        System.out.println("classId" + classId);
        System.out.println("className" + className);
        System.out.println("subjectId" + subjectId);
        System.out.println("maxStudents" + maxStudents);
        System.out.println("studentJoined" + studentJoined);
        //get teacher's id
        HttpSession session = request.getSession();
        User teacher = (User) session.getAttribute("user");

        //get information of this class in database by class's id
        ClassroomDAO clsDAO = new ClassroomDAO();
        Classroom cls = clsDAO.getClassInfoByClassId(classId);
        SubjectDAO subjectDAO = new SubjectDAO();

        //validation input 
        Map<String, String> listMSG = validInput(className, teacher, maxStudents, cls.getSum(), subjectId);

        //if pass validateion
        if (listMSG.size() == 0) {
            //check class's name, subject and max student are changed?
            if (!cls.getName().equals(className) || !cls.getSubjectId().equals(subjectId)) {
                //if class's name or subject are change => have to check exist
                TeacherDAO teacherDAO = new TeacherDAO();
                if (teacherDAO.isExistClass(teacher.getUserID(), className, subjectId)) {
                    //if class is exist => not allow to update
                    listMSG.put("msgNotifyError", "{Class: " + className + "*Subject: " + subjectDAO.getSubjectNameById(subjectId).trim() + "} is Exist!");
                } else {
                    //if class is not exist => allow to update name, subject, maxstudent
                    Classroom newClassroom = new Classroom();
                    newClassroom.setId(cls.getId());
                    newClassroom.setName(className);
                    newClassroom.setSubjectId(subjectId);
                    newClassroom.setMaxStudent(Integer.parseInt(maxStudents));
                    newClassroom.setSum(Integer.parseInt(studentJoined));
                    //update
                    clsDAO.updateClassroom(newClassroom);
                    request.setAttribute("classroom", newClassroom);
                    listMSG.put("msgNotifySuccess", "Updated.");
                }
            } else {
                //if only max student is changed => only update max student
                if (cls.getName().equals(className)
                        && cls.getSubjectId().equals(subjectId)
                        && cls.getMaxStudent() != Integer.parseInt(maxStudents)) {
                    updateClass(dao, cls, className, subjectId, maxStudents, studentJoined);
                    listMSG.put("msgNotifySuccess", "Max Student is updated.");
                } else {
                    if (cls.getName().equals(className)
                            && cls.getSubjectId().equals(subjectId)
                            && cls.getMaxStudent() == Integer.parseInt(maxStudents)) {
                        listMSG.put("msgNotify", "!!!Nothing Changed!!!");
                    }
                }
            }

        }
        Classroom newClassroom = new Classroom();
        newClassroom.setId(cls.getId());
        newClassroom.setName(className);
        newClassroom.setSubjectId(subjectId);
        newClassroom.setMaxStudent(Integer.parseInt(maxStudents));
        newClassroom.setSum(Integer.parseInt(studentJoined));
        request.setAttribute("classroom", newClassroom);
        request.setAttribute("subjectId", subjectId);
        request.setAttribute("subjectName", subjectDAO.getSubjectNameById(subjectId));
        request.setAttribute("totalStudent", studentJoined);
        request.setAttribute("listSubject", subjectDAO.getListSubject());

        request.setAttribute("listMSG", listMSG);
        request.getRequestDispatcher("/view/classroom/edit.jsp").forward(request, response);
    }

    private void updateClass(ClassroomDAO dao, Classroom cls, String name,
            String subjectId, String maxStudents, String studentJoined) {

        Classroom newClassroom = new Classroom();
        newClassroom.setId(cls.getId());
        newClassroom.setName(name);
        newClassroom.setSubjectId(subjectId);
        newClassroom.setMaxStudent(Integer.parseInt(maxStudents));
        newClassroom.setSum(Integer.parseInt(studentJoined));

        dao.updateClassroom(newClassroom);
    }

    private Map<String, String> validClassName(String className) {
        Map<String, String> listMSG = new HashMap<>();
        if (className.trim().isEmpty()) {
            listMSG.put("msgClassName", message.Message.MSG301);
        }
        if (className.length() > 30) {
            listMSG.put("msgClassName", message.Message.MSG315);
        }
        return listMSG;
    }

    private Map<String, String> validInput(String className,
            User teacher,
            String maxStudent,
            int studentJoined,
            String subjectId) {
        Map<String, String> listMSG = new HashMap<>();
        if (className.trim().isEmpty()) {
            listMSG.put("msgClassName", message.Message.MSG301);
        }
        if (className.length() > 30) {
            listMSG.put("msgClassName", message.Message.MSG315);
        }
        //Max Students must be integer number and >= studentJoined && <= 100 && > 0
        for (int i = 0; i < maxStudent.length(); i++) {
            if (maxStudent.charAt(i) < '0' || maxStudent.charAt(i) > '9') {
                listMSG.put("msgMaxStudent", message.Message.MSG600);
            }
        }

        if (Integer.parseInt(maxStudent) <= 0 || Integer.parseInt(maxStudent) > 100) {
            listMSG.put("msgMaxStudent", message.Message.MSG304);
        } else {
            if (Integer.parseInt(maxStudent) < studentJoined || Integer.parseInt(maxStudent) > 100) {
                listMSG.put("msgMaxStudent", message.Message.MSG600);
            }
        }
        return listMSG;
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
