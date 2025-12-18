-- QUICK CHALLENGE LOADER - Run this in Supabase SQL Editor
-- This will load 10 essential challenges to get you started

-- Step 1: Clear any existing challenges
DELETE FROM challenges;

-- Step 2: Insert 10 essential challenges
INSERT INTO challenges (title, description, category, difficulty, points, flag, hints, author, instance_url, is_active) VALUES

-- Web Challenges
('SQL Injection Basics', 'Find the hidden flag by exploiting a SQL injection vulnerability in the login form.', 'Web', 'easy', 100, 'SEENAF{sql_injection_is_dangerous}', ARRAY['Try using single quotes', 'Use OR 1=1 condition'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/sqli', true),

('XSS Reflected', 'Exploit a reflected Cross-Site Scripting vulnerability to steal cookies.', 'Web', 'easy', 150, 'SEENAF{xss_cookie_theft_success}', ARRAY['Inject JavaScript code', 'Use document.cookie'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/xss', true),

-- Crypto Challenges  
('Caesar Cipher', 'Decrypt this Caesar cipher: "FRPHFXULWB_LV_IXQ"', 'Crypto', 'easy', 50, 'SEENAF{security_is_fun}', ARRAY['Try different shift values', 'Caesar shifts each letter'], 'Crypto Team', null, true),

('Base64 Decoding', 'Decode: U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=', 'Crypto', 'easy', 75, 'SEENAF{base64_is_not_encryption}', ARRAY['Use Base64 decoder', 'Base64 is encoding not encryption'], 'Crypto Team', null, true),

-- Forensics Challenges
('Hidden in Image', 'The flag is hidden in this image file.', 'Forensics', 'easy', 100, 'SEENAF{steganography_basics}', ARRAY['Use strings command', 'Check image metadata'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/image', true),

('Network Analysis', 'Analyze this network capture to find the transmitted flag.', 'Forensics', 'medium', 200, 'SEENAF{wireshark_packet_analysis}', ARRAY['Use Wireshark', 'Follow TCP streams'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/pcap', true),

-- Reverse Engineering
('Basic Binary', 'Reverse engineer this binary to find the flag.', 'Reverse', 'easy', 150, 'SEENAF{reverse_engineering_basics}', ARRAY['Use strings command', 'Try running the binary'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/basic', true),

-- Network Challenge
('Port Scanning', 'Scan the target to find open ports and the flag in service banners.', 'Network', 'easy', 100, 'SEENAF{nmap_port_discovery}', ARRAY['Use nmap to scan', 'Check service banners'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/scan', true),

-- OSINT Challenge
('Social Media Hunt', 'Find information about username: "cyberdetective2024"', 'OSINT', 'easy', 100, 'SEENAF{social_media_sleuth}', ARRAY['Search multiple platforms', 'Check profile information'], 'OSINT Team', 'https://osint-challenges.seenaf-ctf.com/social', true),

-- Misc Challenge
('QR Code Puzzle', 'Scan this QR code to get the flag.', 'Misc', 'easy', 75, 'SEENAF{qr_code_scanned_successfully}', ARRAY['Use QR code scanner', 'Check for damage'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/qr', true);

-- Step 3: Disable RLS and grant permissions
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;
GRANT ALL ON challenges TO authenticated;
GRANT ALL ON challenges TO anon;

-- Step 4: Verify challenges were loaded
SELECT 'Challenges loaded successfully!' as status;
SELECT category, COUNT(*) as count FROM challenges GROUP BY category ORDER BY category;
SELECT 'Total challenges:' as info, COUNT(*) as total FROM challenges;