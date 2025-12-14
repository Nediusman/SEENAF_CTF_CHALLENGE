-- SQL to create a real admin user in Supabase
-- Run this in your Supabase SQL Editor

-- First, you need to create the user through Supabase Auth API or dashboard
-- Then run this to grant admin privileges:

-- Method 1: If you know the user ID
-- INSERT INTO public.user_roles (user_id, role)
-- VALUES ('your-user-id-here', 'admin');

-- Method 2: Grant admin role by email (after user is created)
DO $$
DECLARE
    user_uuid UUID;
BEGIN
    -- Find user by email (replace with actual email)
    SELECT id INTO user_uuid
    FROM auth.users
    WHERE email = 'nediusman@gmail.com';
    
    -- If user exists, grant admin role
    IF user_uuid IS NOT NULL THEN
        INSERT INTO public.user_roles (user_id, role)
        VALUES (user_uuid, 'admin')
        ON CONFLICT (user_id, role) DO NOTHING;
        
        RAISE NOTICE 'Admin role granted to user: %', user_uuid;
    ELSE
        RAISE NOTICE 'User not found with email: nediusman@gmail.com';
    END IF;
END $$;

-- Check if admin role was granted
SELECT 
    u.email,
    u.id,
    ur.role,
    p.username
FROM auth.users u
LEFT JOIN public.user_roles ur ON u.id = ur.user_id
LEFT JOIN public.profiles p ON u.id = p.id
WHERE u.email = 'nediusman@gmail.com';