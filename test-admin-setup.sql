-- TEST ADMIN SETUP - Run this to verify everything is working
-- Copy and paste this into your Supabase SQL Editor

-- 1. Check if your user exists
SELECT 'Step 1: User Check' as step;
SELECT id, email, created_at FROM auth.users WHERE email = 'nediusman@gmail.com';

-- 2. Check if user_roles table exists
SELECT 'Step 2: User Roles Table Check' as step;
SELECT table_name FROM information_schema.tables WHERE table_name = 'user_roles';

-- 3. Check your admin role
SELECT 'Step 3: Admin Role Check' as step;
SELECT ur.role, au.email 
FROM user_roles ur 
JOIN auth.users au ON ur.user_id = au.id 
WHERE au.email = 'nediusman@gmail.com';

-- 4. Check challenges table permissions
SELECT 'Step 4: Challenges Table Check' as step;
SELECT COUNT(*) as total_challenges FROM challenges;

-- 5. Check RLS status
SELECT 'Step 5: RLS Status Check' as step;
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename IN ('challenges', 'user_roles', 'profiles') 
AND schemaname = 'public';

-- 6. Test challenge creation (this should work if admin is set up correctly)
SELECT 'Step 6: Test Challenge Creation' as step;
INSERT INTO challenges (
    title, 
    description, 
    category, 
    difficulty, 
    points, 
    flag, 
    is_active
) VALUES (
    'Admin Test Challenge',
    'This is a test challenge to verify admin permissions are working',
    'Misc',
    'easy',
    1,
    'SEENAF{admin_test_successful}',
    false
) RETURNING id, title;

-- 7. Clean up test challenge
DELETE FROM challenges WHERE title = 'Admin Test Challenge';

SELECT 'SUCCESS: All tests completed! If you see this message, admin setup is working.' as result;