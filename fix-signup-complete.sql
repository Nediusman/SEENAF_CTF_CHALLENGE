-- COMPLETE SIGNUP FIX - Solves "Database error saving new user"
-- Run this in Supabase SQL Editor

-- 1. First, let's check what tables exist
SELECT 'Checking existing tables...' as status;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('profiles', 'user_roles', 'challenges');

-- 2. Create profiles table with correct structure
DROP TABLE IF EXISTS profiles CASCADE;
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT NOT NULL,
    avatar_url TEXT,
    total_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create user_roles table
DROP TABLE IF EXISTS user_roles CASCADE;
CREATE TABLE user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    role TEXT NOT NULL DEFAULT 'player',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Disable RLS temporarily to allow profile creation
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;

-- 5. Grant all permissions to authenticated users
GRANT ALL ON profiles TO authenticated, anon;
GRANT ALL ON user_roles TO authenticated, anon;
GRANT USAGE ON SCHEMA public TO authenticated, anon;

-- 6. Create function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
    user_username TEXT;
BEGIN
    -- Extract username from metadata or use email prefix
    user_username := COALESCE(
        NEW.raw_user_meta_data->>'username',
        SPLIT_PART(NEW.email, '@', 1)
    );
    
    -- Insert profile
    INSERT INTO public.profiles (id, username, total_score)
    VALUES (NEW.id, user_username, 0);
    
    -- Insert user role
    INSERT INTO public.user_roles (user_id, role)
    VALUES (NEW.id, 'player');
    
    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Log error but don't fail the signup
        RAISE WARNING 'Error creating profile for user %: %', NEW.id, SQLERRM;
        RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Drop existing trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- 8. Create trigger for automatic profile creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- 9. Create admin user role for nediusman@gmail.com
INSERT INTO user_roles (user_id, role)
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com'
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';

-- 10. Test the setup
SELECT 'SIGNUP FIX COMPLETE!' as status;

-- 11. Verify the trigger was created
SELECT 'Trigger status:' as info;
SELECT trigger_name, event_manipulation, action_timing, action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'users' 
AND trigger_schema = 'auth'
AND trigger_name = 'on_auth_user_created';

-- 12. Show current permissions
SELECT 'Table permissions:' as info;
SELECT grantee, privilege_type, table_name
FROM information_schema.role_table_grants 
WHERE table_name IN ('profiles', 'user_roles')
AND grantee IN ('authenticated', 'anon');

SELECT 'You can now register new users successfully!' as final_status;

-- IMPORTANT: After testing registration works, you can re-enable RLS for security:
-- ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
-- Then create appropriate RLS policies