/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author hung2
 */
public class QuestionBank {

    private int id;
    private String subjectId;
    private int type;
    private String prompt;
    private int level;
    private String createdById;
    private String createdAt;
    private int isPublic;
    private List<QuestionBankChoice> listQuestionBankChoice;
    /*
    (settingPoint) --- this variable use to set point to this question when use random question
     */
    private double settingPoint;

    public QuestionBank() {
    }

    public QuestionBank(int id, String subjectId, int type, String prompt, int level, String createdById, String createdAt, int isPublic, List<QuestionBankChoice> listQuestionBankChoice) {
        this.id = id;
        this.subjectId = subjectId;
        this.type = type;
        this.prompt = prompt;
        this.level = level;
        this.createdById = createdById;
        this.createdAt = createdAt;
        this.isPublic = isPublic;
        this.listQuestionBankChoice = listQuestionBankChoice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(String subjectId) {
        this.subjectId = subjectId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getPrompt() {
        return prompt;
    }

    public void setPrompt(String prompt) {
        this.prompt = prompt;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getCreatedById() {
        return createdById;
    }

    public void setCreatedById(String createdById) {
        this.createdById = createdById;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public int getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(int isPublic) {
        this.isPublic = isPublic;
    }

    public List<QuestionBankChoice> getListQuestionBankChoice() {
        return listQuestionBankChoice;
    }

    public void setListQuestionBankChoice(List<QuestionBankChoice> listQuestionBankChoice) {
        this.listQuestionBankChoice = listQuestionBankChoice;
    }

    public double getSettingPoint() {
        return settingPoint;
    }

    public void setSettingPoint(double settingPoint) {
        this.settingPoint = settingPoint;
    }

}
