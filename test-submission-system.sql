-- TEST SUBMISSION SYSTEM
-- Run this in Supabase SQL Editor to check if submissions table exists and works

-- Check if submissions table exists
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'submissions' 
ORDER BY ordinal_position;

-- Check if there are any existing submissions
SELECT COUNT(*) as total_submissions FROM submissions;

-- Check if there are any correct submissions
SELECT COUNT(*) as correct_submissions FROM submissions WHERE is_correct = true;

-- Check the structure of challenges table
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'challenges' 
ORDER BY ordinal_position;

-- Test query to see if we can join submissions with challenges
SELECT 
    c.title,
    c.id as challenge_id,
    COUNT(s.id) as total_attempts,
    COUNT(CASE WHEN s.is_correct THEN 1 END) as correct_attempts
FROM challenges c
LEFT JOIN submissions s ON c.id = s.challenge_id
GROUP BY c.id, c.title
ORDER BY c.title
LIMIT 10;