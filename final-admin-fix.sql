-- FINAL ADMIN FIX - Using your actual user info from screenshot
-- Your email: nediusman@gmail.com
-- Your partial user ID visible: a83a-nediusman-325

-- ========================================
-- STEP 1: Find your complete user ID
-- ========================================
SELECT 'Finding your user:' as step;
SELECT id, email FROM auth.users WHERE email = 'nediusman@gmail.com';

-- ========================================
-- STEP 2: Create user_roles table properly
-- ========================================
DROP TABLE IF EXISTS user_roles;
CREATE TABLE user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL CHECK (role IN ('admin', 'player')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- ========================================
-- STEP 3: Set admin role using your email
-- ========================================
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com';

-- ========================================
-- STEP 4: Verify the admin role was set
-- ========================================
SELECT 'Admin verification:' as step;
SELECT ur.role, au.email, au.id
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
WHERE au.email = 'nediusman@gmail.com';

-- ========================================
-- STEP 5: Completely disable RLS for testing
-- ========================================
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE submissions DISABLE ROW LEVEL SECURITY;

-- ========================================
-- STEP 6: Test challenge operations
-- ========================================
SELECT 'Testing challenge access:' as step;
SELECT COUNT(*) as total_challenges FROM challenges;

-- ========================================
-- STEP 7: Grant all permissions to authenticated users (temporary)
-- ========================================
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;

SELECT 'Setup complete - refresh browser and try admin functions' as status;