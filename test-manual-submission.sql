-- TEST MANUAL SUBMISSION
-- Run this to manually test if the submission system works

-- First, let's see what challenges exist
SELECT 'AVAILABLE CHALLENGES:' as info;
SELECT id, title, flag, points FROM challenges LIMIT 5;

-- Check if we have any users
SELECT 'AVAILABLE USERS:' as info;
SELECT id, email FROM auth.users LIMIT 3;

-- Let's try to manually insert a test submission
-- Replace the user_id and challenge_id with actual values from above
-- This is just a test - replace with real IDs

-- Example test submission (REPLACE WITH REAL IDs):
/*
INSERT INTO submissions (user_id, challenge_id, submitted_flag, is_correct)
VALUES (
    'your-user-id-here',
    'your-challenge-id-here', 
    'SEENAF{test_flag}',
    true
);
*/

-- After inserting, check if it worked:
SELECT 'TEST SUBMISSION RESULT:' as info;
SELECT 
    s.id,
    s.user_id,
    s.challenge_id,
    s.submitted_flag,
    s.is_correct,
    c.title as challenge_title,
    u.email as user_email
FROM submissions s
JOIN challenges c ON s.challenge_id = c.id
JOIN auth.users u ON s.user_id = u.id
ORDER BY s.submitted_at DESC
LIMIT 5;

-- Check if the query that the frontend uses works:
SELECT 'FRONTEND QUERY TEST:' as info;
SELECT challenge_id 
FROM submissions 
WHERE user_id = 'your-user-id-here' 
AND is_correct = true;