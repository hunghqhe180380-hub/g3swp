/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author BINH
 */
public class Enrollment {

    private int id;
    private int classId;
    private String userId;
    private String roleInClass;
    private String joinedAt;
    private int status;
    private User user;

    public Enrollment() {
    }

    public Enrollment(int id, int classId, String userId, String roleInClass, String joinedAt, int status, User user) {
        this.id = id;
        this.classId = classId;
        this.userId = userId;
        this.roleInClass = roleInClass;
        this.joinedAt = joinedAt;
        this.status = status;
        this.user = user;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRoleInClass() {
        return roleInClass;
    }

    public void setRoleInClass(String roleInClass) {
        this.roleInClass = roleInClass;
    }

    public String getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(String joinedAt) {
        this.joinedAt = joinedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

}
