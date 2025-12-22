-- 🔐 SECURE ADMIN ACCOUNT CREATION (FIXED VERSION)
-- This script creates a proper admin account in your CTF platform
-- Run this in your Supabase SQL Editor after signing up

-- IMPORTANT: First sign up through your platform UI with email: nediusman@gmail.com

DO $$
DECLARE
    admin_user_id UUID;
    admin_email TEXT := 'nediusman@gmail.com'; -- ✅ Your email is already set
BEGIN
    -- Find the user by email
    SELECT id INTO admin_user_id 
    FROM auth.users 
    WHERE email = admin_email;
    
    IF admin_user_id IS NULL THEN
        RAISE NOTICE '❌ User with email % not found. Please sign up first!', admin_email;
        RAISE NOTICE '📝 Steps to fix:';
        RAISE NOTICE '1. Go to your CTF platform';
        RAISE NOTICE '2. Click "Sign Up" and create account with email: %', admin_email;
        RAISE NOTICE '3. Verify your email if required';
        RAISE NOTICE '4. Come back and run this script again';
    ELSE
        -- Create or update user profile (profiles table doesn't have role column)
        INSERT INTO public.profiles (id, username, avatar_url, total_score, created_at, updated_at)
        VALUES (
            admin_user_id,
            'nediusman', -- Username from email
            NULL,
            0,
            NOW(),
            NOW()
        )
        ON CONFLICT (id) 
        DO UPDATE SET 
            updated_at = NOW();

        -- Create or update admin role in user_roles table (this is where role is stored)
        INSERT INTO public.user_roles (user_id, role, created_at)
        VALUES (
            admin_user_id,
            'admin',
            NOW()
        )
        ON CONFLICT (user_id) 
        DO UPDATE SET 
            role = 'admin';
            
        RAISE NOTICE '✅ SUCCESS! Admin account created for: %', admin_email;
        RAISE NOTICE '🎯 User ID: %', admin_user_id;
        RAISE NOTICE '👑 Role: admin';
        RAISE NOTICE '';
        RAISE NOTICE '🚀 Next steps:';
        RAISE NOTICE '1. Log out of your platform';
        RAISE NOTICE '2. Log back in with: %', admin_email;
        RAISE NOTICE '3. Go to /admin to access admin panel';
        RAISE NOTICE '4. You should now have full admin access!';
    END IF;
END $$;

-- Verify the admin was created correctly
SELECT 
    '🔍 VERIFICATION RESULTS:' as status,
    u.email,
    ur.role,
    p.username,
    ur.created_at as role_created,
    u.created_at as user_created
FROM auth.users u
LEFT JOIN public.user_roles ur ON u.id = ur.user_id
LEFT JOIN public.profiles p ON u.id = p.id
WHERE u.email = 'nediusman@gmail.com';

-- Also ensure proper permissions are set
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE submissions DISABLE ROW LEVEL SECURITY;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO authenticated;

SELECT '🎉 SETUP COMPLETE! You can now access the admin panel.' as final_status;