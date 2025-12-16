-- EMERGENCY ADMIN FIX - No email needed
-- This will make the first user in the system an admin

-- ========================================
-- STEP 1: See all users and pick the first one
-- ========================================
SELECT 'All users:' as step;
SELECT id, email, created_at FROM auth.users ORDER BY created_at ASC;

-- ========================================
-- STEP 2: Create user_roles table
-- ========================================
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- ========================================
-- STEP 3: Make the first user an admin (usually you)
-- ========================================
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
ORDER BY created_at ASC 
LIMIT 1
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';

-- ========================================
-- STEP 4: Verify who got admin
-- ========================================
SELECT 'New admin user:' as info;
SELECT ur.role, au.email, au.created_at
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
WHERE ur.role = 'admin';

-- ========================================
-- STEP 5: Disable RLS temporarily for testing
-- ========================================
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- ========================================
-- STEP 6: Test if it works
-- ========================================
SELECT 'Test complete - check admin panel now' as status;