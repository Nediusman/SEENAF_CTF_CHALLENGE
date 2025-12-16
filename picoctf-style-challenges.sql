-- SEENAF CTF - PicoCTF Style Challenges
-- Clear existing and add focused challenge set

DELETE FROM public.challenges;

INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url, solver_count, likes_count, is_active) VALUES

-- ========== WEB CHALLENGES (4) ==========
('Inspect HTML', 'Can you find the flag that''s hiding in this webpage?

This is a basic web challenge where you need to examine the HTML source code of a webpage to find a hidden flag.', 'Web', 'easy', 100, 'SEENAF{1nsp3ct_th3_html_s0urc3}', ARRAY['Try right-clicking and selecting "View Page Source"', 'Look for HTML comments', 'The flag might be in a hidden div or comment'], 'SEENAF Team', 'https://seenafctf.com/web/inspect', 156, 23, true),

('Cookies', 'I heard you like cookies. Nom nom nom.

This challenge involves manipulating browser cookies to access restricted content.', 'Web', 'easy', 150, 'SEENAF{c00k13_m0nst3r_0mg}', ARRAY['Check your browser''s cookies for this site', 'Try changing cookie values', 'Look for cookies named "admin" or "role"'], 'Cookie Monster', 'https://seenafctf.com/web/cookies', 134, 19, true),

('SQL Direct', 'Connect to this PostgreSQL database and find the flag.

Server: db.seenafctf.com
Port: 5432
Database: ctf_db
Username: guest
Password: guest123', 'Web', 'medium', 200, 'SEENAF{d1r3ct_sql_4cc3ss_ftw}', ARRAY['Use psql or any PostgreSQL client', 'List all tables with \dt', 'Look for a table named "flags" or similar'], 'Database Admin', NULL, 89, 12, true),

('SQL Injection', 'Login as the admin user to get the flag.

This login form is vulnerable to SQL injection. The admin username is "admin".', 'Web', 'medium', 250, 'SEENAF{sql_1nj3ct10n_1s_d4ng3r0us}', ARRAY['Try SQL injection in the password field', 'Use OR 1=1 to bypass authentication', 'Comment out the rest of the query with --'], 'Security Team', 'https://seenafctf.com/web/login', 67, 8, true),

-- ========== FORENSICS CHALLENGES (4) ==========
('File Extensions', 'This file doesn''t seem to be what it appears to be.

Download the file and determine its real type to extract the flag.', 'Forensics', 'easy', 100, 'SEENAF{f1l3_3xt3ns10ns_l13}', ARRAY['Use the "file" command to check the real file type', 'The extension might be misleading', 'Try opening with different programs'], 'Forensics Team', 'https://seenafctf.com/files/mystery.txt', 145, 21, true),

('Sleuth Kit Intro', 'Download the disk image and find the flag.

Use forensic tools to analyze this disk image and recover deleted files.', 'Forensics', 'medium', 200, 'SEENAF{d1sk_1m4g3_4n4lys1s}', ARRAY['Use Autopsy or Sleuth Kit tools', 'Look for deleted files', 'The flag might be in a recovered text file'], 'Digital Forensics Lab', 'https://seenafctf.com/files/evidence.img', 78, 11, true),

('Wireshark doo dooo do doo...', 'Can you find the flag in this network capture?

Analyze the PCAP file to find suspicious network traffic containing the flag.', 'Forensics', 'medium', 250, 'SEENAF{n3tw0rk_tr4ff1c_4n4lys1s}', ARRAY['Use Wireshark to open the PCAP file', 'Look for HTTP traffic', 'Check POST requests and form data'], 'Network Team', 'https://seenafctf.com/files/capture.pcap', 56, 9, true),

('Disk, disk, sleuth!', 'Use sleuth kit tools to find the flag in this disk image.

This challenge requires advanced disk forensics skills.', 'Forensics', 'hard', 300, 'SEENAF{4dv4nc3d_d1sk_f0r3ns1cs}', ARRAY['Use fls and icat commands', 'Look for hidden or deleted files', 'Check file system metadata'], 'Advanced Forensics', 'https://seenafctf.com/files/advanced.dd', 34, 5, true),

-- ========== CRYPTOGRAPHY CHALLENGES (4) ==========
('The Numbers', 'The numbers... what do they mean?

13 9 3 15 3 20 6 { 20 8 5 14 21 13 2 5 18 19 13 1 19 15 14 }', 'Crypto', 'easy', 100, 'SEENAF{THENUMBERSMASON}', ARRAY['These look like numbers representing letters', 'A=1, B=2, C=3, etc.', 'Convert each number to its corresponding letter'], 'Numbers Station', NULL, 167, 28, true),

('Caesar', 'Decrypt this message that was encrypted with a Caesar cipher.

VHHQDI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}', 'Crypto', 'easy', 150, 'SEENAF{CAESAR_CIPHER_IS_EASY_PEASY}', ARRAY['This is a Caesar cipher', 'Try different shift values', 'The shift is likely 3 (classic Caesar)'], 'Julius Caesar', NULL, 143, 24, true),

('Easy1', 'The one time pad can be cryptographically secure, but not when you know the key. Can you solve this?

Key: SOLVECRYPTO
Ciphertext: SEENAF{GUVF_VF_RNFL_PELCGB}', 'Crypto', 'medium', 200, 'SEENAF{THIS_IS_EASY_CRYPTO}', ARRAY['This is a Vigenère cipher with the given key', 'Use the key "SOLVECRYPTO" to decrypt', 'Try an online Vigenère decoder'], 'Crypto Team', NULL, 89, 15, true),

('Mod 26', 'Decrypt this message encrypted with a custom cipher.

ROT13 twice is the same as ROT26, which is the same as... what?

Ciphertext: FRRANS{EBG13_GJVPR_VF_VQRAGVGL}', 'Crypto', 'medium', 250, 'SEENAF{ROT13_TWICE_IS_IDENTITY}', ARRAY['ROT13 applied twice returns to original', 'ROT26 is the same as no encryption', 'Just apply ROT13 to decrypt'], 'Math Team', NULL, 67, 11, true),

-- ========== NETWORK ANALYSIS CHALLENGES (4) ==========
('What''s a NET?', 'How about you find the flag in this network capture?

Basic network analysis challenge - find the flag in HTTP traffic.', 'Network', 'easy', 100, 'SEENAF{n3tw0rk_b4s1cs_ftw}', ARRAY['Use Wireshark to analyze the PCAP', 'Look for HTTP GET/POST requests', 'The flag might be in plain text'], 'Network Basics Team', 'https://seenafctf.com/files/basic.pcap', 134, 22, true),

('Shark on wire 1', 'We found this packet capture. Recover the flag.

Intermediate network forensics - the flag is encoded or hidden in the traffic.', 'Network', 'medium', 200, 'SEENAF{sh4rk_0n_w1r3_1s_c00l}', ARRAY['Use Wireshark''s "Follow TCP Stream" feature', 'Look for base64 encoded data', 'Check different protocols (HTTP, FTP, etc.)'], 'Wireshark Team', 'https://seenafctf.com/files/shark1.pcap', 78, 13, true),

('Shark on wire 2', 'We found this packet capture. Recover the flag that was exfiltrated.

Advanced network forensics - multiple protocols and encoding layers.', 'Network', 'hard', 300, 'SEENAF{4dv4nc3d_n3tw0rk_4n4lys1s}', ARRAY['Look for DNS exfiltration', 'Check for data hidden in ICMP packets', 'The flag might be split across multiple packets'], 'Advanced Network Team', 'https://seenafctf.com/files/shark2.pcap', 45, 7, true),

('Trivial Flag Transfer Protocol', 'Figure out how they moved the flag.

This challenge involves analyzing TFTP (Trivial File Transfer Protocol) traffic.', 'Network', 'hard', 350, 'SEENAF{tftp_f1l3_tr4nsf3r_pwn3d}', ARRAY['Look for TFTP traffic in the capture', 'TFTP uses UDP port 69', 'Extract the transferred file'], 'Protocol Analysis Team', 'https://seenafctf.com/files/tftp.pcap', 32, 4, true);

-- Update solver counts to be more realistic
UPDATE public.challenges SET 
  solver_count = CASE 
    WHEN difficulty = 'easy' THEN FLOOR(RANDOM() * 50 + 100)
    WHEN difficulty = 'medium' THEN FLOOR(RANDOM() * 40 + 50)
    WHEN difficulty = 'hard' THEN FLOOR(RANDOM() * 30 + 20)
  END,
  likes_count = FLOOR(solver_count * 0.15 + RANDOM() * 10);

-- Show results
SELECT 
  'PicoCTF Style Challenges Created!' as status,
  COUNT(*) as total_challenges,
  COUNT(CASE WHEN category = 'Web' THEN 1 END) as web_challenges,
  COUNT(CASE WHEN category = 'Forensics' THEN 1 END) as forensics_challenges,
  COUNT(CASE WHEN category = 'Crypto' THEN 1 END) as crypto_challenges,
  COUNT(CASE WHEN category = 'Network' THEN 1 END) as network_challenges
FROM public.challenges;

-- Show challenge breakdown
SELECT category, difficulty, COUNT(*) as count, 
       MIN(points) as min_points, MAX(points) as max_points
FROM public.challenges 
GROUP BY category, difficulty 
ORDER BY category, difficulty;