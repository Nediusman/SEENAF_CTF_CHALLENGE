-- FIX SUBMISSIONS TABLE AND SOLVED CHALLENGES ISSUE
-- Run this in Supabase SQL Editor

-- 1. Create submissions table if it doesn't exist
CREATE TABLE IF NOT EXISTS submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
    submitted_flag TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, challenge_id, is_correct) -- Prevent duplicate correct submissions
);

-- 2. Enable RLS on submissions table
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- 3. Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own submissions" ON submissions;
DROP POLICY IF EXISTS "Users can insert their own submissions" ON submissions;
DROP POLICY IF EXISTS "Admins can view all submissions" ON submissions;

-- 4. Create RLS policies for submissions
CREATE POLICY "Users can view their own submissions" ON submissions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own submissions" ON submissions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all submissions" ON submissions
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
    );

-- 5. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_submissions_user_id ON submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_submissions_challenge_id ON submissions(challenge_id);
CREATE INDEX IF NOT EXISTS idx_submissions_correct ON submissions(user_id, is_correct);

-- 6. Create or update profiles table to track scores
CREATE TABLE IF NOT EXISTS profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT,
    avatar_url TEXT,
    total_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Enable RLS on profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 8. Create RLS policies for profiles
DROP POLICY IF EXISTS "Users can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

CREATE POLICY "Users can view all profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- 9. Create function to update user scores
CREATE OR REPLACE FUNCTION update_user_score()
RETURNS TRIGGER AS $$
BEGIN
    -- Only update score for correct submissions
    IF NEW.is_correct = true THEN
        INSERT INTO profiles (id, total_score)
        VALUES (NEW.user_id, (
            SELECT COALESCE(SUM(c.points), 0)
            FROM submissions s
            JOIN challenges c ON s.challenge_id = c.id
            WHERE s.user_id = NEW.user_id AND s.is_correct = true
        ))
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

-- 10. Create trigger to automatically update scores
DROP TRIGGER IF EXISTS update_score_trigger ON submissions;
CREATE TRIGGER update_score_trigger
    AFTER INSERT ON submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_user_score();

-- 11. Test the setup
SELECT 'SETUP COMPLETE!' as status;
SELECT 'Submissions table structure:' as info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'submissions';

SELECT 'Profiles table structure:' as info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'profiles';

-- 12. Show current data counts
SELECT 'Current data:' as info;
SELECT 
    (SELECT COUNT(*) FROM challenges) as total_challenges,
    (SELECT COUNT(*) FROM submissions) as total_submissions,
    (SELECT COUNT(*) FROM submissions WHERE is_correct = true) as correct_submissions,
    (SELECT COUNT(*) FROM profiles) as total_profiles;