/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

public class AssignmentQuestion {

    private int id;
    private int assignmentId;
    private String type;
    private String prompt;
    private double points;
    private int order;
    private int chapter;
    private String createdAt;
    private List<AssignmentChoice> listAssignmentChoice;

    public AssignmentQuestion() {
    }

    public AssignmentQuestion(int id, int assignmentId, String type, String prompt, double points, int order, int chapter, String createdAt, List<AssignmentChoice> listAssignmentChoice) {
        this.id = id;
        this.assignmentId = assignmentId;
        this.type = type;
        this.prompt = prompt;
        this.points = points;
        this.order = order;
        this.chapter = chapter;
        this.createdAt = createdAt;
        this.listAssignmentChoice = listAssignmentChoice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public int getChapter() {
        return chapter;
    }

    public void setChapter(int chapter) {
        this.chapter = chapter;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

  

    public List<AssignmentChoice> getListAssignmentChoice() {
        return listAssignmentChoice;
    }

    public void setListAssignmentChoice(List<AssignmentChoice> listAssignmentChoice) {
        this.listAssignmentChoice = listAssignmentChoice;
    }

    
   
}
