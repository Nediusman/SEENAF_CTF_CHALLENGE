-- DEBUG FLAG SUBMISSION SYSTEM
-- Run this in Supabase SQL Editor to diagnose submission issues

-- 1. Check if submissions table exists and structure
SELECT 'SUBMISSIONS TABLE STRUCTURE:' as info;
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'submissions' 
ORDER BY ordinal_position;

-- 2. Check RLS policies on submissions table
SELECT 'SUBMISSIONS RLS POLICIES:' as info;
SELECT 
    schemaname, 
    tablename, 
    policyname, 
    permissive, 
    roles, 
    cmd, 
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'submissions';

-- 3. Check if RLS is enabled
SELECT 'RLS STATUS:' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE tablename = 'submissions';

-- 4. Test basic insert (replace with real user_id and challenge_id)
SELECT 'TESTING BASIC INSERT:' as info;
-- First, get a real user ID and challenge ID
SELECT 'Available users:' as info, id, email FROM auth.users LIMIT 3;
SELECT 'Available challenges:' as info, id, title, flag FROM challenges LIMIT 3;

-- 5. Check if there are any existing submissions
SELECT 'EXISTING SUBMISSIONS:' as info;
SELECT 
    s.id,
    s.user_id,
    s.challenge_id,
    s.submitted_flag,
    s.is_correct,
    s.submitted_at,
    u.email as user_email,
    c.title as challenge_title
FROM submissions s
LEFT JOIN auth.users u ON s.user_id = u.id
LEFT JOIN challenges c ON s.challenge_id = c.id
ORDER BY s.submitted_at DESC
LIMIT 10;

-- 6. Test submission permissions for current user
SELECT 'CURRENT USER PERMISSIONS:' as info;
SELECT 
    auth.uid() as current_user_id,
    auth.role() as current_role;

-- 7. Check if profiles table exists and has data
SELECT 'PROFILES TABLE:' as info;
SELECT COUNT(*) as profile_count FROM profiles;
SELECT * FROM profiles LIMIT 5;

-- 8. Test a manual submission (REPLACE WITH REAL VALUES)
-- Uncomment and replace with actual IDs to test
/*
INSERT INTO submissions (user_id, challenge_id, submitted_flag, is_correct)
VALUES (
    'your-user-id-here',
    'your-challenge-id-here',
    'SEENAF{test_flag}',
    true
);
*/

-- 9. Check for any constraints that might be blocking submissions
SELECT 'SUBMISSION CONSTRAINTS:' as info;
SELECT 
    constraint_name,
    constraint_type,
    table_name
FROM information_schema.table_constraints 
WHERE table_name = 'submissions';

-- 10. Check for any triggers on submissions table
SELECT 'SUBMISSION TRIGGERS:' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'submissions';

-- 11. Test if user can read from submissions table
SELECT 'USER READ TEST:' as info;
SELECT COUNT(*) as readable_submissions 
FROM submissions 
WHERE user_id = auth.uid();

-- 12. Check challenge_likes table (used in the modal)
SELECT 'CHALLENGE_LIKES TABLE:' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_name = 'challenge_likes';

-- If challenge_likes doesn't exist, create it
CREATE TABLE IF NOT EXISTS challenge_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, challenge_id)
);

-- Enable RLS on challenge_likes
ALTER TABLE challenge_likes ENABLE ROW LEVEL SECURITY;

-- Create policies for challenge_likes
CREATE POLICY IF NOT EXISTS "Users can manage their own likes" ON challenge_likes
    FOR ALL USING (auth.uid() = user_id);

SELECT 'SETUP COMPLETE - Try submitting a flag now!' as status;