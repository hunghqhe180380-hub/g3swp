package controller.question;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author tuana
 */
import dal.QuestionBankChoiceDAO;
import dal.QuestionBankDAO;
import dal.SubjectDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.Subject;
import model.User;
import java.util.List;
import model.QuestionBank;
import model.QuestionBankChoice;
import model.QuestionGroup;

@MultipartConfig( //fileSizeThreshold = 1024 * 1024,   // 1MB (buffer)
        //maxFileSize = 1024 * 1024 * 10,    // 10MB / file
        //maxRequestSize = 1024 * 1024 * 50  // 50MB / request
        )
public class AddQuestionPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //get subject of this teacher
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        SubjectDAO subjectDAO = new SubjectDAO();
        List<Subject> listSubject = subjectDAO.getListSubjectOfTeacher(user.getUserID());
        //get subject'name by it's id
        for (int i = 0; i < listSubject.size(); i++) {
            listSubject.get(i).setName(subjectDAO.getSubjectNameById(listSubject.get(i).getId()));
        }

        //get question bank
        QuestionBankDAO qBankDAO = new QuestionBankDAO();
        List<QuestionBank> listQuestion = qBankDAO.getListQuestionBankByTeacherId(user.getUserID(), "Pending");

        //get subject'name of each question in question bank
        for (int i = 0; i < listQuestion.size(); i++) {
            listQuestion.get(i).setSubjectName(subjectDAO.getSubjectNameById(listQuestion.get(i).getSubjectId()));
        }

        //test
        for (int i = 0; i < listQuestion.size(); i++) {
            listQuestion.get(i).getListQuestionBankChoice();
        }

        request.setAttribute("listQuestion", listQuestion);
        request.setAttribute("listSubject", listSubject);
        //get chapter of subject
        //get question bank of this teacher
        request.getRequestDispatcher("/view/question/add-question.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String subjectId = request.getParameter("subject");
        String chapter = request.getParameter("chapter");
        String questionType = request.getParameter("questionType");

        QuestionBankDAO qBankDAO = new QuestionBankDAO();
        QuestionBankChoiceDAO qBankChoiceDAO = new QuestionBankChoiceDAO();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        //get propmt of question
        String[] prompts = request.getParameterValues("prompt[]");

        for (int i = 0; i < prompts.length; i++) {
            QuestionBank qBank = new QuestionBank();
            int qIndex = i + 1;

            String prompt = prompts[i];

            String[] choice = request.getParameterValues("option_" + qIndex + "[]");
            String[] corrects = request.getParameterValues("correct_" + qIndex);
//create question in question bank            
            qBank.setSubjectId(subjectId);
            qBank.setType(Integer.parseInt(questionType));
            qBank.setChapter(Integer.parseInt(chapter));
            qBank.setPrompt(prompt);
            int newQuestionBank = qBankDAO.insertQuestion(qBank, user.getUserID());

            /*
                *create list question bank choice
             */
            for (int j = 0; j < choice.length; j++) {
//  Data gửi lên có dạng như này:
//               prompt[] = ["Q1", "Q2"]
//            option_1[] = ["A", "B", "C"]
//            correct_1 = ["1"]        (SCQ)
//
//            option_2[] = ["X", "Y", "Z"]
//            correct_2 = ["0", "2"]   (MCQ)
                QuestionBankChoice qBankChoice = new QuestionBankChoice();
                qBankChoice.setQuestionBankId(newQuestionBank);
                //set text
                qBankChoice.setText(choice[j]);
                qBankChoice.setOrder(j);
                boolean isCorrect = false;

                if (corrects != null) {
                    for (String c : corrects) {
                        if (Integer.parseInt(c) == j) {
                            isCorrect = true;
                            break;
                        }
                    }
                }
                //set is correct
                 qBankChoice.setIsCorrect(isCorrect);
                //add choice into questionbankchoice
                qBankChoiceDAO.insertQuestion(qBankChoice);
                //System.out.println("Option " + j + ": " + choice[j] + " | Correct: " + isCorrect);
            }
        }
        doGet(request, response);
    }
}
