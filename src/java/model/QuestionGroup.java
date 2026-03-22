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
    private int chapter;
    private int numberQuestion;
    private double pointPerQuestion;

    public QuestionGroup() {
    }

    public QuestionGroup(int type, int chapter, int numberQuestion, double pointPerQuestion) {
        this.type = type;
        this.chapter = chapter;
        this.numberQuestion = numberQuestion;
        this.pointPerQuestion = pointPerQuestion;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getChapter() {
        return chapter;
    }

    public void setChapter(int chapter) {
        this.chapter = chapter;
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
        return "Type: " + type + "chapter: " + chapter + "numberQuestion: " +numberQuestion +  "pointPerQuestion" + pointPerQuestion;
    }

    
    
    
}
