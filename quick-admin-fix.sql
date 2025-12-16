-- Quick fix for admin permissions
-- Run this in your Supabase SQL editor

-- 1. Set your user as admin (replace email with yours)
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com'
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';

-- 2. Temporarily disable RLS to test (ONLY FOR DEBUGGING)
-- WARNING: This removes security temporarily - re-enable after testing
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- 3. Test if you can now create/edit/delete challenges in the admin panel
-- After confirming it works, re-enable RLS with proper policies:

-- 4. Re-enable RLS with admin-friendly policies
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Enable read access for all users" ON challenges;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON challenges;
DROP POLICY IF EXISTS "Enable update for users based on email" ON challenges;
DROP POLICY IF EXISTS "Enable delete for users based on email" ON challenges;

-- Create simple admin policies
CREATE POLICY "Admins can do everything with challenges" ON challenges
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

CREATE POLICY "Users can view active challenges" ON challenges
    FOR SELECT USING (
        is_active = true OR 
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- 5. Verify your admin status
SELECT 'Your admin status:' as info;
SELECT ur.role, au.email 
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
WHERE au.email = 'nediusman@gmail.com';