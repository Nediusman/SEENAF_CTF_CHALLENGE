-- Test admin permissions and database setup
-- Run this to check if admin functionality should work

-- 1. Check if user_roles table exists and has data
SELECT 'user_roles table check' as test;
SELECT * FROM user_roles LIMIT 5;

-- 2. Check if challenges table has is_active column
SELECT 'challenges table structure' as test;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'challenges' 
AND column_name IN ('id', 'is_active', 'title');

-- 3. Check current challenge active status
SELECT 'challenge active status' as test;
SELECT id, title, is_active, created_at 
FROM challenges 
ORDER BY created_at DESC 
LIMIT 10;

-- 4. Test update permissions (this should work for admins)
-- First, let's see what we can update
SELECT 'update test preparation' as test;
SELECT id, title, is_active 
FROM challenges 
WHERE title LIKE '%Base64%' OR title LIKE '%Caesar%'
LIMIT 1;

-- 5. Check RLS policies on challenges table
SELECT 'RLS policies check' as test;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies 
WHERE tablename = 'challenges';

-- 6. Check current user's role
SELECT 'current user role check' as test;
SELECT auth.uid() as current_user_id;

-- Try to find the current user in user_roles
SELECT ur.role, p.username, p.id
FROM user_roles ur
JOIN profiles p ON ur.user_id = p.id
WHERE ur.user_id = auth.uid();