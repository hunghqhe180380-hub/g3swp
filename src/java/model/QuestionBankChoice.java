/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hung2
 */
public class QuestionBankChoice {

    private int id;
    private int questionBankId;
    private String text;
    private boolean isCorrect;
    private int order;

    public QuestionBankChoice() {
    }

    public QuestionBankChoice(int id, int questionBankId, String text, boolean isCorrect, int order) {
        this.id = id;
        this.questionBankId = questionBankId;
        this.text = text;
        this.isCorrect = isCorrect;
        this.order = order;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuestionBankId() {
        return questionBankId;
    }

    public void setQuestionBankId(int questionBankId) {
        this.questionBankId = questionBankId;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public boolean isIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }


}
