package model;

import dal.ReviewChoiceDTO;
import java.util.List;

public class ReviewQuestionDTO {
    public int questionId;
    public String prompt;
    public String type; // "MCQ" hoặc "Essay"
    public double points;
    public List<ReviewChoiceDTO> choices; // Chỉ dành cho MCQ
    
    // Dành cho Essay hoặc thông tin bổ sung
    public String essayText;      // Nội dung sinh viên viết
    public Double essayScore;     // Điểm giáo viên chấm cho câu này
    public String teacherComment; // Nhận xét cho riêng câu này

    public ReviewQuestionDTO() {
    }

    public ReviewQuestionDTO(int questionId, String prompt, String type, double points, List<ReviewChoiceDTO> choices, String essayText, Double essayScore, String teacherComment) {
        this.questionId = questionId;
        this.prompt = prompt;
        this.type = type;
        this.points = points;
        this.choices = choices;
        this.essayText = essayText;
        this.essayScore = essayScore;
        this.teacherComment = teacherComment;
    }

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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getPoints() {
        return points;
    }

    public void setPoints(double points) {
        this.points = points;
    }

    public List<ReviewChoiceDTO> getChoices() {
        return choices;
    }

    public void setChoices(List<ReviewChoiceDTO> choices) {
        this.choices = choices;
    }

    public String getEssayText() {
        return essayText;
    }

    public void setEssayText(String essayText) {
        this.essayText = essayText;
    }

    public Double getEssayScore() {
        return essayScore;
    }

    public void setEssayScore(Double essayScore) {
        this.essayScore = essayScore;
    }

    public String getTeacherComment() {
        return teacherComment;
    }

    public void setTeacherComment(String teacherComment) {
        this.teacherComment = teacherComment;
    }
    
    
}
