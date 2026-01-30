package model;

public class Classroom {

    private String id;
    private String name;        // class name
    private String classCode;
    private String subject;     // dùng như description
    private String teacherId;
    private String teacherName;
    private String createdAt;   // đã format sẵn từ DAO
    private int maxStudent;
    private int sumOfStudent;

    public Classroom() {
    }

    public Classroom(String id, String name, String classCode, String subject,
                     String teacherId, String teacherName,
                     String createdAt, int maxStudent, int sumOfStudent) {
        this.id = id;
        this.name = name;
        this.classCode = classCode;
        this.subject = subject;
        this.teacherId = teacherId;
        this.teacherName = teacherName;
        this.createdAt = createdAt;
        this.maxStudent = maxStudent;
        this.sumOfStudent = sumOfStudent;
    }

    // ===== GET / SET =====

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

    public int getMaxStudent() {
        return maxStudent;
    }

    public void setMaxStudent(int maxStudent) {
        this.maxStudent = maxStudent;
    }

    public int getSumOfStudent() {
        return sumOfStudent;
    }

    public void setSumOfStudent(int sumOfStudent) {
        this.sumOfStudent = sumOfStudent;
    }

    // ===== ALIAS SETTER (GIỮ CONTROLLER CŨ KHÔNG BỊ GÃY) =====

    // c.setClassName(...)
    public void setClassName(String className) {
        this.name = className;
    }

    // c.setDescription(...)
    public void setDescription(String description) {
        this.subject = description;
    }
}
