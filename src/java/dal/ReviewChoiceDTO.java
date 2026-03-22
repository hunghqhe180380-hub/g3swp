/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author FPT
 */
public class ReviewChoiceDTO {

    public int choiceId;

    public String text;

    public boolean isCorrect;

    public boolean isChosen;

    public ReviewChoiceDTO() {
    }

    public ReviewChoiceDTO(int choiceId, String text, boolean isCorrect, boolean isChosen) {
        this.choiceId = choiceId;
        this.text = text;
        this.isCorrect = isCorrect;
        this.isChosen = isChosen;
    }

    public int getChoiceId() {
        return choiceId;
    }

    public void setChoiceId(int choiceId) {
        this.choiceId = choiceId;
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

    public boolean isIsChosen() {
        return isChosen;
    }

    public void setIsChosen(boolean isChosen) {
        this.isChosen = isChosen;
    }
    
    
    

}
