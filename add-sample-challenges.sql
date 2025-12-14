-- Sample CTF Challenges for your platform
-- Run this in your Supabase SQL Editor to add sample challenges

-- Web Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints) VALUES
('View Source', 'The flag is hidden in the HTML source code of this webpage.', 'Web', 'easy', 100, 'CTF{html_source_code}', ARRAY['Right-click and view source', 'Look for HTML comments']),

('SQL Injection Login', 'Bypass the login form using SQL injection techniques.', 'Web', 'medium', 200, 'CTF{sql_injection_bypass}', ARRAY['Try using OR 1=1', 'Comment out the password check with --']),

('XSS Reflected', 'Execute JavaScript code in this vulnerable search form.', 'Web', 'medium', 250, 'CTF{xss_reflected_attack}', ARRAY['Try injecting <script> tags', 'Look for user input reflection']);

-- Crypto Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints) VALUES
('Caesar Cipher', 'Decode this message: FWI{FDHVDU_FLSKHU}', 'Crypto', 'easy', 150, 'CTF{CAESAR_CIPHER}', ARRAY['This is a simple substitution cipher', 'Try shifting letters by 3 positions']),

('Base64 Decode', 'Decode this Base64 string: Q1RGe2Jhc2U2NF9kZWNvZGluZ30=', 'Crypto', 'easy', 100, 'CTF{base64_decoding}', ARRAY['This looks like Base64 encoding', 'Use an online Base64 decoder']),

('ROT13 Message', 'Decrypt: PGS{ebg13_rapelcgvba}', 'Crypto', 'easy', 120, 'CTF{rot13_encryption}', ARRAY['ROT13 shifts each letter 13 positions', 'A becomes N, B becomes O, etc.']);

-- Forensics Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints) VALUES
('Hidden in Metadata', 'The flag is hidden in the metadata of an image file.', 'Forensics', 'medium', 200, 'CTF{metadata_analysis}', ARRAY['Use exiftool or similar', 'Check EXIF data of images']),

('Network Traffic', 'Analyze the network capture to find the flag.', 'Forensics', 'hard', 400, 'CTF{network_forensics}', ARRAY['Use Wireshark to analyze', 'Look for HTTP traffic']),

('Memory Dump', 'Extract the flag from this memory dump file.', 'Forensics', 'hard', 450, 'CTF{memory_analysis}', ARRAY['Use volatility framework', 'Look for strings in memory']);

-- Reverse Engineering
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints) VALUES
('Simple Crackme', 'Reverse engineer this binary to find the correct password.', 'Reverse', 'medium', 300, 'CTF{reverse_engineering}', ARRAY['Use a disassembler like Ghidra', 'Look for string comparisons']),

('Packed Binary', 'This binary is packed. Unpack it to find the flag.', 'Reverse', 'hard', 500, 'CTF{unpacked_binary}', ARRAY['Detect the packer first', 'Use appropriate unpacking tools']);

-- Pwn Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints) VALUES
('Buffer Overflow', 'Exploit this buffer overflow vulnerability to get the flag.', 'Pwn', 'hard', 400, 'CTF{buffer_overflow_pwn}', ARRAY['Find the buffer size', 'Overwrite the return address']),

('Format String', 'Exploit the format string vulnerability in this program.', 'Pwn', 'insane', 600, 'CTF{format_string_exploit}', ARRAY['Use %x to leak memory', 'Try %n to write to memory']);

-- Misc Challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints) VALUES
('QR Code', 'Scan this QR code to get the flag.', 'Misc', 'easy', 50, 'CTF{qr_code_scanner}', ARRAY['Use a QR code scanner app', 'The image contains a QR code']),

('Steganography', 'The flag is hidden inside this image using steganography.', 'Misc', 'medium', 250, 'CTF{hidden_in_image}', ARRAY['Use steganography tools', 'Try steghide or similar tools']),

('OSINT Challenge', 'Find information about this person using open source intelligence.', 'Misc', 'medium', 200, 'CTF{osint_investigation}', ARRAY['Use Google, social media', 'Check public records']);