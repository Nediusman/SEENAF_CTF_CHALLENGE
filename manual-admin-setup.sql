-- MANUAL ADMIN SETUP - Run each command separately
-- This avoids the ON CONFLICT error by doing things step by step

-- 1. First, let's see what tables exist
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- 2. Check if user_roles exists, if not create it
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    role TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Add unique constraint if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'user_roles_user_id_key' 
        AND table_name = 'user_roles'
    ) THEN
        ALTER TABLE user_roles ADD CONSTRAINT user_roles_user_id_key UNIQUE (user_id);
    END IF;
END $$;

-- 4. Find your user (replace email with yours)
SELECT 'Your user info:' as info, id, email FROM auth.users WHERE email = 'nediusman@gmail.com';

-- 5. Clear any existing role for your user
DELETE FROM user_roles WHERE user_id IN (
    SELECT id FROM auth.users WHERE email = 'nediusman@gmail.com'
);

-- 6. Add admin role for your user
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com';

-- 7. Verify it worked
SELECT 'Admin verification:' as check, ur.role, au.email 
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
WHERE au.email = 'nediusman@gmail.com';

-- 8. TEMPORARY: Disable RLS to test admin functions
-- WARNING: This removes security temporarily
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- 9. Test challenge access
SELECT 'Challenge test:' as test, COUNT(*) as total FROM challenges;