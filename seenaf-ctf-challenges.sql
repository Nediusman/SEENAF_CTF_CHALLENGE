-- SEENAF CTF - Comprehensive Challenge Set
-- Run this in Supabase SQL Editor to replace existing challenges with a full CTF challenge set

-- Clear existing challenges
DELETE FROM public.challenges;

-- Insert comprehensive CTF challenges
INSERT INTO public.challenges (title, description, category, difficulty, points, flag, hints, author, instance_url, solver_count, likes_count) VALUES

-- ========== WEB EXPLOITATION CHALLENGES ==========
('Welcome to SEENAF', 'Welcome to SEENAF CTF! Your first challenge is simple - find the flag hidden in this webpage. Sometimes the most obvious places are overlooked.

Visit the challenge page and inspect it carefully. The flag format is SEENAF{...}', 'Web', 'easy', 50, 'SEENAF{welcome_to_seenaf_ctf_2024}', ARRAY['Try viewing the page source', 'Look for HTML comments', 'Check the page title and meta tags'], 'SEENAF Team', 'https://seenafctf.com/welcome', 127, 23),

('Cookie Jar', 'This bakery website stores user preferences in cookies. The admin has a special cookie that might contain something interesting.

Can you modify your cookies to access admin content?', 'Web', 'easy', 100, 'SEENAF{cookie_manipulation_master}', ARRAY['Check your browser cookies', 'Try changing cookie values', 'Look for admin or role cookies'], 'Ahmed Hassan', 'https://seenafctf.com/bakery', 89, 15),

('SQL Injection Basics', 'This login form looks vulnerable to SQL injection. The admin username is "admin" but we don''t know the password.

Can you bypass the authentication using SQL injection?', 'Web', 'medium', 200, 'SEENAF{sql_injection_is_dangerous}', ARRAY['Try using OR 1=1 in the password field', 'Comment out the rest of the query with --', 'Username is "admin", focus on the password'], 'Dr. Sarah Ahmed', 'https://seenafctf.com/login', 67, 12),

('XSS Playground', 'This comment system doesn''t properly sanitize user input. Can you execute JavaScript code to steal the admin''s session cookie?

The admin visits this page every 30 seconds. Your payload needs to send the cookie to your webhook.', 'Web', 'medium', 250, 'SEENAF{xss_cookie_stealer_pro}', ARRAY['Try injecting <script> tags in comments', 'Use document.cookie to access cookies', 'Send the cookie to an external server'], 'Mohamed Ali', 'https://seenafctf.com/comments', 45, 8),

('Directory Traversal', 'This file viewer application lets you view files on the server. It seems to have some path restrictions, but maybe you can bypass them?

Try to read the flag file located at /etc/seenaf/flag.txt', 'Web', 'medium', 300, 'SEENAF{directory_traversal_master}', ARRAY['Try using ../ to go up directories', 'URL encode your payload', 'The flag is in /etc/seenaf/flag.txt'], 'Fatima Al-Zahra', 'https://seenafctf.com/fileviewer', 34, 6),

('Command Injection', 'This network diagnostic tool lets you ping any IP address. However, it might be executing your input directly in the shell.

Can you execute additional commands to find the flag?', 'Web', 'hard', 400, 'SEENAF{command_injection_pwned}', ARRAY['Try using ; or && to chain commands', 'Look for the flag file with ls or find', 'Common locations: /tmp, /var, /home'], 'Omar Khalil', 'https://seenafctf.com/ping', 23, 4),

('JWT Token Manipulation', 'This application uses JWT tokens for authentication. You have a regular user token, but you need admin access.

The JWT secret might be weak or the algorithm might be exploitable.', 'Web', 'hard', 450, 'SEENAF{jwt_algorithm_confusion}', ARRAY['Decode the JWT token first', 'Try changing the algorithm to "none"', 'Look for weak secrets like "secret" or "password"'], 'Layla Mansour', 'https://seenafctf.com/jwt-app', 18, 3),

-- ========== CRYPTOGRAPHY CHALLENGES ==========
('Caesar Salad', 'Julius Caesar used this cipher to protect his military communications. Can you decode this message?

Encrypted message: VHHQDI{FDHVDU_FLSKHU_LV_HDVB}', 'Crypto', 'easy', 100, 'SEENAF{CAESAR_CIPHER_IS_EASY}', ARRAY['This is a Caesar cipher with a shift', 'Try shifting each letter by 3 positions', 'A becomes D, B becomes E, etc.'], 'SEENAF Team', NULL, 156, 28),

('Base64 Buffet', 'This message has been encoded with Base64. Can you decode it to reveal the flag?

Encoded message: U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=', 'Crypto', 'easy', 75, 'SEENAF{base64_is_not_encryption}', ARRAY['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding at the end'], 'Yusuf Ibrahim', NULL, 134, 22),

('ROT13 Restaurant', 'The chef encoded the secret recipe using ROT13. Can you decode it?

Encoded recipe: FRRANS{ebg13_vf_whfg_n_pnrfne_pvcure}', 'Crypto', 'easy', 80, 'SEENAF{rot13_is_just_a_caesar_cipher}', ARRAY['ROT13 shifts each letter by 13 positions', 'A becomes N, B becomes O, etc.', 'Try an online ROT13 decoder'], 'Chef Amina', NULL, 98, 18),

('Frequency Analysis', 'This message was encrypted with a simple substitution cipher. Use frequency analysis to crack it.

DRRQLS{SERWRQPB_LQLUBDVD_VD_CMSRESLQE}

Hint: E is the most common letter in English.', 'Crypto', 'medium', 250, 'SEENAF{FREQUENCY_ANALYSIS_IS_POWERFUL}', ARRAY['Count letter frequencies in the ciphertext', 'E is the most common letter in English', 'Look for common patterns like "THE" and "AND"'], 'Dr. Nadia Farouk', NULL, 67, 11),

('Vigenère Cipher', 'This message was encrypted using a Vigenère cipher with the key "SEENAF".

Encrypted: SEENAF{KQGQVKW_UQJLWV_QD_UVKQTM}

The flag format is still SEENAF{...}', 'Crypto', 'medium', 300, 'SEENAF{VIGENERE_CIPHER_IS_STRONG}', ARRAY['The key is "SEENAF"', 'Vigenère uses a repeating key', 'Try an online Vigenère decoder'], 'Khalid Al-Rashid', NULL, 45, 8),

('RSA Beginner', 'You intercepted an RSA encrypted message. The public key parameters are small enough to factor.

n = 323, e = 5, c = 144

Find the private key and decrypt the message.', 'Crypto', 'hard', 400, 'SEENAF{rsa_small_primes_are_weak}', ARRAY['Factor n = 323 into two primes', 'Calculate φ(n) = (p-1)(q-1)', 'Find d such that e*d ≡ 1 (mod φ(n))'], 'Prof. Hassan Mahmoud', NULL, 29, 5),

('Hash Collision', 'Find two different inputs that produce the same MD5 hash as "SEENAF2024".

MD5("SEENAF2024") = 7d4a8d09ca3762af61e59520943dc26494f8941b

Submit the flag format: SEENAF{input1_input2}', 'Crypto', 'insane', 500, 'SEENAF{rainbow_table_collision}', ARRAY['Use rainbow tables or hash collision tools', 'MD5 is cryptographically broken', 'Look for online MD5 collision generators'], 'Dr. Amira Zaki', NULL, 12, 2),

-- ========== FORENSICS CHALLENGES ==========
('Hidden Message', 'This image looks innocent, but there''s a hidden message inside. Can you find it?

Download the image and analyze it carefully.', 'Forensics', 'easy', 150, 'SEENAF{steganography_in_images}', ARRAY['Use steganography tools like steghide', 'Try strings command on the image', 'Check the image metadata with exiftool'], 'Mariam Youssef', 'https://seenafctf.com/files/innocent.jpg', 78, 14),

('Memory Dump Analysis', 'We captured the memory of a compromised system. The attacker left traces in the memory.

Analyze the memory dump to find the flag.', 'Forensics', 'medium', 300, 'SEENAF{memory_forensics_expert}', ARRAY['Use Volatility framework', 'Look for suspicious processes', 'Check for injected code or strings'], 'Cyber Forensics Team', 'https://seenafctf.com/files/memory.dmp', 34, 6),

('Network Traffic', 'We captured network traffic during a cyber attack. The flag was transmitted during the attack.

Analyze the PCAP file to find the flag.', 'Forensics', 'medium', 350, 'SEENAF{network_packet_analysis}', ARRAY['Use Wireshark to analyze the PCAP', 'Look for HTTP POST requests', 'Check for base64 encoded data'], 'Network Security Team', 'https://seenafctf.com/files/traffic.pcap', 41, 7),

('Deleted Files Recovery', 'Important files were deleted from this disk image. Can you recover the flag file?

The flag was in a file called "secret.txt".', 'Forensics', 'hard', 400, 'SEENAF{file_recovery_master}', ARRAY['Use forensic tools like Autopsy or Sleuth Kit', 'Look for deleted files', 'The file was named "secret.txt"'], 'Digital Forensics Lab', 'https://seenafctf.com/files/disk.img', 26, 4),

-- ========== REVERSE ENGINEERING CHALLENGES ==========
('Simple Crackme', 'This program asks for a password. Find the correct password to get the flag.

The binary is not packed or obfuscated.', 'Reverse', 'easy', 200, 'SEENAF{reverse_engineering_basics}', ARRAY['Use a disassembler like Ghidra or IDA', 'Look for string comparisons', 'The password might be hardcoded'], 'Reverse Engineering Team', 'https://seenafctf.com/files/crackme1', 56, 10),

('Anti-Debug', 'This program has anti-debugging techniques. Can you bypass them and find the flag?

The program detects debuggers and changes its behavior.', 'Reverse', 'medium', 350, 'SEENAF{anti_debug_bypassed}', ARRAY['Patch the anti-debug checks', 'Use static analysis instead of dynamic', 'Look for IsDebuggerPresent() calls'], 'Advanced RE Team', 'https://seenafctf.com/files/antidebug', 32, 6),

('Packed Binary', 'This binary is packed with UPX. Unpack it and find the flag.

The real program is hidden inside the packer.', 'Reverse', 'medium', 300, 'SEENAF{unpacked_successfully}', ARRAY['Detect the packer first', 'Use upx -d to unpack', 'Analyze the unpacked binary'], 'Malware Analysis Team', 'https://seenafctf.com/files/packed.exe', 28, 5),

('Keygen Challenge', 'Create a keygen for this software. The flag is the algorithm used for key generation.

Valid keys follow a specific mathematical pattern.', 'Reverse', 'hard', 450, 'SEENAF{keygen_algorithm_cracked}', ARRAY['Analyze the key validation function', 'Look for mathematical operations', 'Test multiple valid keys to find the pattern'], 'Software Security Team', 'https://seenafctf.com/files/keygen-me', 19, 3),

-- ========== PWN/BINARY EXPLOITATION CHALLENGES ==========
('Stack Overflow 101', 'This program has a buffer overflow vulnerability. Exploit it to get the flag.

The program runs on the server and you need to get shell access.', 'Pwn', 'medium', 300, 'SEENAF{buffer_overflow_pwned}', ARRAY['Find the buffer size with pattern_create', 'Overwrite the return address', 'Use a ret2win or ret2libc technique'], 'Binary Exploitation Team', 'https://seenafctf.com/pwn/stack1', 38, 7),

('Format String Bug', 'This program has a format string vulnerability. Exploit it to read the flag from memory.

The flag is stored in a global variable.', 'Pwn', 'medium', 350, 'SEENAF{format_string_leak}', ARRAY['Use %x to leak memory addresses', 'Use %s to read strings from memory', 'The flag is at a fixed memory location'], 'Pwn Team Alpha', 'https://seenafctf.com/pwn/format1', 25, 4),

('Return to Libc', 'ASLR and NX are enabled on this system. Use return-to-libc to get a shell.

You need to leak libc addresses first.', 'Pwn', 'hard', 450, 'SEENAF{ret2libc_master}', ARRAY['Leak libc addresses first', 'Calculate system() and "/bin/sh" addresses', 'Chain ROP gadgets carefully'], 'Advanced Pwn Team', 'https://seenafctf.com/pwn/ret2libc', 16, 2),

('Heap Exploitation', 'This program has a use-after-free vulnerability in heap management.

Exploit it to get arbitrary code execution.', 'Pwn', 'insane', 500, 'SEENAF{heap_exploitation_god}', ARRAY['Understand the heap layout', 'Trigger the use-after-free bug', 'Overwrite function pointers'], 'Elite Pwn Team', 'https://seenafctf.com/pwn/heap1', 8, 1),

-- ========== MISCELLANEOUS CHALLENGES ==========
('QR Code Hunt', 'This QR code contains the flag. Scan it to reveal the secret.

Sometimes the simplest solutions are the best.', 'Misc', 'easy', 50, 'SEENAF{qr_codes_are_everywhere}', ARRAY['Use a QR code scanner app', 'Try online QR code decoders', 'The image might need to be cleaned up first'], 'SEENAF Team', 'https://seenafctf.com/files/qrcode.png', 145, 26),

('OSINT Investigation', 'Find information about the fictional company "CyberTech Solutions" founded in 2020.

The flag is hidden in their public social media posts from March 2024.', 'Misc', 'easy', 100, 'SEENAF{osint_social_media_master}', ARRAY['Search for "CyberTech Solutions" on social media', 'Look at posts from March 2024', 'Check Twitter, LinkedIn, and Facebook'], 'OSINT Team', NULL, 87, 16),

('Audio Steganography', 'This audio file sounds normal, but there''s a hidden message encoded in it.

The message is encoded using LSB steganography.', 'Misc', 'medium', 250, 'SEENAF{audio_steganography_decoded}', ARRAY['Use audio steganography tools', 'Try Audacity to analyze the waveform', 'Look for LSB encoding in the audio data'], 'Audio Forensics Team', 'https://seenafctf.com/files/hidden_message.wav', 43, 8),

('Zip File Password', 'This ZIP file is password protected. The password is related to SEENAF.

Hint: It''s a combination of "SEENAF" and the current year.', 'Misc', 'easy', 75, 'SEENAF{zip_password_cracked}', ARRAY['Try combinations with SEENAF and 2024', 'Common patterns: SEENAF2024, seenaf2024', 'Use zip password crackers if needed'], 'Archive Team', 'https://seenafctf.com/files/protected.zip', 92, 17),

('Blockchain Puzzle', 'This Ethereum smart contract has a vulnerability. Find it and extract the flag.

Contract address: 0x742d35Cc6634C0532925a3b8D0C9e3e4c413c123', 'Misc', 'hard', 400, 'SEENAF{smart_contract_hacked}', ARRAY['Analyze the smart contract code', 'Look for reentrancy or overflow bugs', 'Use tools like Remix or Mythril'], 'Blockchain Security Team', 'https://etherscan.io/address/0x742d35Cc6634C0532925a3b8D0C9e3e4c413c123', 21, 3),

('Machine Learning Model', 'This AI model classifies images, but it has a backdoor. Find the trigger pattern that reveals the flag.

The model was trained with a hidden trigger.', 'Misc', 'insane', 500, 'SEENAF{ai_backdoor_discovered}', ARRAY['Test different input patterns', 'Look for adversarial examples', 'The trigger might be a specific pixel pattern'], 'AI Security Research', 'https://seenafctf.com/ai/model', 7, 1),

-- ========== SEENAF SPECIAL CHALLENGES ==========
('SEENAF History', 'Learn about SEENAF''s mission and find the flag hidden in our story.

Visit our about page and read carefully about our cybersecurity initiatives.', 'Misc', 'easy', 25, 'SEENAF{cybersecurity_education_matters}', ARRAY['Visit the SEENAF about page', 'Read about our cybersecurity programs', 'The flag is hidden in the mission statement'], 'SEENAF Founders', 'https://seenaf.org/about', 203, 35),

('SEENAF Cipher', 'We created a custom cipher based on the SEENAF acronym. Can you decode this message?

Encrypted: SNFAEE{NFAEES_MOCTUS_RPHECI}

Hint: Think about what SEENAF stands for.', 'Crypto', 'medium', 200, 'SEENAF{SEENAF_CUSTOM_CIPHER}', ARRAY['SEENAF stands for something specific', 'Use the letters S-E-E-N-A-F as a key', 'It''s a substitution cipher based on our name'], 'SEENAF Crypto Team', NULL, 54, 9);

-- Update some realistic solver counts based on difficulty
UPDATE public.challenges SET solver_count = 
  CASE 
    WHEN difficulty = 'easy' THEN FLOOR(RANDOM() * 100 + 50)
    WHEN difficulty = 'medium' THEN FLOOR(RANDOM() * 50 + 20)
    WHEN difficulty = 'hard' THEN FLOOR(RANDOM() * 30 + 10)
    WHEN difficulty = 'insane' THEN FLOOR(RANDOM() * 15 + 5)
  END;

UPDATE public.challenges SET likes_count = FLOOR(solver_count * 0.2 + RANDOM() * 10);

-- Show the results
SELECT 
  'SEENAF CTF Challenges Created!' as status,
  COUNT(*) as total_challenges,
  COUNT(CASE WHEN difficulty = 'easy' THEN 1 END) as easy_challenges,
  COUNT(CASE WHEN difficulty = 'medium' THEN 1 END) as medium_challenges,
  COUNT(CASE WHEN difficulty = 'hard' THEN 1 END) as hard_challenges,
  COUNT(CASE WHEN difficulty = 'insane' THEN 1 END) as insane_challenges,
  COUNT(CASE WHEN category = 'Web' THEN 1 END) as web_challenges,
  COUNT(CASE WHEN category = 'Crypto' THEN 1 END) as crypto_challenges,
  COUNT(CASE WHEN category = 'Forensics' THEN 1 END) as forensics_challenges,
  COUNT(CASE WHEN category = 'Reverse' THEN 1 END) as reverse_challenges,
  COUNT(CASE WHEN category = 'Pwn' THEN 1 END) as pwn_challenges,
  COUNT(CASE WHEN category = 'Misc' THEN 1 END) as misc_challenges
FROM public.challenges;

-- Show sample challenges by category
SELECT category, COUNT(*) as count, 
       MIN(points) as min_points, 
       MAX(points) as max_points,
       ROUND(AVG(points)) as avg_points
FROM public.challenges 
GROUP BY category 
ORDER BY category;