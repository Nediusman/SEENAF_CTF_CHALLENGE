-- First, run the enhancements migration
-- Add new fields to challenges table
ALTER TABLE challenges 
ADD COLUMN IF NOT EXISTS author TEXT,
ADD COLUMN IF NOT EXISTS instance_url TEXT,
ADD COLUMN IF NOT EXISTS solver_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS likes_count INTEGER DEFAULT 0;

-- Create challenge_likes table
CREATE TABLE IF NOT EXISTS challenge_likes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, challenge_id)
);

-- Enable RLS on challenge_likes
ALTER TABLE challenge_likes ENABLE ROW LEVEL SECURITY;

-- Create policies for challenge_likes
DROP POLICY IF EXISTS "Users can view all likes" ON challenge_likes;
CREATE POLICY "Users can view all likes" ON challenge_likes FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can manage their own likes" ON challenge_likes;
CREATE POLICY "Users can manage their own likes" ON challenge_likes FOR ALL USING (auth.uid() = user_id);

-- Create function to update solver count
CREATE OR REPLACE FUNCTION update_challenge_solver_count()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_correct = true AND (OLD IS NULL OR OLD.is_correct = false) THEN
    UPDATE challenges 
    SET solver_count = solver_count + 1 
    WHERE id = NEW.challenge_id;
  ELSIF OLD IS NOT NULL AND OLD.is_correct = true AND NEW.is_correct = false THEN
    UPDATE challenges 
    SET solver_count = GREATEST(solver_count - 1, 0) 
    WHERE id = NEW.challenge_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for solver count
DROP TRIGGER IF EXISTS trigger_update_solver_count ON submissions;
CREATE TRIGGER trigger_update_solver_count
  AFTER INSERT OR UPDATE ON submissions
  FOR EACH ROW
  EXECUTE FUNCTION update_challenge_solver_count();

-- Create function to update likes count
CREATE OR REPLACE FUNCTION update_challenge_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE challenges 
    SET likes_count = likes_count + 1 
    WHERE id = NEW.challenge_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE challenges 
    SET likes_count = GREATEST(likes_count - 1, 0) 
    WHERE id = OLD.challenge_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for likes count
DROP TRIGGER IF EXISTS trigger_update_likes_count ON challenge_likes;
CREATE TRIGGER trigger_update_likes_count
  AFTER INSERT OR DELETE ON challenge_likes
  FOR EACH ROW
  EXECUTE FUNCTION update_challenge_likes_count();

-- Clear existing challenges (optional - remove this line if you want to keep existing ones)
-- DELETE FROM challenges;

-- Insert sample challenges with new fields
INSERT INTO challenges (title, description, category, difficulty, points, flag, hints, author, instance_url) VALUES
('Crack the Gate 1', 'We''re in the middle of an investigation. One of our persons of interest, or player, is believed to be hiding sensitive data inside a restricted web portal. We''ve uncovered the email address he uses to log in.

Unfortunately, we don''t know the password, and the usual guessing techniques haven''t worked. But something feels off... it''s almost like the developer left a secret way in. Can you figure it out?

Additional details will be available after launching your challenge instance.', 'Web', 'easy', 100, 'SEENAF{html_source_code_inspection}', ARRAY['Right-click and view source', 'Look for HTML comments', 'Check for hidden form fields'], 'YAHAYA MEDDY', 'https://challenge.seenafctf.com/gate1'),

('Cookie Monster Secret Recipe', 'A famous bakery has digitized their secret cookie recipe and stored it on their website. The recipe is protected, but rumor has it that the protection isn''t as strong as they think.

Can you find the secret ingredient?', 'Web', 'easy', 150, 'SEENAF{cookie_manipulation_master}', ARRAY['Check browser cookies', 'Try modifying cookie values'], 'SEENAF Team', 'https://challenge.seenafctf.com/cookies'),

('SQL Injection Login', 'This login form looks vulnerable to SQL injection. Can you bypass the authentication and gain access to the admin panel?', 'Web', 'medium', 200, 'SEENAF{sql_injection_bypass}', ARRAY['Try using OR 1=1', 'Comment out the password check with --', 'Look for error messages'], 'SEENAF Team', 'https://challenge.seenafctf.com/sqli'),

('XSS Reflected', 'This search form reflects user input without proper sanitization. Can you execute JavaScript code to steal the admin''s session?', 'Web', 'medium', 250, 'SEENAF{xss_reflected_attack}', ARRAY['Try injecting <script> tags', 'Look for user input reflection', 'Use alert() to test'], 'SEENAF Team', 'https://challenge.seenafctf.com/xss'),

('Caesar Cipher', 'Decode this message: VHHQDI{FDHVDU_FLSKHU_FUDFNHG}', 'Crypto', 'easy', 150, 'SEENAF{CAESAR_CIPHER_CRACKED}', ARRAY['This is a simple substitution cipher', 'Try shifting letters by 3 positions', 'A becomes D, B becomes E, etc.'], 'SEENAF Team', NULL),

('Base64 Decode', 'Decode this Base64 string: U0VFTkFGe2Jhc2U2NF9kZWNvZGluZ19tYXN0ZXJ9', 'Crypto', 'easy', 100, 'SEENAF{base64_decoding_master}', ARRAY['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding'], 'SEENAF Team', NULL),

('ROT13 Message', 'Decrypt: FRRANS{ebg13_rapelcgvba_fbyirq}', 'Crypto', 'easy', 120, 'SEENAF{rot13_encryption_solved}', ARRAY['ROT13 shifts each letter 13 positions', 'A becomes N, B becomes O, etc.', 'Try an online ROT13 decoder'], 'SEENAF Team', NULL),

('Hidden in Metadata', 'The flag is hidden in the metadata of this image file. Download the image and analyze it carefully.', 'Forensics', 'medium', 200, 'SEENAF{metadata_analysis_expert}', ARRAY['Use exiftool or similar', 'Check EXIF data of images', 'Look in image comments'], 'SEENAF Team', NULL),

('Network Traffic Analysis', 'Analyze this network capture to find the flag. The flag was transmitted in plain text during a web session.', 'Forensics', 'hard', 400, 'SEENAF{network_forensics_master}', ARRAY['Use Wireshark to analyze', 'Look for HTTP traffic', 'Check POST requests'], 'SEENAF Team', NULL),

('Simple Crackme', 'Reverse engineer this binary to find the correct password that will reveal the flag.', 'Reverse', 'medium', 300, 'SEENAF{reverse_engineering_pro}', ARRAY['Use a disassembler like Ghidra', 'Look for string comparisons', 'Check for hardcoded passwords'], 'SEENAF Team', NULL),

('Buffer Overflow Basic', 'This program has a buffer overflow vulnerability. Exploit it to get the flag from the server.', 'Pwn', 'hard', 400, 'SEENAF{buffer_overflow_pwned}', ARRAY['Find the buffer size', 'Overwrite the return address', 'Use a debugger to analyze'], 'SEENAF Team', 'https://challenge.seenafctf.com/pwn1'),

('QR Code Scanner', 'Scan this QR code image to reveal the hidden flag.', 'Misc', 'easy', 50, 'SEENAF{qr_code_scanner_success}', ARRAY['Use a QR code scanner app', 'The image contains a QR code', 'Try online QR decoders'], 'SEENAF Team', NULL),

('Steganography Image', 'The flag is hidden inside this innocent-looking image using steganography techniques.', 'Misc', 'medium', 250, 'SEENAF{hidden_in_plain_sight}', ARRAY['Use steganography tools', 'Try steghide or similar tools', 'Check LSB (Least Significant Bit)'], 'SEENAF Team', NULL),

('OSINT Investigation', 'Find information about the SEENAF organization using open source intelligence techniques. The flag is hidden in their public information.', 'Misc', 'medium', 200, 'SEENAF{osint_investigation_complete}', ARRAY['Use Google, social media', 'Check public records', 'Look at their website and social profiles'], 'SEENAF Team', NULL);

-- Update solver counts for some challenges to make it look realistic
UPDATE challenges SET solver_count = 45 WHERE title = 'Crack the Gate 1';
UPDATE challenges SET solver_count = 32 WHERE title = 'Caesar Cipher';
UPDATE challenges SET solver_count = 28 WHERE title = 'Base64 Decode';
UPDATE challenges SET solver_count = 15 WHERE title = 'Cookie Monster Secret Recipe';
UPDATE challenges SET solver_count = 8 WHERE title = 'SQL Injection Login';
UPDATE challenges SET solver_count = 5 WHERE title = 'XSS Reflected';

-- Update likes counts
UPDATE challenges SET likes_count = 12 WHERE title = 'Crack the Gate 1';
UPDATE challenges SET likes_count = 8 WHERE title = 'Caesar Cipher';
UPDATE challenges SET likes_count = 6 WHERE title = 'Base64 Decode';
UPDATE challenges SET likes_count = 4 WHERE title = 'Cookie Monster Secret Recipe';