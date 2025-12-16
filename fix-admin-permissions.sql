-- Fix admin permissions for SEENAF_CTF platform
-- This script ensures admins can create, read, update, and delete challenges

-- 1. First, ensure the user_roles table exists and has proper structure
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- 2. Enable RLS on user_roles
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- 3. Create RLS policies for user_roles table
DROP POLICY IF EXISTS "Users can view their own role" ON user_roles;
CREATE POLICY "Users can view their own role" ON user_roles
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admins can manage all roles" ON user_roles;
CREATE POLICY "Admins can manage all roles" ON user_roles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- 4. Ensure challenges table has proper structure
ALTER TABLE challenges ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;
ALTER TABLE challenges ADD COLUMN IF NOT EXISTS author TEXT;
ALTER TABLE challenges ADD COLUMN IF NOT EXISTS instance_url TEXT;

-- 5. Enable RLS on challenges table
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- 6. Drop existing policies and create new ones
DROP POLICY IF EXISTS "Anyone can view active challenges" ON challenges;
DROP POLICY IF EXISTS "Admins can view all challenges" ON challenges;
DROP POLICY IF EXISTS "Admins can insert challenges" ON challenges;
DROP POLICY IF EXISTS "Admins can update challenges" ON challenges;
DROP POLICY IF EXISTS "Admins can delete challenges" ON challenges;

-- 7. Create comprehensive RLS policies for challenges

-- Policy 1: Regular users can only view active challenges
CREATE POLICY "Users can view active challenges" ON challenges
    FOR SELECT USING (
        is_active = true OR 
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- Policy 2: Admins can insert challenges
CREATE POLICY "Admins can insert challenges" ON challenges
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- Policy 3: Admins can update challenges
CREATE POLICY "Admins can update challenges" ON challenges
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- Policy 4: Admins can delete challenges
CREATE POLICY "Admins can delete challenges" ON challenges
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- 8. Ensure your user has admin role (replace with your email)
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com'
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';

-- 9. Create a function to check if user is admin (helper function)
CREATE OR REPLACE FUNCTION is_admin(user_uuid UUID DEFAULT auth.uid())
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM user_roles 
        WHERE user_id = user_uuid AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 10. Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- 11. Verify the setup
SELECT 'Admin role verification' as check_type;
SELECT ur.role, au.email, p.username
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
LEFT JOIN profiles p ON ur.user_id = p.id
WHERE au.email = 'nediusman@gmail.com';

SELECT 'RLS policies on challenges' as check_type;
SELECT schemaname, tablename, policyname, permissive, roles, cmd
FROM pg_policies 
WHERE tablename = 'challenges'
ORDER BY policyname;

SELECT 'Sample challenges check' as check_type;
SELECT id, title, is_active, created_at 
FROM challenges 
ORDER BY created_at DESC 
LIMIT 5;