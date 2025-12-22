-- 🔐 SECURE ADMIN ACCOUNT CREATION
-- This script creates a proper admin account in your CTF platform
-- Replace the email and run this in your Supabase SQL Editor

-- Step 1: First, you need to sign up normally through the platform UI
-- Go to your platform and create a regular account with your desired email

-- Step 2: After signing up, run this SQL to make that user an admin
-- REPLACE 'your-admin-email@example.com' with your actual email

DO $$
DECLARE
    admin_user_id UUID;
    admin_email TEXT := 'nediusman@gmail.com'; -- 🚨 CHANGE THIS EMAIL
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
        -- Update user profile to admin
        INSERT INTO public.profiles (id, email, role, created_at, updated_at)
        VALUES (
            admin_user_id,
            admin_email,
            'admin',
            NOW(),
            NOW()
        )
        ON CONFLICT (id) 
        DO UPDATE SET 
            role = 'admin',
            updated_at = NOW();
            
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

-- Step 3: Verify the admin was created correctly
SELECT 
    u.email,
    p.role,
    p.created_at as profile_created,
    u.created_at as user_created
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id
WHERE u.email = 'nediusman@gmail.com'; -- 🚨 CHANGE THIS EMAIL TOO