/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hung2
 */
public class AssignmentAttempt {

    private int id;
    private int assignmentId;
    private String userId;
    private int attemptNumber;
    private String startedAt;
    private String submittedAt;
    private int status;
    private double autoScore;
    private double finalScore;
    private double maxScore;
    private String assignmentTitle;

    public String getAssignmentTitle() {
        return assignmentTitle;
    }

    public void setAssignmentTitle(String assignmentTitle) {
        this.assignmentTitle = assignmentTitle;
    }

    public AssignmentAttempt() {
    }

    public AssignmentAttempt(int id, int assignmentId, String userId, int attemptNumber, String startedAt, String submittedAt, int status, double autoScore, double finalScore, double maxScore) {
        this.id = id;
        this.assignmentId = assignmentId;
        this.userId = userId;
        this.attemptNumber = attemptNumber;
        this.startedAt = startedAt;
        this.submittedAt = submittedAt;
        this.status = status;
        this.autoScore = autoScore;
        this.finalScore = finalScore;
        this.maxScore = maxScore;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getAttemptNumber() {
        return attemptNumber;
    }

    public void setAttemptNumber(int attemptNumber) {
        this.attemptNumber = attemptNumber;
    }

    public String getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(String startedAt) {
        this.startedAt = startedAt;
    }

    public String getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(String submittedAt) {
        this.submittedAt = submittedAt;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public double getAutoScore() {
        return autoScore;
    }

    public void setAutoScore(double autoScore) {
        this.autoScore = autoScore;
    }

    public double getFinalScore() {
        return finalScore;
    }

    public void setFinalScore(double finalScore) {
        this.finalScore = finalScore;
    }

    public double getMaxScore() {
        return maxScore;
    }

    public void setMaxScore(double maxScore) {
        this.maxScore = maxScore;
    }

}
