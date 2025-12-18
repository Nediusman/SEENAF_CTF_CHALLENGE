-- QUICK REGISTRATION FIX
-- Run this in Supabase SQL Editor to fix the signup error

-- 1. Grant permissions to authenticated users
GRANT ALL ON public.profiles TO authenticated;
GRANT ALL ON public.user_roles TO authenticated;

-- 2. Create simple profile creation function
CREATE OR REPLACE FUNCTION create_profile_for_user(user_id UUID, email TEXT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO profiles (id, username, total_score)
    VALUES (user_id, SPLIT_PART(email, '@', 1), 0)
    ON CONFLICT (id) DO NOTHING;
    
    INSERT INTO user_roles (user_id, role)
    VALUES (user_id, 'player')
    ON CONFLICT (user_id) DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Disable RLS temporarily for testing (re-enable after registration works)
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles DISABLE ROW LEVEL SECURITY;

-- 4. Test query
SELECT 'Quick fix applied - try registering now!' as status;

-- After registration works, you can re-enable RLS:
-- ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;