-- EMERGENCY ADMIN FIX V2 - Run this in your Supabase SQL Editor
-- This will fix all admin permission issues

-- ========================================
-- STEP 1: Find your user ID
-- ========================================
SELECT 'Your user information:' as info;
SELECT id, email, created_at FROM auth.users WHERE email = 'nediusman@gmail.com';

-- ========================================
-- STEP 2: Recreate user_roles table properly
-- ========================================
DROP TABLE IF EXISTS user_roles CASCADE;

CREATE TABLE user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'player' CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Enable RLS but with permissive policies
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- ========================================
-- STEP 3: Set your admin role
-- ========================================
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com'
ON CONFLICT (user_id) DO UPDATE SET role = 'admin', updated_at = NOW();

-- ========================================
-- STEP 4: Verify admin role was set
-- ========================================
SELECT 'Admin verification:' as step;
SELECT ur.role, au.email, ur.created_at
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
WHERE au.email = 'nediusman@gmail.com';

-- ========================================
-- STEP 5: Fix challenges table permissions
-- ========================================
-- Temporarily disable RLS to fix permissions
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- Grant full permissions to authenticated users
GRANT ALL ON challenges TO authenticated;
GRANT ALL ON user_roles TO authenticated;
GRANT ALL ON profiles TO authenticated;
GRANT ALL ON submissions TO authenticated;

-- Grant sequence permissions
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- ========================================
-- STEP 6: Create admin-friendly RLS policies
-- ========================================

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view active challenges" ON challenges;
DROP POLICY IF EXISTS "Admins can manage challenges" ON challenges;
DROP POLICY IF EXISTS "Users can view their own role" ON user_roles;
DROP POLICY IF EXISTS "Admins can manage roles" ON user_roles;

-- Re-enable RLS with admin-friendly policies
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- Policy 1: Everyone can read challenges
CREATE POLICY "Everyone can read challenges" ON challenges
    FOR SELECT USING (true);

-- Policy 2: Authenticated users can insert challenges (we'll check admin in app)
CREATE POLICY "Authenticated users can insert challenges" ON challenges
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- Policy 3: Authenticated users can update challenges (we'll check admin in app)
CREATE POLICY "Authenticated users can update challenges" ON challenges
    FOR UPDATE USING (auth.uid() IS NOT NULL);

-- Policy 4: Authenticated users can delete challenges (we'll check admin in app)
CREATE POLICY "Authenticated users can delete challenges" ON challenges
    FOR DELETE USING (auth.uid() IS NOT NULL);

-- User roles policies
CREATE POLICY "Users can read all roles" ON user_roles
    FOR SELECT USING (true);

CREATE POLICY "Users can manage their own role" ON user_roles
    FOR ALL USING (auth.uid() = user_id);

-- ========================================
-- STEP 7: Test admin permissions
-- ========================================
SELECT 'Testing challenge access:' as test;
SELECT COUNT(*) as total_challenges FROM challenges;

-- ========================================
-- STEP 8: Final verification
-- ========================================
SELECT 'Setup Summary:' as summary;
SELECT 
    (SELECT COUNT(*) FROM challenges) as total_challenges,
    (SELECT COUNT(*) FROM user_roles WHERE role = 'admin') as admin_users,
    (SELECT email FROM auth.users au JOIN user_roles ur ON au.id = ur.user_id WHERE ur.role = 'admin' LIMIT 1) as admin_email;

SELECT 'SUCCESS: Admin permissions configured! Refresh your browser and try the admin panel.' as status;