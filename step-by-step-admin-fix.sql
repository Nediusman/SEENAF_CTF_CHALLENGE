-- STEP-BY-STEP ADMIN FIX
-- Copy and run each section separately in Supabase SQL Editor

-- ========================================
-- STEP 1: Create user_roles table
-- ========================================
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- ========================================
-- STEP 2: Find your user ID (run this and note the ID)
-- ========================================
SELECT id, email FROM auth.users WHERE email = 'nediusman@gmail.com';

-- ========================================
-- STEP 3: Set admin role (replace YOUR_USER_ID with the ID from step 2)
-- ========================================
-- First delete any existing role
DELETE FROM user_roles WHERE user_id = (
    SELECT id FROM auth.users WHERE email = 'nediusman@gmail.com'
);

-- Then insert admin role
INSERT INTO user_roles (user_id, role) VALUES (
    (SELECT id FROM auth.users WHERE email = 'nediusman@gmail.com'),
    'admin'
);

-- ========================================
-- STEP 4: Verify admin role was set
-- ========================================
SELECT ur.role, au.email 
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
WHERE au.email = 'nediusman@gmail.com';

-- ========================================
-- STEP 5: Temporarily disable RLS for testing
-- ========================================
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- ========================================
-- STEP 6: Test if you can now access challenges
-- ========================================
SELECT COUNT(*) as total_challenges FROM challenges;

-- ========================================
-- STEP 7: After testing admin functions, re-enable RLS with proper policies
-- ========================================
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;

-- Drop any existing policies
DROP POLICY IF EXISTS "Enable read access for all users" ON challenges;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON challenges;
DROP POLICY IF EXISTS "Enable update for users based on email" ON challenges;
DROP POLICY IF EXISTS "Enable delete for users based on email" ON challenges;

-- Create admin-friendly policies
CREATE POLICY "Admins can manage challenges" ON challenges
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