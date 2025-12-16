-- Sample CTF Challenges for your platform
-- Run this in your Supabase SQL Editor to add sample challenges

-- Web Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url) VALUES
('Crack the Gate 1', 'We''re in the middle of an investigation. One of our persons of interest, or player, is believed to be hiding sensitive data inside a restricted web portal. We''ve uncovered the email address he uses to log in. Unfortunately, we don''t know the password, and the usual guessing techniques haven''t worked. But something feels off... it''s almost like the developer left a secret way in. Can you figure it out?

Additional details will be available after launching your challenge instance.', 'Web', 'easy', 100, 'CTF{html_source_code}', ARRAY['Right-click and view source', 'Look for HTML comments'], 'YAHAYA MEDDY', 'https://challenge.seenafctf.com/gate1'),

('SQL Injection Login', 'Bypass the login form using SQL injection techniques.', 'Web', 'medium', 200, 'CTF{sql_injection_bypass}', ARRAY['Try using OR 1=1', 'Comment out the password check with --'], 'SEENAF Team', 'https://challenge.seenafctf.com/sqli'),

('XSS Reflected', 'Execute JavaScript code in this vulnerable search form.', 'Web', 'medium', 250, 'CTF{xss_reflected_attack}', ARRAY['Try injecting <script> tags', 'Look for user input reflection'], 'SEENAF Team', 'https://challenge.seenafctf.com/xss');

-- Crypto Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url) VALUES
('Caesar Cipher', 'Decode this message: FWI{FDHVDU_FLSKHU}', 'Crypto', 'easy', 150, 'CTF{CAESAR_CIPHER}', ARRAY['This is a simple substitution cipher', 'Try shifting letters by 3 positions'], 'SEENAF Team', NULL),

('Base64 Decode', 'Decode this Base64 string: Q1RGe2Jhc2U2NF9kZWNvZGluZ30=', 'Crypto', 'easy', 100, 'CTF{base64_decoding}', ARRAY['This looks like Base64 encoding', 'Use an online Base64 decoder'], 'SEENAF Team', NULL),

('ROT13 Message', 'Decrypt: PGS{ebg13_rapelcgvba}', 'Crypto', 'easy', 120, 'CTF{rot13_encryption}', ARRAY['ROT13 shifts each letter 13 positions', 'A becomes N, B becomes O, etc.'], 'SEENAF Team', NULL);

-- Forensics Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url) VALUES
('Hidden in Metadata', 'The flag is hidden in the metadata of an image file.', 'Forensics', 'medium', 200, 'CTF{metadata_analysis}', ARRAY['Use exiftool or similar', 'Check EXIF data of images'], 'SEENAF Team', NULL),

('Network Traffic', 'Analyze the network capture to find the flag.', 'Forensics', 'hard', 400, 'CTF{network_forensics}', ARRAY['Use Wireshark to analyze', 'Look for HTTP traffic'], 'SEENAF Team', NULL),

('Memory Dump', 'Extract the flag from this memory dump file.', 'Forensics', 'hard', 450, 'CTF{memory_analysis}', ARRAY['Use volatility framework', 'Look for strings in memory'], 'SEENAF Team', NULL);

-- Reverse Engineering
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url) VALUES
('Simple Crackme', 'Reverse engineer this binary to find the correct password.', 'Reverse', 'medium', 300, 'CTF{reverse_engineering}', ARRAY['Use a disassembler like Ghidra', 'Look for string comparisons'], 'SEENAF Team', NULL),

('Packed Binary', 'This binary is packed. Unpack it to find the flag.', 'Reverse', 'hard', 500, 'CTF{unpacked_binary}', ARRAY['Detect the packer first', 'Use appropriate unpacking tools'], 'SEENAF Team', NULL);

-- Pwn Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url) VALUES
('Buffer Overflow', 'Exploit this buffer overflow vulnerability to get the flag.', 'Pwn', 'hard', 400, 'CTF{buffer_overflow_pwn}', ARRAY['Find the buffer size', 'Overwrite the return address'], 'SEENAF Team', 'https://challenge.seenafctf.com/pwn1'),

('Format String', 'Exploit the format string vulnerability in this program.', 'Pwn', 'insane', 600, 'CTF{format_string_exploit}', ARRAY['Use %x to leak memory', 'Try %n to write to memory'], 'SEENAF Team', 'https://challenge.seenafctf.com/pwn2');

-- Misc Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url) VALUES
('QR Code', 'Scan this QR code to get the flag.', 'Misc', 'easy', 50, 'CTF{qr_code_scanner}', ARRAY['Use a QR code scanner app', 'The image contains a QR code'], 'SEENAF Team', NULL),

('Steganography', 'The flag is hidden inside this image using steganography.', 'Misc', 'medium', 250, 'CTF{hidden_in_image}', ARRAY['Use steganography tools', 'Try steghide or similar tools'], 'SEENAF Team', NULL),

('OSINT Challenge', 'Find information about this person using open source intelligence.', 'Misc', 'medium', 200, 'CTF{osint_investigation}', ARRAY['Use Google, social media', 'Check public records'], 'SEENAF Team', NULL);