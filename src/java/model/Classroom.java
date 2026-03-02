package model;

public class Classroom {

    private int    id;
    private String name;
    private String classCode;
    private String subject;
    private String teacherId;
    private String teacherName; // joined from Users
    private String createdAt;   // formatted "dd/MM/yyyy HH:mm"
    private int    maxStudent;
    private int    sum;          // enrollment count

    public Classroom() {}

    public Classroom(String name, String subject, int sum) {
        this.name    = name;
        this.subject = subject;
        this.sum     = sum;
    }

    public Classroom(int id, String name, String classCode, String subject,
                     String teacherId, String teacherName,
                     String createdAt, int maxStudent, int sum) {
        this.id          = id;
        this.name        = name;
        this.classCode   = classCode;
        this.subject     = subject;
        this.teacherId   = teacherId;
        this.teacherName = teacherName;
        this.createdAt   = createdAt;
        this.maxStudent  = maxStudent;
        this.sum         = sum;
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

    public String getTeacherName()           { return teacherName; }
    public void   setTeacherName(String t)   { this.teacherName = t; }

    public String getCreatedAt()             { return createdAt; }
    public void   setCreatedAt(String c)     { this.createdAt = c; }

    public int    getMaxStudent()            { return maxStudent; }
    public void   setMaxStudent(int m)       { this.maxStudent = m; }

    public int    getSum()                   { return sum; }
    public void   setSum(int sum)            { this.sum = sum; }
}
