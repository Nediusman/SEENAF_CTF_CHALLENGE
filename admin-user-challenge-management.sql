-- ADMIN USER-CHALLENGE MANAGEMENT UTILITIES
-- Run these queries in Supabase SQL Editor for advanced user management

-- 1. View all user submissions with challenge details
SELECT 'USER SUBMISSIONS OVERVIEW:' as info;
SELECT 
    p.username,
    c.title as challenge_title,
    c.category,
    c.difficulty,
    c.points,
    s.is_correct,
    s.submitted_at
FROM submissions s
JOIN profiles p ON s.user_id = p.id
JOIN challenges c ON s.challenge_id = c.id
ORDER BY s.submitted_at DESC
LIMIT 20;

-- 2. View users with most solved challenges
SELECT 'TOP SOLVERS:' as info;
SELECT 
    p.username,
    COUNT(s.id) as total_submissions,
    COUNT(CASE WHEN s.is_correct THEN 1 END) as correct_submissions,
    p.total_score
FROM profiles p
LEFT JOIN submissions s ON p.id = s.user_id
GROUP BY p.id, p.username, p.total_score
ORDER BY correct_submissions DESC, p.total_score DESC
LIMIT 10;

-- 3. View challenge solve rates
SELECT 'CHALLENGE SOLVE RATES:' as info;
SELECT 
    c.title,
    c.category,
    c.difficulty,
    c.points,
    COUNT(s.id) as total_attempts,
    COUNT(CASE WHEN s.is_correct THEN 1 END) as correct_solves,
    ROUND(
        (COUNT(CASE WHEN s.is_correct THEN 1 END)::float / NULLIF(COUNT(s.id), 0)) * 100, 
        2
    ) as solve_rate_percent
FROM challenges c
LEFT JOIN submissions s ON c.id = s.challenge_id
GROUP BY c.id, c.title, c.category, c.difficulty, c.points
ORDER BY solve_rate_percent DESC NULLS LAST;

-- 4. Find users who solved specific challenge (replace challenge title)
SELECT 'USERS WHO SOLVED SPECIFIC CHALLENGE:' as info;
SELECT 
    p.username,
    s.submitted_at,
    s.submitted_flag
FROM submissions s
JOIN profiles p ON s.user_id = p.id
JOIN challenges c ON s.challenge_id = c.id
WHERE c.title = 'Basic XSS' -- Replace with actual challenge title
AND s.is_correct = true
ORDER BY s.submitted_at;

-- 5. Remove specific user from specific challenge (ADMIN ONLY)
-- EXAMPLE: Remove user from challenge (REPLACE WITH ACTUAL IDs)
/*
DELETE FROM submissions 
WHERE user_id = 'user-uuid-here' 
AND challenge_id = 'challenge-uuid-here';

-- Then recalculate their score
UPDATE profiles 
SET total_score = (
    SELECT COALESCE(SUM(c.points), 0)
    FROM submissions s
    JOIN challenges c ON s.challenge_id = c.id
    WHERE s.user_id = 'user-uuid-here' 
    AND s.is_correct = true
)
WHERE id = 'user-uuid-here';
*/

-- 6. Remove user from ALL challenges (ADMIN ONLY)
-- EXAMPLE: Remove all submissions for a user (REPLACE WITH ACTUAL ID)
/*
DELETE FROM submissions WHERE user_id = 'user-uuid-here';
UPDATE profiles SET total_score = 0 WHERE id = 'user-uuid-here';
*/

-- 7. View duplicate submissions (users who submitted same challenge multiple times)
SELECT 'DUPLICATE SUBMISSIONS:' as info;
SELECT 
    p.username,
    c.title,
    COUNT(s.id) as submission_count,
    MAX(s.submitted_at) as last_submission
FROM submissions s
JOIN profiles p ON s.user_id = p.id
JOIN challenges c ON s.challenge_id = c.id
GROUP BY p.username, c.title, s.user_id, s.challenge_id
HAVING COUNT(s.id) > 1
ORDER BY submission_count DESC;

-- 8. Reset all user scores (ADMIN ONLY - USE WITH CAUTION)
-- Uncomment to reset all scores
/*
UPDATE profiles SET total_score = (
    SELECT COALESCE(SUM(c.points), 0)
    FROM submissions s
    JOIN challenges c ON s.challenge_id = c.id
    WHERE s.user_id = profiles.id 
    AND s.is_correct = true
);
*/

-- 9. View users with no submissions
SELECT 'USERS WITH NO SUBMISSIONS:' as info;
SELECT 
    p.username,
    p.created_at,
    p.total_score
FROM profiles p
LEFT JOIN submissions s ON p.id = s.user_id
WHERE s.id IS NULL
ORDER BY p.created_at DESC;

-- 10. View challenge statistics
SELECT 'CHALLENGE STATISTICS:' as info;
SELECT 
    category,
    COUNT(*) as total_challenges,
    COUNT(CASE WHEN is_active THEN 1 END) as active_challenges,
    AVG(points) as avg_points
FROM challenges
GROUP BY category
ORDER BY total_challenges DESC;