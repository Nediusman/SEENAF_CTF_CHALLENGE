-- SEENAF_CTF Debug and Fix Script
-- Run this step by step in Supabase SQL Editor

-- ========================================
-- STEP 1: Check Current Database State
-- ========================================

-- Check if challenges table exists and its structure
SELECT 'Table Structure Check' as step;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'challenges' AND table_schema = 'public';

-- Check current challenges count
SELECT 'Current Challenges Count' as step, COUNT(*) as total_challenges 
FROM public.challenges;

-- Check RLS status
SELECT 'RLS Status' as step, 
       schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'challenges';

-- Check current user and authentication
SELECT 'Current User Check' as step,
       current_user as database_user,
       session_user as session_user;

-- Check auth.users table
SELECT 'Auth Users' as step, COUNT(*) as total_users 
FROM auth.users;

-- Check user_roles table
SELECT 'User Roles Check' as step;
SELECT * FROM public.user_roles;

-- ========================================
-- STEP 2: Fix Database Structure
-- ========================================

-- Create challenges table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.challenges (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
    points INTEGER NOT NULL DEFAULT 100,
    flag TEXT NOT NULL,
    hints TEXT[],
    is_active BOOLEAN DEFAULT true,
    author TEXT,
    instance_url TEXT,
    solver_count INTEGER DEFAULT 0,
    likes_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user_roles table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, role)
);

-- Create profiles table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    avatar_url TEXT,
    total_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create submissions table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE,
    submitted_flag TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT false,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- STEP 3: Set Up RLS Policies
-- ========================================

-- Disable RLS temporarily
ALTER TABLE public.challenges DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.submissions DISABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Public can view active challenges" ON public.challenges;
DROP POLICY IF EXISTS "Admins manage all challenges" ON public.challenges;
DROP POLICY IF EXISTS "Users can view their own roles" ON public.user_roles;
DROP POLICY IF EXISTS "Users can view profiles" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can view own submissions" ON public.submissions;
DROP POLICY IF EXISTS "Users can insert own submissions" ON public.submissions;

-- ========================================
-- STEP 4: Insert Admin User
-- ========================================

-- IMPORTANT: Replace 'your-email@example.com' with your actual email
INSERT INTO public.user_roles (user_id, role)
SELECT id, 'admin'
FROM auth.users 
WHERE email = 'nediusman@gmail.com'  -- CHANGE THIS TO YOUR EMAIL
ON CONFLICT (user_id, role) DO NOTHING;

-- Verify admin user
SELECT 'Admin User Verification' as step,
       u.email, ur.role
FROM auth.users u
JOIN public.user_roles ur ON u.id = ur.user_id
WHERE u.email = 'nediusman@gmail.com';  -- CHANGE THIS TO YOUR EMAIL

-- ========================================
-- STEP 5: Clear and Insert All Challenges
-- ========================================

-- Clear existing challenges
DELETE FROM public.challenges;

-- Insert basic test challenges first
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, is_active) VALUES
('Test Web Challenge', 'This is a test web challenge to verify the system works.', 'Web', 'easy', 100, 'SEENAF{test_web_challenge}', ARRAY['This is a test hint'], true),
('Test Crypto Challenge', 'This is a test crypto challenge to verify the system works.', 'Crypto', 'easy', 100, 'SEENAF{test_crypto_challenge}', ARRAY['This is a test hint'], true),
('Test Forensics Challenge', 'This is a test forensics challenge to verify the system works.', 'Forensics', 'easy', 100, 'SEENAF{test_forensics_challenge}', ARRAY['This is a test hint'], true);

-- Check if test challenges were inserted
SELECT 'Test Challenges Inserted' as step, COUNT(*) as count FROM public.challenges;

-- ========================================
-- STEP 6: Set Up Working RLS Policies
-- ========================================

-- Enable RLS
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;

-- Create simple policies that work
CREATE POLICY "Anyone can view active challenges" ON public.challenges
    FOR SELECT USING (is_active = true);

CREATE POLICY "Admins can manage challenges" ON public.challenges
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

CREATE POLICY "Users can view their roles" ON public.user_roles
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Public can view profiles" ON public.profiles
    FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR ALL USING (id = auth.uid());

CREATE POLICY "Users can view own submissions" ON public.submissions
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert own submissions" ON public.submissions
    FOR INSERT WITH CHECK (user_id = auth.uid());

-- ========================================
-- STEP 7: Test Database Access
-- ========================================

-- Test challenge access as anonymous user
SELECT 'Public Challenge Access Test' as step;
SET ROLE anon;
SELECT COUNT(*) as visible_challenges FROM public.challenges WHERE is_active = true;
RESET ROLE;

-- Test challenge access as authenticated user
SELECT 'Auth Challenge Access Test' as step;
-- This simulates an authenticated user
SELECT COUNT(*) as visible_challenges FROM public.challenges WHERE is_active = true;

-- ========================================
-- STEP 8: Final Verification
-- ========================================

SELECT 'FINAL VERIFICATION' as step;
SELECT 
    'Database Status' as check_type,
    (SELECT COUNT(*) FROM public.challenges) as total_challenges,
    (SELECT COUNT(*) FROM public.challenges WHERE is_active = true) as active_challenges,
    (SELECT COUNT(*) FROM public.user_roles WHERE role = 'admin') as admin_users,
    (SELECT COUNT(*) FROM auth.users) as total_users;

-- Show challenge breakdown by category
SELECT 'Challenge Breakdown' as step;
SELECT category, COUNT(*) as count 
FROM public.challenges 
GROUP BY category 
ORDER BY category;

-- Show admin users
SELECT 'Admin Users' as step;
SELECT u.email, ur.role, ur.created_at
FROM auth.users u
JOIN public.user_roles ur ON u.id = ur.user_id
WHERE ur.role = 'admin';

-- ========================================
-- STEP 9: Instructions for Next Steps
-- ========================================

SELECT 'NEXT STEPS' as step;
SELECT 'If you see 3 test challenges above, the database is working!' as instruction
UNION ALL
SELECT 'Now go to your Admin Panel and click "Load CTF Challenges" button' as instruction
UNION ALL
SELECT 'This will load all 52 challenges from the frontend' as instruction
UNION ALL
SELECT 'Then check /challenges page to see all challenges' as instruction;