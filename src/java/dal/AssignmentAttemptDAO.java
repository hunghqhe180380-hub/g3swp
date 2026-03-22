/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.*;

/**
 *
 * @author hung2
 */
public class AssignmentAttemptDAO extends DBContext {

    PreparedStatement statement;
    ResultSet resultSet;

    public List<SubmissionListItem> getSubmissionList(String search, String statuses, String assignmentId) {
        List<SubmissionListItem> list = new ArrayList<>();
        try {
            // Main query to get attempts
            String sql = "SELECT "
                    + "at.Id AS AttemptId, "
                    + "at.AttemptNumber, "
                    + "at.UserId, "
                    + "u.FullName, "
                    + "u.Email, "
                    + "at.StartedAt, "
                    + "at.SubmittedAt, "
                    + "at.Status, "
                    + "at.RequiresManualGrading, "
                    + "at.AutoScore, "
                    + "at.FinalScore, "
                    + "at.MaxScore "
                    + "FROM AssignmentAttempts at "
                    + "JOIN Users u ON at.UserId = u.Id "
                    + "WHERE at.AssignmentId = ? ";

            if (search != null && !search.trim().isEmpty()) {
                sql += " AND (LOWER(u.FullName) LIKE ? OR LOWER(u.Email) LIKE ?) ";
            }
            if (statuses != null && !statuses.trim().isEmpty()) {
                String[] arr = statuses.split(",");
                StringBuilder sb = new StringBuilder(" AND at.Status IN (");
                for (int i = 0; i < arr.length; i++) {
                    sb.append("?");
                    if (i < arr.length - 1) sb.append(",");
                }
                sb.append(")");
                sql += sb;
            }
            sql += " ORDER BY at.SubmittedAt DESC, at.AttemptNumber DESC";

            statement = connection.prepareStatement(sql);
            statement.setInt(1, Integer.parseInt(assignmentId));
            int paramIndex = 2;
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.toLowerCase() + "%";
                statement.setObject(paramIndex++, pattern);
                statement.setObject(paramIndex++, pattern);
            }
            if (statuses != null && !statuses.trim().isEmpty()) {
                for (String s : statuses.split(",")) {
                    statement.setInt(paramIndex++, Integer.parseInt(s.trim()));
                }
            }
            resultSet = statement.executeQuery();

            // Read ALL rows from resultSet first, then call helper methods
            // (SQL Server doesn't support MARS - helper queries would close this resultSet)
            List<Object[]> rows = new ArrayList<>();
            while (resultSet.next()) {
                Object[] row = new Object[12];
                row[0] = resultSet.getInt("AttemptId");
                row[1] = resultSet.getInt("AttemptNumber");
                row[2] = resultSet.getString("UserId");
                row[3] = resultSet.getString("FullName");
                row[4] = resultSet.getString("Email");
                row[5] = resultSet.getTimestamp("StartedAt");
                row[6] = resultSet.getTimestamp("SubmittedAt");
                row[7] = resultSet.getInt("Status");
                row[8] = resultSet.getBoolean("RequiresManualGrading");
                // AutoScore - already calculated when student submitted
                double autoScore = resultSet.getDouble("AutoScore");
                row[9] = resultSet.wasNull() ? null : autoScore;
                // FinalScore
                double finalScore = resultSet.getDouble("FinalScore");
                row[10] = resultSet.wasNull() ? null : finalScore;
                // MaxScore from attempt (total max score for this attempt)
                double maxScore = resultSet.getDouble("MaxScore");
                row[11] = resultSet.wasNull() ? null : maxScore;
                rows.add(row);
            }
            resultSet.close();
            statement.close();

            int assignmentIdInt = Integer.parseInt(assignmentId);

            // Get MCQ Max and Essay Max once (same for all attempts of same assignment)
            double[] maxScores = getMCQAndEssayMax(assignmentIdInt);
            final double mcqMax = maxScores[0];
            final double essayMax = maxScores[1];

            for (Object[] row : rows) {
                int attemptId = (int) row[0];

                SubmissionListItem item = new SubmissionListItem();
                item.setAttemptId(attemptId);
                item.setAttemptNumber((int) row[1]);
                item.setStudentId((String) row[2]);
                item.setStudentName((String) row[3]);
                item.setStudentEmail((String) row[4]);

                java.sql.Timestamp startedTs = (java.sql.Timestamp) row[5];
                if (startedTs != null) {
                    item.setStartedAt(startedTs.toLocalDateTime());
                }
                java.sql.Timestamp submittedTs = (java.sql.Timestamp) row[6];
                if (submittedTs != null) {
                    item.setSubmittedAt(submittedTs.toLocalDateTime());
                }

                int statusInt = (int) row[7];
                switch (statusInt) {
                    case 1:
                        item.setStatus("InProgress");
                        break;
                    case 2:
                        item.setStatus("Submitted");
                        break;
                    case 3:
                        item.setStatus("Graded");
                        break;
                    case 4:
                        item.setStatus("Late");
                        break;
                    case 5:
                        item.setStatus("Violated");
                        break;
                    default:
                        item.setStatus("Unknown");
                }

                item.setRequiresManual((boolean) row[8]);

                // Use AutoScore from database (already calculated when student submitted)
                Double autoScore = (Double) row[9];
                Double finalScore = (Double) row[10];
                Double maxScore = (Double) row[11];

                // MCQ Score - use AutoScore from database
                // If AutoScore is available, use it; otherwise calculate from AssignmentAnswers
                double mcqScore;
                if (autoScore != null) {
                    mcqScore = autoScore;
                } else {
                    // Fallback: calculate from AssignmentAnswers
                    mcqScore = calculateMCQScore(attemptId, assignmentIdInt);
                }
                item.setMcqScore(mcqScore);
                item.setMcqMax(mcqMax);
                item.setMcqPercent(mcqMax > 0 ? (int) Math.round(mcqScore / mcqMax * 100) : 0);

                // Essay Score - calculate from AssignmentAnswers (IsCorrect = 1 AND Type = 2)
                double essayScore = calculateEssayScore(attemptId, assignmentIdInt);
                item.setEssayScore(essayScore > 0 ? essayScore : null);
                item.setEssayMax(essayMax);
                item.setEssayPercent(essayMax > 0 ? (int) Math.round(essayScore / essayMax * 100) : 0);

                // Final Score - use from database or calculate
                if (maxScore != null && maxScore > 0) {
                    item.setFinalMax(maxScore);
                } else {
                    item.setFinalMax(mcqMax + essayMax);
                }
                item.setFinalScore(finalScore);
                if (item.getFinalMax() > 0 && finalScore != null) {
                    item.setFinalPercent((int) Math.round(finalScore / item.getFinalMax() * 100));
                } else {
                    item.setFinalPercent(0);
                }

                list.add(item);
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get MCQ Max and Essay Max for an assignment (one query)
    private double[] getMCQAndEssayMax(int assignmentId) {
        double[] result = {0, 0}; // [mcqMax, essayMax]
        try {
            String sql = "SELECT "
                    + "ISNULL(SUM(CASE WHEN Type = 1 THEN Points ELSE 0 END), 0) AS MCQMax, "
                    + "ISNULL(SUM(CASE WHEN Type = 2 THEN Points ELSE 0 END), 0) AS EssayMax "
                    + "FROM AssignmentQuestions WHERE AssignmentId = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, assignmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result[0] = rs.getDouble("MCQMax");
                result[1] = rs.getDouble("EssayMax");
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // Fallback: calculate MCQ score from AssignmentAnswers
    private double calculateMCQScore(int attemptId, int assignmentId) {
        try {
            String sql = "SELECT ISNULL(SUM(q.Points), 0) AS MCQScore "
                    + "FROM AssignmentAnswers aa "
                    + "JOIN AssignmentQuestions q ON aa.QuestionId = q.Id "
                    + "WHERE aa.AttemptId = ? AND q.Type = 1 AND aa.IsCorrect = 1";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, attemptId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("MCQScore");
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Calculate Essay score from AssignmentAnswers
    private double calculateEssayScore(int attemptId, int assignmentId) {
        try {
            String sql = "SELECT ISNULL(SUM(q.Points), 0) AS EssayScore "
                    + "FROM AssignmentAnswers aa "
                    + "JOIN AssignmentQuestions q ON aa.QuestionId = q.Id "
                    + "WHERE aa.AttemptId = ? AND q.Type = 2 AND aa.IsCorrect = 1";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, attemptId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("EssayScore");
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Create a new attempt for a student taking an assignment
     *
     * @param status - 1=InProgress, 2=Submitted, 5=Violated
     */
    public int createAttempt(int assignmentId, String userId, int attemptNumber, int durationMinutes, int status) {
        try {
            String sql = "INSERT INTO AssignmentAttempts (AssignmentId, UserId, AttemptNumber, StartedAt, SubmittedAt, Status, DurationMinutes, MaxScore, RequiresManualGrading) "
                    + "VALUES (?, ?, ?, GETUTCDATE(), GETUTCDATE(), ?, ?, 0, 0)";

            statement = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            statement.setInt(1, assignmentId);
            statement.setString(2, userId);
            statement.setInt(3, attemptNumber);
            statement.setInt(4, status);
            statement.setInt(5, durationMinutes);
            statement.executeUpdate();

            ResultSet rs = statement.getGeneratedKeys();
            int attemptId = 0;
            if (rs.next()) {
                attemptId = rs.getInt(1);
            }
            rs.close();
            statement.close();
            return attemptId;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get attempt count for a user/assignment (to calculate next attempt
     * number)
     */
    public int getAttemptCount(int assignmentId, String userId) {
        try {
            String sql = "SELECT COUNT(*) AS cnt FROM AssignmentAttempts "
                    + "WHERE AssignmentId = ? AND UserId = ?";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, assignmentId);
            statement.setString(2, userId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                int cnt = resultSet.getInt("cnt");
                resultSet.close();
                statement.close();
                return cnt;
            }
            resultSet.close();
            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Update attempt with scores after submission
     */
    public void updateAttemptScores(int attemptId, double autoScore, double maxScore, boolean hasEssay, Double finalScore) {
        try {
            String sql = "UPDATE AssignmentAttempts SET "
                    + "AutoScore = ?, "
                    + "MaxScore = ?, "
                    + "RequiresManualGrading = ?, "
                    + "FinalScore = ? "
                    + "WHERE Id = ?";

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setDouble(1, autoScore);
            ps.setDouble(2, maxScore);
            ps.setBoolean(3, hasEssay);
            if (finalScore != null) {
                ps.setDouble(4, finalScore);
            } else {
                ps.setNull(4, java.sql.Types.DOUBLE);
            }
            ps.setInt(5, attemptId);
            ps.executeUpdate();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
