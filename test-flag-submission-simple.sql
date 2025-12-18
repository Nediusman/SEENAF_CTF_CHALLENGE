-- SIMPLE FLAG SUBMISSION TEST
-- Run this to test if the submission system works

-- 1. First, make sure submissions table exists with correct structure
CREATE TABLE IF NOT EXISTS submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE NOT NULL,
    submitted_flag TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Enable RLS
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- 3. Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Users can view their own submissions" ON submissions;
DROP POLICY IF EXISTS "Users can insert their own submissions" ON submissions;
DROP POLICY IF EXISTS "Admins can view all submissions" ON submissions;

-- 4. Create simple, permissive policies for testing
CREATE POLICY "Users can insert submissions" ON submissions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own submissions" ON submissions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can do everything" ON submissions
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM user_roles 
            WHERE user_id = auth.uid() 
            AND role = 'admin'
        )
        OR auth.uid() = user_id
    );

-- 5. Test with a simple challenge (Base64 example)
-- Get the Base64 challenge ID
SELECT 'BASE64 CHALLENGE:' as info;
SELECT id, title, flag FROM challenges WHERE title = 'Base64 Decoding' LIMIT 1;

-- 6. Show current user
SELECT 'CURRENT USER:' as info;
SELECT auth.uid() as user_id, auth.role() as role;

-- 7. Test submission permissions
SELECT 'TESTING PERMISSIONS:' as info;
SELECT 
    CASE 
        WHEN auth.uid() IS NOT NULL THEN 'User is authenticated'
        ELSE 'User is NOT authenticated'
    END as auth_status;

-- 8. Manual test submission (replace IDs with real ones)
-- To test manually, uncomment and replace with real IDs:
/*
INSERT INTO submissions (user_id, challenge_id, submitted_flag, is_correct)
VALUES (
    auth.uid(),
    (SELECT id FROM challenges WHERE title = 'Base64 Decoding' LIMIT 1),
    'SEENAF{base64_is_not_encryption}',
    true
);
*/

-- 9. Check if submission worked
SELECT 'RECENT SUBMISSIONS:' as info;
SELECT 
    s.*,
    c.title as challenge_title,
    u.email as user_email
FROM submissions s
LEFT JOIN challenges c ON s.challenge_id = c.id
LEFT JOIN auth.users u ON s.user_id = u.id
ORDER BY s.submitted_at DESC
LIMIT 5;

-- 10. Create profiles table if it doesn't exist
CREATE TABLE IF NOT EXISTS profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT,
    avatar_url TEXT,
    total_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS "Public profiles are viewable by everyone" ON profiles
    FOR SELECT USING (true);

CREATE POLICY IF NOT EXISTS "Users can insert their own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY IF NOT EXISTS "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

SELECT 'SUBMISSION SYSTEM READY!' as status;
SELECT 'Try submitting: SEENAF{base64_is_not_encryption} for Base64 Decoding challenge' as test_instruction;