/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author FPT
 */
import java.util.List;

public class GradeMCQQuestion {
    private int questionId;
    private String questionText;
    private double points;

    private List<GradeMCQChoice> choices;

    // getters setters

    public GradeMCQQuestion() {
    }

    public GradeMCQQuestion(int questionId, String questionText, double points, List<GradeMCQChoice> choices) {
        this.questionId = questionId;
        this.questionText = questionText;
        this.points = points;
        this.choices = choices;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public double getPoints() {
        return points;
    }

    public void setPoints(double points) {
        this.points = points;
    }

    public List<GradeMCQChoice> getChoices() {
        return choices;
    }

    public void setChoices(List<GradeMCQChoice> choices) {
        this.choices = choices;
    }
    
    
}
