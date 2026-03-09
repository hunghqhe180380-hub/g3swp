/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hung2
 */
public class Subject {

    private String id;
    private String name;
    private int totalClass;
    private int totalTeacher;
    private int isActive;
    private String createAt;

    public Subject() {
    }

    public Subject(String id, String name, int totalClass, int totalTeacher, int isActive, String createAt) {
        this.id = id;
        this.name = name;
        this.totalClass = totalClass;
        this.totalTeacher = totalTeacher;
        this.isActive = isActive;
        this.createAt = createAt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getTotalClass() {
        return totalClass;
    }

    public void setTotalClass(int totalClass) {
        this.totalClass = totalClass;
    }

    public int getTotalTeacher() {
        return totalTeacher;
    }

    public void setTotalTeacher(int totalTeacher) {
        this.totalTeacher = totalTeacher;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    public String getCreateAt() {
        return createAt;
    }

    public void setCreateAt(String createAt) {
        this.createAt = createAt;
    }

   
}
