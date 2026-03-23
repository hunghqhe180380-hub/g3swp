package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class SubmissionListItem {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private int attemptId;
    private int attemptNumber;

    private String studentId;
    private String studentName;
    private String studentEmail;

    private LocalDateTime startedAt;
    private LocalDateTime submittedAt;

    private String status;

    /* SCQ (Single Choice Question) - Type 1 */
    private double scqScore;
    private double scqMax;
    private int scqPercent;

    /* MCQ (Multiple Choice Question) - Type 2 */
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

    // === SCQ (Type 1) ===
    public double getScqScore() {
        return scqScore;
    }

    public void setScqScore(double scqScore) {
        this.scqScore = scqScore;
    }

    public double getScqMax() {
        return scqMax;
    }

    public void setScqMax(double scqMax) {
        this.scqMax = scqMax;
    }

    public int getScqPercent() {
        return scqPercent;
    }

    public void setScqPercent(int scqPercent) {
        this.scqPercent = scqPercent;
    }

    // === MCQ (Type 2) ===
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

    // === Helper methods for JSP display ===

    public String getStartedAtStr() {
        return startedAt != null ? startedAt.format(DATE_FORMAT) : "—";
    }

    public String getSubmittedAtStr() {
        return submittedAt != null ? submittedAt.format(DATE_FORMAT) : "—";
    }

    // SCQ (Type 1)
    public String getScqScoreFmt() {
        return String.format("%.1f", scqScore);
    }

    public String getScqMaxFmt() {
        return String.format("%.1f", scqMax);
    }

    // MCQ (Type 2)
    public String getMcqScoreFmt() {
        return String.format("%.1f", mcqScore);
    }

    public String getMcqMaxFmt() {
        return String.format("%.1f", mcqMax);
    }

    // Essay (Type 3)
    public String getEssayScoreFmt() {
        return essayScore != null ? String.format("%.1f", essayScore) : "—";
    }

    public String getEssayMaxFmt() {
        return String.format("%.1f", essayMax);
    }

    public boolean isEssayScoreAvailable() {
        return essayScore != null;
    }

    // Final
    public String getFinalScoreFmt() {
        return finalScore != null ? String.format("%.1f", finalScore) : "—";
    }

    public String getFinalMaxFmt() {
        return String.format("%.1f", finalMax);
    }

    public boolean isFinalScoreAvailable() {
        return finalScore != null;
    }
}