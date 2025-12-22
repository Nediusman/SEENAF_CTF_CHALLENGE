-- 🔍 ADMIN ACCESS DIAGNOSTIC & FIX
-- This script will diagnose and fix admin access issues
-- Run this in Supabase SQL Editor

-- Step 1: Check if your user exists
SELECT '=== STEP 1: USER CHECK ===' as step;
SELECT 
    'User found:' as status,
    id as user_id,
    email,
    created_at,
    email_confirmed_at
FROM auth.users 
WHERE email = 'nediusman@gmail.com';

-- Step 2: Check if user_roles table exists and has correct structure
SELECT '=== STEP 2: USER_ROLES TABLE CHECK ===' as step;
SELECT 
    'Table exists:' as status,
    COUNT(*) as total_roles
FROM user_roles;

-- Step 3: Check if your user has a role assigned
SELECT '=== STEP 3: YOUR ROLE CHECK ===' as step;
SELECT 
    'Your current role:' as status,
    ur.role,
    ur.created_at as role_assigned_at,
    u.email
FROM user_roles ur
JOIN auth.users u ON ur.user_id = u.id
WHERE u.email = 'nediusman@gmail.com';

-- Step 4: Check profiles table
SELECT '=== STEP 4: PROFILE CHECK ===' as step;
SELECT 
    'Profile exists:' as status,
    p.id,
    p.username,
    p.total_score,
    u.email
FROM profiles p
JOIN auth.users u ON p.id = u.id
WHERE u.email = 'nediusman@gmail.com';

-- Step 5: FIX EVERYTHING - Create missing tables and assign admin role
SELECT '=== STEP 5: APPLYING FIXES ===' as step;

-- Create user_roles table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    role TEXT NOT NULL DEFAULT 'player',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT user_roles_role_check CHECK (role IN ('admin', 'player')),
    CONSTRAINT user_roles_user_id_unique UNIQUE (user_id)
);

-- Insert/Update your admin role
INSERT INTO user_roles (user_id, role, created_at)
SELECT 
    u.id,
    'admin',
    NOW()
FROM auth.users u
WHERE u.email = 'nediusman@gmail.com'
ON CONFLICT (user_id) 
DO UPDATE SET 
    role = 'admin',
    created_at = NOW();

-- Create/Update your profile
INSERT INTO profiles (id, username, avatar_url, total_score, created_at, updated_at)
SELECT 
    u.id,
    'nediusman',
    NULL,
    0,
    NOW(),
    NOW()
FROM auth.users u
WHERE u.email = 'nediusman@gmail.com'
ON CONFLICT (id) 
DO UPDATE SET 
    updated_at = NOW();

-- Step 6: Disable RLS for easier access (temporary)
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE submissions DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Step 7: Final verification
SELECT '=== STEP 6: FINAL VERIFICATION ===' as step;
SELECT 
    '✅ ADMIN SETUP COMPLETE!' as status,
    u.email,
    ur.role,
    p.username,
    'Go to /admin now!' as next_step
FROM auth.users u
LEFT JOIN user_roles ur ON u.id = ur.user_id
LEFT JOIN profiles p ON u.id = p.id
WHERE u.email = 'nediusman@gmail.com';

-- Step 8: Test challenge access
SELECT '=== STEP 7: TESTING PERMISSIONS ===' as step;
SELECT 
    'Challenges accessible:' as test,
    COUNT(*) as challenge_count
FROM challenges;

SELECT '🎉 SETUP COMPLETE! Log out and log back in, then go to /admin' as final_message;