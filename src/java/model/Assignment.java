/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hung2
 */
public class Assignment {

    private int id;
    private String title;
    private String description;
    private int type;
    private int durationMinutes;
    private int maxAttempts;
    private int classId;
    private String openAt;
    private String closeAt;
    private String createdAt;
    private String createdById;

    public Assignment() {
    }

    public Assignment(int id, String title, String description, int type,
                      int durationMinutes, int maxAttempts, int classId,
                      String openAt, String closeAt, String createdAt, String createdById) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.type = type;
        this.durationMinutes = durationMinutes;
        this.maxAttempts = maxAttempts;
        this.classId = classId;
        this.openAt = openAt;
        this.closeAt = closeAt;
        this.createdAt = createdAt;
        this.createdById = createdById;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public int getMaxAttempts() {
        return maxAttempts;
    }

    public void setMaxAttempts(int maxAttempts) {
        this.maxAttempts = maxAttempts;
    }

    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }

    public String getOpenAt() {
        return openAt;
    }

    public void setOpenAt(String openAt) {
        this.openAt = openAt;
    }

    public String getCloseAt() {
        return closeAt;
    }

    public void setCloseAt(String closeAt) {
        this.closeAt = closeAt;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getCreatedById() {
        return createdById;
    }

    public void setCreatedById(String createdById) {
        this.createdById = createdById;
    }

    
}
