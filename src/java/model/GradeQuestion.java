/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author FPT
 */
public class GradeQuestion {
    private int id;
    private String prompt;
    private double points;
    private String type; // MCQ / Essay

    private List<Choice> choices;
    private List<Integer> selectedChoiceIds; // user chọn

    // getter setter

    public GradeQuestion() {
    }

    public GradeQuestion(int id, String prompt, double points, String type, List<Choice> choices, List<Integer> selectedChoiceIds) {
        this.id = id;
        this.prompt = prompt;
        this.points = points;
        this.type = type;
        this.choices = choices;
        this.selectedChoiceIds = selectedChoiceIds;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public List<Choice> getChoices() {
        return choices;
    }

    public void setChoices(List<Choice> choices) {
        this.choices = choices;
    }

    public List<Integer> getSelectedChoiceIds() {
        return selectedChoiceIds;
    }

    public void setSelectedChoiceIds(List<Integer> selectedChoiceIds) {
        this.selectedChoiceIds = selectedChoiceIds;
    }
    
    
}
