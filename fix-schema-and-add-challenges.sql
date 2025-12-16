-- Fix schema and add challenges
-- This will ensure all columns exist and add working challenges

-- Step 1: Add missing columns if they don't exist
ALTER TABLE public.challenges 
ADD COLUMN IF NOT EXISTS author TEXT,
ADD COLUMN IF NOT EXISTS instance_url TEXT,
ADD COLUMN IF NOT EXISTS solver_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS likes_count INTEGER DEFAULT 0;

-- Step 2: Clear existing challenges
DELETE FROM public.challenges;

-- Step 3: Insert working challenges with all required fields
INSERT INTO public.challenges (
  title, description, category, difficulty, points, flag, hints, 
  author, instance_url, solver_count, likes_count, is_active
) VALUES 
-- Web Challenges
('Inspect HTML', 'Can you find the flag that''s hiding in this webpage?

This is a basic web challenge where you need to examine the HTML source code of a webpage to find a hidden flag.', 'Web', 'easy', 100, 'SEENAF{1nsp3ct_th3_html_s0urc3}', ARRAY['Try right-clicking and selecting "View Page Source"', 'Look for HTML comments', 'The flag might be in a hidden div or comment'], 'SEENAF Team', 'https://seenafctf.com/web/inspect', 156, 23, true),

('Cookies', 'I heard you like cookies. Nom nom nom.

This challenge involves manipulating browser cookies to access restricted content.', 'Web', 'easy', 150, 'SEENAF{c00k13_m0nst3r_0mg}', ARRAY['Check your browser''s cookies for this site', 'Try changing cookie values', 'Look for cookies named "admin" or "role"'], 'Cookie Monster', 'https://seenafctf.com/web/cookies', 134, 19, true),

('SQL Injection', 'Login as the admin user to get the flag.

This login form is vulnerable to SQL injection. The admin username is "admin".', 'Web', 'medium', 250, 'SEENAF{sql_1nj3ct10n_1s_d4ng3r0us}', ARRAY['Try SQL injection in the password field', 'Use OR 1=1 to bypass authentication', 'Comment out the rest of the query with --'], 'Security Team', 'https://seenafctf.com/web/login', 67, 8, true),

('XSS Playground', 'This comment system doesn''t properly sanitize user input. Can you execute JavaScript code?

Find a way to execute JavaScript in the comment system.', 'Web', 'medium', 300, 'SEENAF{xss_4tt4ck_succ3ssful}', ARRAY['Try injecting <script> tags in comments', 'Use alert() to test XSS', 'Look for input fields that reflect user data'], 'XSS Team', 'https://seenafctf.com/web/xss', 45, 6, true),

-- Crypto Challenges
('The Numbers', 'The numbers... what do they mean?

13 9 3 15 3 20 6 { 20 8 5 14 21 13 2 5 18 19 13 1 19 15 14 }', 'Crypto', 'easy', 100, 'SEENAF{THENUMBERSMASON}', ARRAY['These look like numbers representing letters', 'A=1, B=2, C=3, etc.', 'Convert each number to its corresponding letter'], 'Numbers Station', NULL, 167, 28, true),

('Caesar', 'Decrypt this message that was encrypted with a Caesar cipher.

VHHQDI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}', 'Crypto', 'easy', 150, 'SEENAF{CAESAR_CIPHER_IS_EASY_PEASY}', ARRAY['This is a Caesar cipher', 'Try different shift values', 'The shift is likely 3 (classic Caesar)'], 'Julius Caesar', NULL, 143, 24, true),

('Base64 Basics', 'Decode this Base64 encoded message to find the flag.

U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=', 'Crypto', 'easy', 75, 'SEENAF{base64_is_not_encryption}', ARRAY['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding at the end'], 'Encoding Team', NULL, 189, 32, true),

('Vigenère Cipher', 'This message was encrypted using a Vigenère cipher with the key "SEENAF".

Encrypted: SEENAF{KQGQVKW_UQJLWV_QD_UVKQTM}', 'Crypto', 'medium', 200, 'SEENAF{VIGENERE_CIPHER_IS_STRONG}', ARRAY['The key is "SEENAF"', 'Vigenère uses a repeating key', 'Try an online Vigenère decoder'], 'Crypto Team', NULL, 78, 12, true),

-- Forensics Challenges
('File Extensions', 'This file doesn''t seem to be what it appears to be.

Download the file and determine its real type to extract the flag.', 'Forensics', 'easy', 100, 'SEENAF{f1l3_3xt3ns10ns_l13}', ARRAY['Use the "file" command to check the real file type', 'The extension might be misleading', 'Try opening with different programs'], 'Forensics Team', 'https://seenafctf.com/files/mystery.txt', 145, 21, true),

('Hidden Message', 'This image looks innocent, but there''s a hidden message inside.

Use steganography tools to find the hidden flag.', 'Forensics', 'medium', 200, 'SEENAF{st3g4n0gr4phy_m4st3r}', ARRAY['Use steganography tools like steghide', 'Try the strings command on the image', 'Check the image metadata with exiftool'], 'Stego Team', 'https://seenafctf.com/files/innocent.jpg', 89, 15, true),

('Wireshark Analysis', 'Can you find the flag in this network capture?

Analyze the PCAP file to find suspicious network traffic containing the flag.', 'Forensics', 'medium', 250, 'SEENAF{n3tw0rk_tr4ff1c_4n4lys1s}', ARRAY['Use Wireshark to open the PCAP file', 'Look for HTTP traffic', 'Check POST requests and form data'], 'Network Team', 'https://seenafctf.com/files/capture.pcap', 56, 9, true),

('Memory Dump', 'We captured the memory of a compromised system. The attacker left traces.

Analyze the memory dump to find the flag.', 'Forensics', 'hard', 350, 'SEENAF{m3m0ry_f0r3ns1cs_3xp3rt}', ARRAY['Use Volatility framework', 'Look for suspicious processes', 'Check for injected code or strings'], 'Memory Forensics Team', 'https://seenafctf.com/files/memory.dmp', 34, 5, true),

-- Network Analysis Challenges
('What''s a NET?', 'How about you find the flag in this network capture?

Basic network analysis challenge - find the flag in HTTP traffic.', 'Network', 'easy', 100, 'SEENAF{n3tw0rk_b4s1cs_ftw}', ARRAY['Use Wireshark to analyze the PCAP', 'Look for HTTP GET/POST requests', 'The flag might be in plain text'], 'Network Basics Team', 'https://seenafctf.com/files/basic.pcap', 134, 22, true),

('Shark on Wire 1', 'We found this packet capture. Recover the flag.

Intermediate network forensics - the flag is encoded or hidden in the traffic.', 'Network', 'medium', 200, 'SEENAF{sh4rk_0n_w1r3_1s_c00l}', ARRAY['Use Wireshark''s "Follow TCP Stream" feature', 'Look for base64 encoded data', 'Check different protocols (HTTP, FTP, etc.)'], 'Wireshark Team', 'https://seenafctf.com/files/shark1.pcap', 78, 13, true),

('DNS Exfiltration', 'Data was exfiltrated through DNS queries. Can you recover it?

Analyze DNS traffic to find the hidden data.', 'Network', 'medium', 250, 'SEENAF{dns_3xf1ltr4t10n_d3t3ct3d}', ARRAY['Look for unusual DNS queries', 'Check for data encoded in subdomain names', 'The data might be base64 encoded'], 'DNS Team', 'https://seenafctf.com/files/dns.pcap', 67, 10, true),

('TFTP Transfer', 'Figure out how they moved the flag using TFTP.

This challenge involves analyzing TFTP (Trivial File Transfer Protocol) traffic.', 'Network', 'hard', 300, 'SEENAF{tftp_f1l3_tr4nsf3r_pwn3d}', ARRAY['Look for TFTP traffic in the capture', 'TFTP uses UDP port 69', 'Extract the transferred file'], 'Protocol Team', 'https://seenafctf.com/files/tftp.pcap', 32, 4, true);

-- Step 4: Verify the challenges were inserted
SELECT 
  'Challenges Successfully Added!' as status,
  COUNT(*) as total_challenges,
  COUNT(CASE WHEN category = 'Web' THEN 1 END) as web_challenges,
  COUNT(CASE WHEN category = 'Crypto' THEN 1 END) as crypto_challenges,
  COUNT(CASE WHEN category = 'Forensics' THEN 1 END) as forensics_challenges,
  COUNT(CASE WHEN category = 'Network' THEN 1 END) as network_challenges
FROM public.challenges;

-- Step 5: Show sample challenges
SELECT title, category, difficulty, points, author, 
       CASE WHEN instance_url IS NOT NULL THEN 'Yes' ELSE 'No' END as has_instance
FROM public.challenges 
ORDER BY category, points 
LIMIT 10;