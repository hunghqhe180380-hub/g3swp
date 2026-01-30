/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author hung2
 */
public class User {
    private String urlImgProfile;
    private String userID;
    private String role;
    private String userName;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String password;
    private String accountCode;
    private int emailConfirm;

    public User() {
    }

    public User(String userID, String role) {
        this.userID = userID;
        this.role = role;
    }

    public User(String userID, String role, String fullName, int emailConfirm) {
        this.userID = userID;
        this.role = role;
        this.fullName = fullName;
        this.emailConfirm = emailConfirm;
    }

    public User(String userName, String fullName, String email) {
        this.userName = userName;
        this.fullName = fullName;
        this.email = email;
    }
    

    
    //constructor all info

    public User(String urlImgProfile, String userID, String role, String userName, String fullName, String email, String phoneNumber, String password, String accountCode, int emailConfirm) {
        this.urlImgProfile = urlImgProfile;
        this.userID = userID;
        this.role = role;
        this.userName = userName;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.accountCode = accountCode;
        this.emailConfirm = emailConfirm;
    }
    

    
    
    //constructor to create new account
    public User(String userID, String userName, String fullName, String email, String phoneNumber, String password, String accountCode) {
        this.userID = userID;
        this.userName = userName;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.accountCode = accountCode;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAccountCode() {
        return accountCode;
    }

    public void setAccountCode(String accountCode) {
        this.accountCode = accountCode;
    }

    public int getEmailConfirm() {
        return emailConfirm;
    }

    public void setEmailConfirm(int emailConfirm) {
        this.emailConfirm = emailConfirm;
    }

    public String getUrlImgProfile() {
        return urlImgProfile;
    }

    public void setUrlImgProfile(String urlImgProfile) {
        this.urlImgProfile = urlImgProfile;
    }
    
    
    
}
