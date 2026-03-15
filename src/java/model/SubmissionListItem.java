package model;

import java.time.LocalDateTime;

public class SubmissionListItem {

    private int attemptId;
    private int attemptNumber;

    private String studentId;
    private String studentName;
    private String studentEmail;

    private LocalDateTime startedAt;
    private LocalDateTime submittedAt;

    private String status;

    /* MCQ */
    private double mcqScore;
    private double mcqMax;
    private int mcqPercent;

    /* ESSAY */
    private Double essayScore;
    private double essayMax;
    private int essayPercent;

    /* FINAL */
    private Double finalScore;
    private double finalMax;
    private int finalPercent;

    private boolean requiresManual;

    public SubmissionListItem() {
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

    public int getMcqPercent() {
        return mcqPercent;
    }

    public void setMcqPercent(int mcqPercent) {
        this.mcqPercent = mcqPercent;
    }

    public Double getEssayScore() {
        return essayScore;
    }

    public void setEssayScore(Double essayScore) {
        this.essayScore = essayScore;
    }

    public double getEssayMax() {
        return essayMax;
    }

    public void setEssayMax(double essayMax) {
        this.essayMax = essayMax;
    }

    public int getEssayPercent() {
        return essayPercent;
    }

    public void setEssayPercent(int essayPercent) {
        this.essayPercent = essayPercent;
    }

    public Double getFinalScore() {
        return finalScore;
    }

    public void setFinalScore(Double finalScore) {
        this.finalScore = finalScore;
    }

    public double getFinalMax() {
        return finalMax;
    }

    public void setFinalMax(double finalMax) {
        this.finalMax = finalMax;
    }

    public int getFinalPercent() {
        return finalPercent;
    }

    public void setFinalPercent(int finalPercent) {
        this.finalPercent = finalPercent;
    }

    public boolean isRequiresManual() {
        return requiresManual;
    }

    public void setRequiresManual(boolean requiresManual) {
        this.requiresManual = requiresManual;
    }
}