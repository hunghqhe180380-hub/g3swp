package model;

import java.util.List;

public class GradeMcqItem {

    private int questionId;
    private String prompt;
    private double points;

    // danh sách đáp án
    private List<McqChoice> choices;

    public GradeMcqItem() {
    }

    // ===== Getter & Setter =====

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getPrompt() {
        return prompt;
    }

    public void setPrompt(String prompt) {
        this.prompt = prompt;
    }

    public double getPoints() {
        return points;
    }

    public void setPoints(double points) {
        this.points = points;
    }

    public List<McqChoice> getChoices() {
        return choices;
    }

    public void setChoices(List<McqChoice> choices) {
        this.choices = choices;
    }

    @Override
    public String toString() {
        return "GradeMcqItem{" + "questionId=" + questionId + ", prompt=" + prompt + ", points=" + points + ", choices=" + choices + '}';
    }
    
    
}