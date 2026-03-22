package model;

import java.time.LocalDateTime;

/**
 *
 * @author BINH
 */
public class Classroom {

    private int    id;
    private String name;
    private String classCode;
    private String subjectId;
    private String subjectName;
    private String teacherId;
    private String teacherName;
    private String createdAt;
    private int maxStudent;
    private int sum;
    private String timeExpiryClassCode;
    private int status;

    public Classroom() {}

    public Classroom(int id, String name, String classCode, String subjectId, String subjectName, String teacherId, String teacherName, String createdAt, int maxStudent, int sum, String timeExpiryClassCode) {
        this.id = id;
        this.name = name;
        this.classCode = classCode;
        this.subjectId = subjectId;
        this.subjectName = subjectName;
        this.teacherId = teacherId;
        this.teacherName = teacherName;
        this.createdAt = createdAt;
        this.maxStudent = maxStudent;
        this.sum = sum;
        this.timeExpiryClassCode = timeExpiryClassCode;
    }

    public int    getId()                    { return id; }
    public void   setId(int id)              { this.id = id; }

    public String getName()                  { return name; }
    public void   setName(String name)       { this.name = name; }

    public String getClassCode()             { return classCode; }
    public void   setClassCode(String c)     { this.classCode = c; }

    public String getSubject()               { return subject; }
    public void   setSubject(String s)       { this.subject = s; }

    public String getTeacherId()             { return teacherId; }
    public void   setTeacherId(String t)     { this.teacherId = t; }

    public String getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(String subjectId) {
        this.subjectId = subjectId;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public int    getMaxStudent()            { return maxStudent; }
    public void   setMaxStudent(int m)       { this.maxStudent = m; }


    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public int getSum() {
        return sum;
    }

    public void setSum(int sum) {
        this.sum = sum;
    }

    public String getTimeExpiryClassCode() {
        return timeExpiryClassCode;
    }

    public void setTimeExpiryClassCode(String timeExpiryClassCode) {
        this.timeExpiryClassCode = timeExpiryClassCode;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
