/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author BINH+Dung
 */
public class Classroom {

    private String id;
    private String name;        // class name
    private String classCode;
    private String subject;     // dùng như description
    private String teacherId;
    private LocalDateTime createdAt;
    private int maxStudent;

    public Classroom() {
    }

    public Classroom(String id, String name, String classCode, String subject,
                     String teacherId, LocalDateTime createdAt, int maxStudent) {
        this.id = id;
        this.name = name;
        this.classCode = classCode;
        this.subject = subject;
        this.teacherId = teacherId;
        this.createdAt = createdAt;
        this.maxStudent = maxStudent;
    }

    // ===== GET / SET CHUẨN =====

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

    public String getClassCode() {
        return classCode;
    }

    public void setClassCode(String classCode) {
        this.classCode = classCode;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(String teacherId) {
        this.teacherId = teacherId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getMaxStudent() {
        return maxStudent;
    }

    public void setMaxStudent(int maxStudent) {
        this.maxStudent = maxStudent;
    }

    // ===== ALIAS SETTER (ĐỂ KHỚP CONTROLLER CŨ) =====
    // ⚠️ KHÔNG thêm field mới, chỉ map lại

    // c.setClassName(className)
    public void setClassName(String className) {
        this.name = className;
    }

    // c.setDescription(description)
    public void setDescription(String description) {
        this.subject = description;
    }
}
