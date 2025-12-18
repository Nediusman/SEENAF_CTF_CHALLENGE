-- DEBUG SOLVED CHALLENGES ISSUE
-- Run this in Supabase SQL Editor to diagnose the problem

-- 1. Check if submissions table exists and has correct structure
SELECT 'SUBMISSIONS TABLE STRUCTURE:' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'submissions' 
ORDER BY ordinal_position;

-- 2. Check if challenges table exists and has correct structure  
SELECT 'CHALLENGES TABLE STRUCTURE:' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'challenges' 
ORDER BY ordinal_position;

-- 3. Check if there are any submissions at all
SELECT 'TOTAL SUBMISSIONS:' as info, COUNT(*) as count FROM submissions;

-- 4. Check if there are any correct submissions
SELECT 'CORRECT SUBMISSIONS:' as info, COUNT(*) as count FROM submissions WHERE is_correct = true;

-- 5. Show sample submissions if any exist
SELECT 'SAMPLE SUBMISSIONS:' as info;
SELECT 
    s.id,
    s.user_id,
    s.challenge_id,
    s.submitted_flag,
    s.is_correct,
    s.submitted_at,
    c.title as challenge_title
FROM submissions s
LEFT JOIN challenges c ON s.challenge_id = c.id
ORDER BY s.submitted_at DESC
LIMIT 5;

-- 6. Check for any users in auth.users
SELECT 'TOTAL USERS:' as info, COUNT(*) as count FROM auth.users;

-- 7. Check if profiles table exists
SELECT 'PROFILES TABLE EXISTS:' as info;
SELECT COUNT(*) as count FROM information_schema.tables WHERE table_name = 'profiles';

-- 8. Test a simple challenge-submission join
SELECT 'CHALLENGE-SUBMISSION JOIN TEST:' as info;
SELECT 
    c.id as challenge_id,
    c.title,
    COUNT(s.id) as submission_count,
    COUNT(CASE WHEN s.is_correct THEN 1 END) as correct_count
FROM challenges c
LEFT JOIN submissions s ON c.id = s.challenge_id
GROUP BY c.id, c.title
HAVING COUNT(s.id) > 0
ORDER BY submission_count DESC
LIMIT 10;

-- 9. Check RLS policies on submissions table
SELECT 'SUBMISSIONS RLS POLICIES:' as info;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'submissions';

-- 10. Check if there are any constraint issues
SELECT 'SUBMISSIONS CONSTRAINTS:' as info;
SELECT constraint_name, constraint_type 
FROM information_schema.table_constraints 
WHERE table_name = 'submissions';