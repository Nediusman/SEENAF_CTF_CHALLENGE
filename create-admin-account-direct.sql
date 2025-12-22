-- 🚀 DIRECT ADMIN ACCOUNT CREATION
-- This creates your admin account directly in Supabase Auth
-- Run this in Supabase SQL Editor

-- Step 1: Create the admin user directly in auth.users
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    recovery_sent_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    gen_random_uuid(),
    'authenticated',
    'authenticated',
    'nediusman@gmail.com',
    crypt('158595Nedi', gen_salt('bf')), -- Simple password: 123456
    NOW(),
    NOW(),
    NOW(),
    '{"provider":"email","providers":["email"]}',
    '{"username":"nediusman"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
);

-- Step 2: Get the user ID we just created
DO $$
DECLARE
    admin_user_id UUID;
BEGIN
    -- Find the user we just created
    SELECT id INTO admin_user_id 
    FROM auth.users 
    WHERE email = 'nediusman@gmail.com';
    
    -- Create user_roles table if it doesn't exist
    CREATE TABLE IF NOT EXISTS user_roles (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        user_id UUID NOT NULL,
        role TEXT NOT NULL DEFAULT 'player',
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE,
        CONSTRAINT user_roles_role_check CHECK (role IN ('admin', 'player')),
        CONSTRAINT user_roles_user_id_unique UNIQUE (user_id)
    );
    
    -- Create profiles table if it doesn't exist
    CREATE TABLE IF NOT EXISTS profiles (
        id UUID PRIMARY KEY,
        username TEXT NOT NULL,
        avatar_url TEXT,
        total_score INTEGER DEFAULT 0,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE
    );
    
    -- Insert admin role
    INSERT INTO user_roles (user_id, role, created_at)
    VALUES (admin_user_id, 'admin', NOW())
    ON CONFLICT (user_id) DO UPDATE SET role = 'admin';
    
    -- Insert profile
    INSERT INTO profiles (id, username, avatar_url, total_score, created_at, updated_at)
    VALUES (admin_user_id, 'nediusman', NULL, 0, NOW(), NOW())
    ON CONFLICT (id) DO UPDATE SET updated_at = NOW();
    
    -- Disable RLS for easier access
    ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;
    ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;
    ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
    ALTER TABLE submissions DISABLE ROW LEVEL SECURITY;
    
    -- Grant permissions
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO authenticated;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO authenticated;
    
    RAISE NOTICE '✅ SUCCESS! Admin account created:';
    RAISE NOTICE '📧 Email: nediusman@gmail.com';
    RAISE NOTICE '🔑 Password: 158595Nedi';
    RAISE NOTICE '👑 Role: admin';
    RAISE NOTICE '';
    RAISE NOTICE '🚀 You can now login with these credentials!';
END $$;

-- Step 3: Verify everything was created correctly
SELECT 
    '🔍 VERIFICATION:' as status,
    u.email,
    ur.role,
    p.username,
    'Account ready!' as message
FROM auth.users u
LEFT JOIN user_roles ur ON u.id = ur.user_id
LEFT JOIN profiles p ON u.id = p.id
WHERE u.email = 'nediusman@gmail.com';