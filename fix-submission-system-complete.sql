-- COMPLETE SUBMISSION SYSTEM FIX
-- Run this in Supabase SQL Editor to fix all submission issues

-- 1. Drop and recreate submissions table with correct structure
DROP TABLE IF EXISTS submissions CASCADE;

CREATE TABLE submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE NOT NULL,
    submitted_flag TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create indexes for performance
CREATE INDEX idx_submissions_user_id ON submissions(user_id);
CREATE INDEX idx_submissions_challenge_id ON submissions(challenge_id);
CREATE INDEX idx_submissions_correct ON submissions(user_id, is_correct);
CREATE INDEX idx_submissions_user_challenge ON submissions(user_id, challenge_id);

-- 3. Enable RLS
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- 4. Create comprehensive RLS policies
CREATE POLICY "Users can insert their own submissions" ON submissions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own submissions" ON submissions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all submissions" ON submissions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

CREATE POLICY "Admins can delete submissions" ON submissions
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

-- 5. Create or update profiles table
CREATE TABLE IF NOT EXISTS profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT,
    avatar_url TEXT,
    total_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Enable RLS on profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 7. Create profiles policies
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

CREATE POLICY "Public profiles are viewable by everyone" ON profiles
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

-- 8. Create challenge_likes table
CREATE TABLE IF NOT EXISTS challenge_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, challenge_id)
);

-- 9. Enable RLS on challenge_likes
ALTER TABLE challenge_likes ENABLE ROW LEVEL SECURITY;

-- 10. Create challenge_likes policies
DROP POLICY IF EXISTS "Users can manage their own likes" ON challenge_likes;
CREATE POLICY "Users can manage their own likes" ON challenge_likes
    FOR ALL USING (auth.uid() = user_id);

-- 11. Create function to update user scores automatically
CREATE OR REPLACE FUNCTION update_user_score()
RETURNS TRIGGER AS $$
BEGIN
    -- Only update score for correct submissions
    IF NEW.is_correct = true THEN
        INSERT INTO profiles (id, total_score, username)
        VALUES (NEW.user_id, (
            SELECT COALESCE(SUM(c.points), 0)
            FROM submissions s
            JOIN challenges c ON s.challenge_id = c.id
            WHERE s.user_id = NEW.user_id AND s.is_correct = true
        ), COALESCE((
            SELECT email FROM auth.users WHERE id = NEW.user_id
        ), 'Unknown'))
        ON CONFLICT (id) DO UPDATE SET
            total_score = (
                SELECT COALESCE(SUM(c.points), 0)
                FROM submissions s
                JOIN challenges c ON s.challenge_id = c.id
                WHERE s.user_id = NEW.user_id AND s.is_correct = true
            ),
            updated_at = NOW();
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 12. Create trigger to automatically update scores
DROP TRIGGER IF EXISTS update_score_trigger ON submissions;
CREATE TRIGGER update_score_trigger
    AFTER INSERT ON submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_user_score();

-- 13. Create function to handle score updates on deletion
CREATE OR REPLACE FUNCTION update_user_score_on_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Recalculate score after deletion
    IF OLD.is_correct = true THEN
        UPDATE profiles 
        SET total_score = (
            SELECT COALESCE(SUM(c.points), 0)
            FROM submissions s
            JOIN challenges c ON s.challenge_id = c.id
            WHERE s.user_id = OLD.user_id AND s.is_correct = true
        ),
        updated_at = NOW()
        WHERE id = OLD.user_id;
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 14. Create trigger for score updates on deletion
DROP TRIGGER IF EXISTS update_score_on_delete_trigger ON submissions;
CREATE TRIGGER update_score_on_delete_trigger
    AFTER DELETE ON submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_user_score_on_delete();

-- 15. Ensure admin user exists (replace email with your admin email)
INSERT INTO user_roles (user_id, role)
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com'
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';

-- 16. Test the system with a sample submission (optional)
-- Uncomment to test with real user and challenge IDs
/*
INSERT INTO submissions (user_id, challenge_id, submitted_flag, is_correct)
SELECT 
    u.id,
    c.id,
    'SEENAF{base64_is_not_encryption}',
    true
FROM auth.users u, challenges c
WHERE u.email = 'nediusman@gmail.com'
AND c.title = 'Base64 Decoding'
LIMIT 1;
*/

-- 17. Verify setup
SELECT 'SUBMISSION SYSTEM SETUP COMPLETE!' as status;

SELECT 'Tables created:' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_name IN ('submissions', 'profiles', 'challenge_likes', 'challenges', 'user_roles')
ORDER BY table_name;

SELECT 'RLS enabled on:' as info;
SELECT schemaname, tablename, rowsecurity as rls_enabled
FROM pg_tables 
WHERE tablename IN ('submissions', 'profiles', 'challenge_likes')
ORDER BY tablename;

SELECT 'Available challenges:' as info;
SELECT COUNT(*) as challenge_count FROM challenges;

SELECT 'Available users:' as info;
SELECT COUNT(*) as user_count FROM auth.users;

SELECT 'System ready for flag submissions!' as final_status;