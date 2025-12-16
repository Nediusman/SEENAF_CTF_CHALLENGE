-- FIND YOUR ACTUAL EMAIL AND SET ADMIN ROLE
-- Run each section separately

-- ========================================
-- STEP 1: Find all users in the system
-- ========================================
SELECT 'All users in system:' as info;
SELECT id, email, created_at FROM auth.users ORDER BY created_at DESC;

-- ========================================
-- STEP 2: Check if user_roles table exists and what's in it
-- ========================================
SELECT 'Current user_roles:' as info;
SELECT * FROM user_roles;

-- ========================================
-- STEP 3: Create user_roles table if needed
-- ========================================
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- ========================================
-- STEP 4: After seeing the users from STEP 1, replace 'YOUR_ACTUAL_EMAIL' 
-- with your real email from the list above
-- ========================================

-- First, let's try some common variations of your email:
SELECT 'Checking email variations:' as info;
SELECT id, email FROM auth.users WHERE email ILIKE '%nediusman%';
SELECT id, email FROM auth.users WHERE email ILIKE '%gmail%';

-- ========================================
-- STEP 5: Once you find your actual email, use it here
-- Replace 'YOUR_ACTUAL_EMAIL_HERE' with your real email
-- ========================================

-- Clear any existing role
DELETE FROM user_roles WHERE user_id IN (
    SELECT id FROM auth.users WHERE email = 'YOUR_ACTUAL_EMAIL_HERE'
);

-- Add admin role (replace email)
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'YOUR_ACTUAL_EMAIL_HERE';

-- ========================================
-- STEP 6: Verify the role was set
-- ========================================
SELECT 'Admin role verification:' as info;
SELECT ur.role, au.email, au.id
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id;

-- ========================================
-- STEP 7: Temporarily disable RLS for testing
-- ========================================
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- ========================================
-- STEP 8: Test challenge access
-- ========================================
SELECT 'Challenge access test:' as info;
SELECT COUNT(*) as total_challenges FROM challenges;
SELECT id, title, is_active FROM challenges LIMIT 3;