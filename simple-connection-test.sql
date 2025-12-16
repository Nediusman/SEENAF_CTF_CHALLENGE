-- Simple Connection Test for SEENAF_CTF
-- Run this in Supabase SQL Editor to verify everything works

-- Step 1: Check if you can connect to the database
SELECT 'Database Connection Test' as test, NOW() as current_time;

-- Step 2: Check if challenges table exists
SELECT 'Table Check' as test, 
       COUNT(*) as total_challenges 
FROM public.challenges;

-- Step 3: Check if you have admin role
SELECT 'Admin Check' as test,
       u.email,
       ur.role
FROM auth.users u
LEFT JOIN public.user_roles ur ON u.id = ur.user_id
WHERE u.email = 'nediusman@gmail.com';  -- CHANGE TO YOUR EMAIL

-- Step 4: Insert a simple test challenge
INSERT INTO public.challenges (
    title, 
    description, 
    category, 
    difficulty, 
    points, 
    flag, 
    hints, 
    is_active
) VALUES (
    'Connection Test', 
    'This is a test challenge to verify the database connection works.', 
    'Misc', 
    'easy', 
    50, 
    'SEENAF{connection_test_works}', 
    ARRAY['This is just a test challenge'], 
    true
) ON CONFLICT (title) DO NOTHING;

-- Step 5: Verify the test challenge was inserted
SELECT 'Test Challenge Check' as test,
       title,
       category,
       points,
       is_active
FROM public.challenges 
WHERE title = 'Connection Test';

-- Step 6: Test RLS policies by trying to select as public
SET ROLE anon;
SELECT 'Public Access Test' as test,
       COUNT(*) as visible_challenges
FROM public.challenges 
WHERE is_active = true;
RESET ROLE;

-- Final result
SELECT 'FINAL RESULT' as test,
       'If you see this message, your database connection is working!' as message;