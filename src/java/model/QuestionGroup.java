/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hung2
 */
public class QuestionGroup {
    private int type;
    private int level;
    private int numberQuestion;
    private double pointPerQuestion;

    public QuestionGroup() {
    }

    public QuestionGroup(int type, int level, int numberQuestion, double pointPerQuestion) {
        this.type = type;
        this.level = level;
        this.numberQuestion = numberQuestion;
        this.pointPerQuestion = pointPerQuestion;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public int getNumberQuestion() {
        return numberQuestion;
    }

    public void setNumberQuestion(int numberQuestion) {
        this.numberQuestion = numberQuestion;
    }

    public double getPointPerQuestion() {
        return pointPerQuestion;
    }

    public void setPointPerQuestion(double pointPerQuestion) {
        this.pointPerQuestion = pointPerQuestion;
    }

    
    @Override
    public String toString() {
        return "Type: " + type + "Level: " + level + "numberQuestion: " +numberQuestion +  "pointPerQuestion" + pointPerQuestion;
    }

    
    
    
}
