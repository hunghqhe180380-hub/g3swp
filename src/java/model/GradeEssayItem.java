package model;

public class GradeEssayItem {

    private int questionId;
    private String prompt;
    private double maxPoints;

    private String studentAnswer;

    private Double score;      // điểm giáo viên nhập
    private String comment;    // comment giáo viên

    // ===== Constructor =====
    public GradeEssayItem() {
    }

    // ===== Getter & Setter =====

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getPrompt() {
        return prompt;
    }

    public void setPrompt(String prompt) {
        this.prompt = prompt;
    }

    public double getMaxPoints() {
        return maxPoints;
    }

    public void setMaxPoints(double maxPoints) {
        this.maxPoints = maxPoints;
    }

    public String getStudentAnswer() {
        return studentAnswer;
    }

    public void setStudentAnswer(String studentAnswer) {
        this.studentAnswer = studentAnswer;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    // ===== Helper cho JSP (giống C# ViewModel) =====

    public boolean isScored() {
        return score != null;
    }

    public String getScoreFormatted() {
        if (score == null) return "—";
        return String.format("%.2f", score);
    }

    public String getMaxPointsFormatted() {
        return String.format("%.2f", maxPoints);
    }
}