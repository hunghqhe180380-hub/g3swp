package model;

import java.time.LocalDateTime;
import java.util.List;

public class GradeAttemptVM {

    private int assignmentId;
    private String assignmentTitle;

    private int attemptId;
    private int classId;
    private int attemptNumber;

    private String studentId;
    private String studentName;
    private String studentEmail;

    private LocalDateTime startedAt;
    private LocalDateTime submittedAt;
    private String status;

    // MCQ
    private double mcqScore;
    private double mcqMax;

    // Essay
    private double essayMax;
    private Double currentEssayScore;

    // Final
    private double finalMax;
    private Double currentFinalScore;

    // Danh sách câu essay
    private List<GradeEssayItem> essays;

    // comment tổng
    private String teacherComment;

    private List<GradeMcqItem> mcqs;

    public List<GradeMcqItem> getMcqs() {
        return mcqs;
    }
    
    public void setMcqs(List<GradeMcqItem> mcqs) {
        this.mcqs = mcqs;
    }

    public GradeAttemptVM() {
    }

    // ===== Getter & Setter =====
    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public String getAssignmentTitle() {
        return assignmentTitle;
    }

    public void setAssignmentTitle(String assignmentTitle) {
        this.assignmentTitle = assignmentTitle;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getAttemptNumber() {
        return attemptNumber;
    }

    public void setAttemptNumber(int attemptNumber) {
        this.attemptNumber = attemptNumber;
    }

    public String getStudentId() {
        return studentId;
    }

    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }
    
    

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStudentEmail() {
        return studentEmail;
    }

    public void setStudentEmail(String studentEmail) {
        this.studentEmail = studentEmail;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getMcqScore() {
        return mcqScore;
    }

    public void setMcqScore(double mcqScore) {
        this.mcqScore = mcqScore;
    }

    public double getMcqMax() {
        return mcqMax;
    }

    public void setMcqMax(double mcqMax) {
        this.mcqMax = mcqMax;
    }

    public double getEssayMax() {
        return essayMax;
    }

    public void setEssayMax(double essayMax) {
        this.essayMax = essayMax;
    }

    public Double getCurrentEssayScore() {
        return currentEssayScore;
    }

    public void setCurrentEssayScore(Double currentEssayScore) {
        this.currentEssayScore = currentEssayScore;
    }

    public double getFinalMax() {
        return finalMax;
    }

    public void setFinalMax(double finalMax) {
        this.finalMax = finalMax;
    }

    public Double getCurrentFinalScore() {
        return currentFinalScore;
    }

    public void setCurrentFinalScore(Double currentFinalScore) {
        this.currentFinalScore = currentFinalScore;
    }

    public List<GradeEssayItem> getEssays() {
        return essays;
    }

    public void setEssays(List<GradeEssayItem> essays) {
        this.essays = essays;
    }

    public String getTeacherComment() {
        return teacherComment;
    }

    public void setTeacherComment(String teacherComment) {
        this.teacherComment = teacherComment;
    }

    @Override
    public String toString() {
        return "GradeAttemptVM{" + "assignmentId=" + assignmentId + ", assignmentTitle=" + assignmentTitle + ", attemptId=" + attemptId + ", attemptNumber=" + attemptNumber + ", studentId=" + studentId + ", studentName=" + studentName + ", studentEmail=" + studentEmail + ", startedAt=" + startedAt + ", submittedAt=" + submittedAt + ", status=" + status + ", mcqScore=" + mcqScore + ", mcqMax=" + mcqMax + ", essayMax=" + essayMax + ", currentEssayScore=" + currentEssayScore + ", finalMax=" + finalMax + ", currentFinalScore=" + currentFinalScore + ", essays=" + essays + ", teacherComment=" + teacherComment + ", mcqs=" + mcqs + '}';
    }
    
    
    
}
