-- Check database status and challenges
-- Run this in your Supabase SQL Editor

-- 1. Check if challenges table exists
SELECT 'Checking challenges table...' as status;
SELECT table_name FROM information_schema.tables WHERE table_name = 'challenges';

-- 2. Count total challenges
SELECT 'Total challenges:' as info, COUNT(*) as count FROM challenges;

-- 3. Count active challenges
SELECT 'Active challenges:' as info, COUNT(*) as count FROM challenges WHERE is_active = true;

-- 4. Show sample challenges
SELECT 'Sample challenges:' as info;
SELECT id, title, category, difficulty, is_active FROM challenges LIMIT 5;

-- 5. Check RLS status
SELECT 'RLS Status:' as info;
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'challenges' 
AND schemaname = 'public';

-- 6. Check if user_roles table exists
SELECT 'User roles table:' as info;
SELECT table_name FROM information_schema.tables WHERE table_name = 'user_roles';

-- 7. Check current user permissions
SELECT 'Current user:' as info, current_user;

-- 8. Test basic select permission
SELECT 'Testing select permission...' as test;
SELECT COUNT(*) as accessible_challenges FROM challenges;