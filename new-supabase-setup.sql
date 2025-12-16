-- SEENAF_CTF Setup for New Supabase Project
-- Run this in your NEW Supabase SQL Editor: https://fsyspwfjubhxpcuqivne.supabase.co

-- ========================================
-- STEP 1: Create All Required Tables
-- ========================================

-- Create challenges table
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

-- Create user_roles table
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, role)
);

-- Create profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    avatar_url TEXT,
    total_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create submissions table
CREATE TABLE IF NOT EXISTS public.submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE,
    submitted_flag TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT false,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- STEP 2: Set Up Your Admin Role 
-- ========================================

-- IMPORTANT: Replace with your actual email address
INSERT INTO public.user_roles (user_id, role)
SELECT id, 'admin'
FROM auth.users 
WHERE email = 'nediusman@gmail.com'  -- CHANGE THIS TO YOUR EMAIL
ON CONFLICT (user_id, role) DO NOTHING;

-- Verify admin role
SELECT 'Admin Setup Check' as step,
       u.email, ur.role
FROM auth.users u
JOIN public.user_roles ur ON u.id = ur.user_id
WHERE u.email = 'nediusman@gmail.com';  -- CHANGE THIS TO YOUR EMAIL

-- ========================================
-- STEP 3: Set Up RLS Policies
-- ========================================

-- Enable RLS on all tables
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;

-- Drop existing policies (if any)
DROP POLICY IF EXISTS "Anyone can view active challenges" ON public.challenges;
DROP POLICY IF EXISTS "Admins can manage challenges" ON public.challenges;
DROP POLICY IF EXISTS "Users can view their roles" ON public.user_roles;
DROP POLICY IF EXISTS "Public can view profiles" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can view own submissions" ON public.submissions;
DROP POLICY IF EXISTS "Users can insert own submissions" ON public.submissions;

-- Create working RLS policies
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
-- STEP 4: Insert Test Challenges
-- ========================================

-- Insert 5 test challenges to verify everything works
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, is_active) VALUES
('Test Web Challenge', 'This is a test web challenge to verify the system works. Find the flag in the HTML source code.', 'Web', 'easy', 100, 'SEENAF{test_web_works}', ARRAY['Check the HTML source', 'Look for hidden comments'], true),
('Test Crypto Challenge', 'Decode this simple cipher: FRRANS{grfg_pelcgb_jbexf}', 'Crypto', 'easy', 100, 'SEENAF{test_crypto_works}', ARRAY['This is ROT13 cipher', 'Try an online ROT13 decoder'], true),
('Test Forensics Challenge', 'Analyze this file to find the hidden flag.', 'Forensics', 'easy', 100, 'SEENAF{test_forensics_works}', ARRAY['Use strings command', 'Look for hidden data'], true),
('Test Network Challenge', 'Find the flag in this network capture.', 'Network', 'easy', 100, 'SEENAF{test_network_works}', ARRAY['Use Wireshark', 'Look for HTTP traffic'], true),
('Test Reverse Challenge', 'Reverse engineer this binary to find the password.', 'Reverse', 'easy', 100, 'SEENAF{test_reverse_works}', ARRAY['Use strings command first', 'Try a disassembler'], true);

-- ========================================
-- STEP 5: Verify Everything Works
-- ========================================

-- Check table creation
SELECT 'Tables Created' as step,
       COUNT(*) as challenge_count
FROM public.challenges;

-- Check admin role
SELECT 'Admin Role' as step,
       COUNT(*) as admin_count
FROM public.user_roles 
WHERE role = 'admin';

-- Test public access (this simulates what your frontend will see)
SELECT 'Public Access Test' as step,
       COUNT(*) as visible_challenges
FROM public.challenges 
WHERE is_active = true;

-- Show challenge breakdown
SELECT 'Challenge Categories' as step;
SELECT category, COUNT(*) as count 
FROM public.challenges 
GROUP BY category 
ORDER BY category;

-- Final success message
SELECT 'SETUP COMPLETE!' as step,
       'Your SEENAF_CTF database is ready!' as message,
       'Now restart your frontend dev server and check the admin panel.' as next_step;