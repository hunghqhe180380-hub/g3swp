/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hung2
 */
public class AssignmentAnswer {

    private int id;
    private int attemptId;
    private int questionId;
    private Integer selectedChoiceId;
    private String textAnswer;
    private Boolean isCorrect;
    private double pointsAwarded;

    public AssignmentAnswer() {
    }

    public AssignmentAnswer(int id, int attemptId, int questionId, Integer selectedChoiceId, String textAnswer, Boolean isCorrect, double pointsAwarded) {
        this.id = id;
        this.attemptId = attemptId;
        this.questionId = questionId;
        this.selectedChoiceId = selectedChoiceId;
        this.textAnswer = textAnswer;
        this.isCorrect = isCorrect;
        this.pointsAwarded = pointsAwarded;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public Integer getSelectedChoiceId() {
        return selectedChoiceId;
    }

    public void setSelectedChoiceId(Integer selectedChoiceId) {
        this.selectedChoiceId = selectedChoiceId;
    }

    public String getTextAnswer() {
        return textAnswer;
    }

    public void setTextAnswer(String textAnswer) {
        this.textAnswer = textAnswer;
    }

    public Boolean getIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(Boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public double getPointsAwarded() {
        return pointsAwarded;
    }

    public void setPointsAwarded(double pointsAwarded) {
        this.pointsAwarded = pointsAwarded;
    }
    
    

}
