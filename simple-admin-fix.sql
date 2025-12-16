-- Simple admin fix without ON CONFLICT
-- Run this step by step in your Supabase SQL editor

-- Step 1: Check if user_roles table exists
SELECT 'Checking user_roles table' as step;
SELECT table_name FROM information_schema.tables WHERE table_name = 'user_roles';

-- Step 2: Create user_roles table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 3: Add unique constraint on user_id
ALTER TABLE user_roles ADD CONSTRAINT user_roles_user_id_unique UNIQUE (user_id);

-- Step 4: Find your user ID
SELECT 'Finding your user ID' as step;
SELECT id, email FROM auth.users WHERE email = 'nediusman@gmail.com';

-- Step 5: Delete any existing role for your user (to avoid duplicates)
DELETE FROM user_roles WHERE user_id IN (
    SELECT id FROM auth.users WHERE email = 'nediusman@gmail.com'
);

-- Step 6: Insert admin role for your user
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com';

-- Step 7: Verify the role was set
SELECT 'Verifying admin role' as step;
SELECT ur.role, au.email, au.id
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
WHERE au.email = 'nediusman@gmail.com';

-- Step 8: Check current RLS policies on challenges
SELECT 'Current RLS policies' as step;
SELECT schemaname, tablename, policyname, permissive, cmd
FROM pg_policies 
WHERE tablename = 'challenges';

-- Step 9: Temporarily disable RLS for testing (ONLY FOR DEBUGGING)
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- Step 10: Test basic challenge operations
SELECT 'Testing challenge access' as step;
SELECT COUNT(*) as total_challenges FROM challenges;
SELECT id, title, is_active FROM challenges LIMIT 3;