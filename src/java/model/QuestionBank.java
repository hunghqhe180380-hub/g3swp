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
    private int chapter;
    private String createdById;
    private String createdAt;
    private String subjectName;
    private int status;
    private List<QuestionBankChoice> listQuestionBankChoice;
    /*
    (settingPoint) --- this variable use to set point to this question when use random question
     */
    private double settingPoint;

    public QuestionBank() {
    }

    public QuestionBank(int id, String subjectId, int type, String prompt, int chapter, String createdById, String createdAt, int status, List<QuestionBankChoice> listQuestionBankChoice) {
        this.id = id;
        this.subjectId = subjectId;
        this.type = type;
        this.prompt = prompt;
        this.chapter = chapter;
        this.createdById = createdById;
        this.createdAt = createdAt;
        this.status = status;
        this.listQuestionBankChoice = listQuestionBankChoice;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
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

    public int getChapter() {
        return chapter;
    }

    public void setChapter(int chapter) {
        this.chapter = chapter;
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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
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

    @Override
    public String toString() {
        return "subjectId: " + subjectId + " " + "type: " + type + " " + "prompt: " + prompt + " " + "chapter: " + chapter + " " + "createdById: " + createdById + " " + "status: " + status + " " + "settingPoint: " + settingPoint;
    }

    
}
