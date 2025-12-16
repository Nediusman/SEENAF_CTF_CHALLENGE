-- SEENAF CTF - Simple Database Setup (Compatible with all PostgreSQL versions)
-- Run this entire script in Supabase SQL Editor

-- Step 1: Create enums (with error handling)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'difficulty_level') THEN
        CREATE TYPE public.difficulty_level AS ENUM ('easy', 'medium', 'hard', 'insane');
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'app_role') THEN
        CREATE TYPE public.app_role AS ENUM ('admin', 'player');
    END IF;
END $$;

-- Step 2: Create profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  avatar_url TEXT,
  total_score INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 3: Create user_roles table
CREATE TABLE IF NOT EXISTS public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role app_role NOT NULL DEFAULT 'player',
  UNIQUE (user_id, role)
);

-- Step 4: Create challenges table with all fields
CREATE TABLE IF NOT EXISTS public.challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  difficulty difficulty_level NOT NULL,
  points INTEGER NOT NULL,
  flag TEXT NOT NULL,
  hints TEXT[],
  is_active BOOLEAN DEFAULT true,
  author TEXT,
  instance_url TEXT,
  solver_count INTEGER DEFAULT 0,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 5: Create submissions table
CREATE TABLE IF NOT EXISTS public.submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE NOT NULL,
  submitted_flag TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL,
  submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, challenge_id, is_correct)
);

-- Step 6: Create challenge_likes table
CREATE TABLE IF NOT EXISTS public.challenge_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, challenge_id)
);

-- Step 7: Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.challenge_likes ENABLE ROW LEVEL SECURITY;

-- Step 8: Create security function
CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role app_role)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

-- Step 9: Create RLS policies (drop existing first to avoid conflicts)
-- Profiles policies
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
CREATE POLICY "Public profiles are viewable by everyone"
  ON public.profiles FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- User roles policies
DROP POLICY IF EXISTS "Users can view own role" ON public.user_roles;
CREATE POLICY "Users can view own role"
  ON public.user_roles FOR SELECT
  USING (auth.uid() = user_id OR public.has_role(auth.uid(), 'admin'));

DROP POLICY IF EXISTS "Admins can manage roles" ON public.user_roles;
CREATE POLICY "Admins can manage roles"
  ON public.user_roles FOR ALL
  USING (public.has_role(auth.uid(), 'admin'));

-- Challenges policies
DROP POLICY IF EXISTS "Active challenges viewable by authenticated users" ON public.challenges;
CREATE POLICY "Active challenges viewable by authenticated users"
  ON public.challenges FOR SELECT
  TO authenticated
  USING (is_active = true OR public.has_role(auth.uid(), 'admin'));

DROP POLICY IF EXISTS "Admins can manage challenges" ON public.challenges;
CREATE POLICY "Admins can manage challenges"
  ON public.challenges FOR ALL
  USING (public.has_role(auth.uid(), 'admin'));

-- Submissions policies
DROP POLICY IF EXISTS "Users can view own submissions" ON public.submissions;
CREATE POLICY "Users can view own submissions"
  ON public.submissions FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can submit flags" ON public.submissions;
CREATE POLICY "Users can submit flags"
  ON public.submissions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admins can view all submissions" ON public.submissions;
CREATE POLICY "Admins can view all submissions"
  ON public.submissions FOR SELECT
  USING (public.has_role(auth.uid(), 'admin'));

-- Challenge likes policies
DROP POLICY IF EXISTS "Users can view all likes" ON public.challenge_likes;
CREATE POLICY "Users can view all likes" ON public.challenge_likes FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can manage their own likes" ON public.challenge_likes;
CREATE POLICY "Users can manage their own likes" ON public.challenge_likes FOR ALL USING (auth.uid() = user_id);

-- Step 10: Create trigger functions
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, username)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)));
  
  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'player');
  
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_user_score()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.is_correct = true THEN
    UPDATE public.profiles
    SET total_score = total_score + (
      SELECT points FROM public.challenges WHERE id = NEW.challenge_id
    ),
    updated_at = NOW()
    WHERE id = NEW.user_id;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.update_challenge_solver_count()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_correct = true AND (OLD IS NULL OR OLD.is_correct = false) THEN
    UPDATE public.challenges 
    SET solver_count = solver_count + 1 
    WHERE id = NEW.challenge_id;
  ELSIF OLD IS NOT NULL AND OLD.is_correct = true AND NEW.is_correct = false THEN
    UPDATE public.challenges 
    SET solver_count = GREATEST(solver_count - 1, 0) 
    WHERE id = NEW.challenge_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.update_challenge_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.challenges 
    SET likes_count = likes_count + 1 
    WHERE id = NEW.challenge_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.challenges 
    SET likes_count = GREATEST(likes_count - 1, 0) 
    WHERE id = OLD.challenge_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Step 11: Create triggers (drop existing first)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

DROP TRIGGER IF EXISTS on_correct_submission ON public.submissions;
CREATE TRIGGER on_correct_submission
  AFTER INSERT ON public.submissions
  FOR EACH ROW
  EXECUTE FUNCTION public.update_user_score();

DROP TRIGGER IF EXISTS update_profiles_updated_at ON public.profiles;
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_challenges_updated_at ON public.challenges;
CREATE TRIGGER update_challenges_updated_at
  BEFORE UPDATE ON public.challenges
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS trigger_update_solver_count ON public.submissions;
CREATE TRIGGER trigger_update_solver_count
  AFTER INSERT OR UPDATE ON public.submissions
  FOR EACH ROW
  EXECUTE FUNCTION public.update_challenge_solver_count();

DROP TRIGGER IF EXISTS trigger_update_likes_count ON public.challenge_likes;
CREATE TRIGGER trigger_update_likes_count
  AFTER INSERT OR DELETE ON public.challenge_likes
  FOR EACH ROW
  EXECUTE FUNCTION public.update_challenge_likes_count();

-- Step 12: Make your user admin
INSERT INTO public.user_roles (user_id, role)
SELECT id, 'admin'
FROM auth.users 
WHERE email = 'nediusman@gmail.com'
ON CONFLICT (user_id, role) DO NOTHING;

-- Step 13: Clear existing challenges and insert sample challenges
DELETE FROM public.challenges;

INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url, solver_count, likes_count) VALUES
('Crack the Gate 1', 'We''re in the middle of an investigation. One of our persons of interest, or player, is believed to be hiding sensitive data inside a restricted web portal. We''ve uncovered the email address he uses to log in.

Unfortunately, we don''t know the password, and the usual guessing techniques haven''t worked. But something feels off... it''s almost like the developer left a secret way in. Can you figure it out?

Additional details will be available after launching your challenge instance.', 'Web', 'easy', 100, 'SEENAF{html_source_code_inspection}', ARRAY['Right-click and view source', 'Look for HTML comments', 'Check for hidden form fields'], 'YAHAYA MEDDY', 'https://challenge.seenafctf.com/gate1', 45, 12),

('Cookie Monster Secret Recipe', 'A famous bakery has digitized their secret cookie recipe and stored it on their website. The recipe is protected, but rumor has it that the protection isn''t as strong as they think.

Can you find the secret ingredient?', 'Web', 'easy', 150, 'SEENAF{cookie_manipulation_master}', ARRAY['Check browser cookies', 'Try modifying cookie values'], 'SEENAF Team', 'https://challenge.seenafctf.com/cookies', 15, 4),

('SQL Injection Login', 'This login form looks vulnerable to SQL injection. Can you bypass the authentication and gain access to the admin panel?', 'Web', 'medium', 200, 'SEENAF{sql_injection_bypass}', ARRAY['Try using OR 1=1', 'Comment out the password check with --', 'Look for error messages'], 'SEENAF Team', 'https://challenge.seenafctf.com/sqli', 8, 2),

('XSS Reflected', 'This search form reflects user input without proper sanitization. Can you execute JavaScript code to steal the admin''s session?', 'Web', 'medium', 250, 'SEENAF{xss_reflected_attack}', ARRAY['Try injecting <script> tags', 'Look for user input reflection', 'Use alert() to test'], 'SEENAF Team', 'https://challenge.seenafctf.com/xss', 5, 1),

('Caesar Cipher', 'Decode this message: VHHQDI{FDHVDU_FLSKHU_FUDFNHG}', 'Crypto', 'easy', 150, 'SEENAF{CAESAR_CIPHER_CRACKED}', ARRAY['This is a simple substitution cipher', 'Try shifting letters by 3 positions', 'A becomes D, B becomes E, etc.'], 'SEENAF Team', NULL, 32, 8),

('Base64 Decode', 'Decode this Base64 string: U0VFTkFGe2Jhc2U2NF9kZWNvZGluZ19tYXN0ZXJ9', 'Crypto', 'easy', 100, 'SEENAF{base64_decoding_master}', ARRAY['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding'], 'SEENAF Team', NULL, 28, 6),

('ROT13 Message', 'Decrypt: FRRANS{ebg13_rapelcgvba_fbyirq}', 'Crypto', 'easy', 120, 'SEENAF{rot13_encryption_solved}', ARRAY['ROT13 shifts each letter 13 positions', 'A becomes N, B becomes O, etc.', 'Try an online ROT13 decoder'], 'SEENAF Team', NULL, 20, 3),

('Hidden in Metadata', 'The flag is hidden in the metadata of this image file. Download the image and analyze it carefully.', 'Forensics', 'medium', 200, 'SEENAF{metadata_analysis_expert}', ARRAY['Use exiftool or similar', 'Check EXIF data of images', 'Look in image comments'], 'SEENAF Team', NULL, 12, 2),

('Network Traffic Analysis', 'Analyze this network capture to find the flag. The flag was transmitted in plain text during a web session.', 'Forensics', 'hard', 400, 'SEENAF{network_forensics_master}', ARRAY['Use Wireshark to analyze', 'Look for HTTP traffic', 'Check POST requests'], 'SEENAF Team', NULL, 3, 0),

('Simple Crackme', 'Reverse engineer this binary to find the correct password that will reveal the flag.', 'Reverse', 'medium', 300, 'SEENAF{reverse_engineering_pro}', ARRAY['Use a disassembler like Ghidra', 'Look for string comparisons', 'Check for hardcoded passwords'], 'SEENAF Team', NULL, 7, 1),

('Buffer Overflow Basic', 'This program has a buffer overflow vulnerability. Exploit it to get the flag from the server.', 'Pwn', 'hard', 400, 'SEENAF{buffer_overflow_pwned}', ARRAY['Find the buffer size', 'Overwrite the return address', 'Use a debugger to analyze'], 'SEENAF Team', 'https://challenge.seenafctf.com/pwn1', 2, 0),

('QR Code Scanner', 'Scan this QR code image to reveal the hidden flag.', 'Misc', 'easy', 50, 'SEENAF{qr_code_scanner_success}', ARRAY['Use a QR code scanner app', 'The image contains a QR code', 'Try online QR decoders'], 'SEENAF Team', NULL, 35, 5),

('Steganography Image', 'The flag is hidden inside this innocent-looking image using steganography techniques.', 'Misc', 'medium', 250, 'SEENAF{hidden_in_plain_sight}', ARRAY['Use steganography tools', 'Try steghide or similar tools', 'Check LSB (Least Significant Bit)'], 'SEENAF Team', NULL, 9, 1),

('OSINT Investigation', 'Find information about the SEENAF organization using open source intelligence techniques. The flag is hidden in their public information.', 'Misc', 'medium', 200, 'SEENAF{osint_investigation_complete}', ARRAY['Use Google, social media', 'Check public records', 'Look at their website and social profiles'], 'SEENAF Team', NULL, 6, 0);

-- Step 14: Verify setup
SELECT 
  'Database Setup Complete!' as status,
  COUNT(*) as total_challenges,
  COUNT(CASE WHEN author IS NOT NULL THEN 1 END) as challenges_with_author,
  COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) as challenges_with_instance
FROM public.challenges;

-- Show your admin status
SELECT 
  u.email,
  ur.role,
  'You are now admin!' as message
FROM auth.users u
JOIN public.user_roles ur ON u.id = ur.user_id
WHERE u.email = 'nediusman@gmail.com';

-- Show first 5 challenges
SELECT title, category, difficulty, points, author, 
       CASE WHEN instance_url IS NOT NULL THEN 'Yes' ELSE 'No' END as has_instance
FROM public.challenges 
ORDER BY points 
LIMIT 5;