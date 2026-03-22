/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author FPT
 */
public class GradeMCQChoice {
    private int choiceId;
    private String content;
    private boolean isCorrect;     // đáp án đúng
    private boolean isSelected;    // học sinh chọn
    
    private String cssClass; // Thêm dòng này

    // Thêm Getter và Setter cho cssClass
    public String getCssClass() {
        return cssClass;
    }

    public void setCssClass(String cssClass) {
        this.cssClass = cssClass;
    }

    // getters setters

    public GradeMCQChoice() {
    }

    public GradeMCQChoice(int choiceId, String content, boolean isCorrect, boolean isSelected) {
        this.choiceId = choiceId;
        this.content = content;
        this.isCorrect = isCorrect;
        this.isSelected = isSelected;
    }

    public int getChoiceId() {
        return choiceId;
    }

    public void setChoiceId(int choiceId) {
        this.choiceId = choiceId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public boolean isIsSelected() {
        return isSelected;
    }

    public void setIsSelected(boolean isSelected) {
        this.isSelected = isSelected;
    }
    
    
}
