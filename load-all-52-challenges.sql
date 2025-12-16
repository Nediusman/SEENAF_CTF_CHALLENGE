-- Load All 52 SEENAF_CTF Challenges
-- Run this AFTER running direct-admin-fix.sql

-- Clear existing challenges
DELETE FROM public.challenges;

-- Insert all 52 challenges
INSERT INTO public.challenges (
    title, description, category, difficulty, points, flag, hints, is_active
) VALUES 
-- Web Security Challenges (7)
('Inspect HTML', 'Can you find the flag that''s hiding in this webpage?

This is a basic web challenge where you need to examine the HTML source code of a webpage to find a hidden flag.', 'Web', 'easy', 100, 'SEENAF{1nsp3ct_th3_html_s0urc3}', ARRAY['Try right-clicking and selecting "View Page Source"', 'Look for HTML comments', 'The flag might be in a hidden div or comment'], true),

('Cookies', 'I heard you like cookies. Nom nom nom.

This challenge involves manipulating browser cookies to access restricted content.', 'Web', 'easy', 150, 'SEENAF{c00k13_m0nst3r_0mg}', ARRAY['Check your browser''s cookies for this site', 'Try changing cookie values', 'Look for cookies named "admin" or "role"'], true),

('SQL Injection', 'Login as the admin user to get the flag.

This login form is vulnerable to SQL injection. The admin username is "admin".', 'Web', 'medium', 250, 'SEENAF{sql_1nj3ct10n_1s_d4ng3r0us}', ARRAY['Try SQL injection in the password field', 'Use OR 1=1 to bypass authentication', 'Comment out the rest of the query with --'], true),

('XSS Playground', 'This comment system doesn''t properly sanitize user input. Can you execute JavaScript code?

Find a way to execute JavaScript in the comment system.', 'Web', 'medium', 300, 'SEENAF{xss_4tt4ck_succ3ssful}', ARRAY['Try injecting <script> tags in comments', 'Use alert() to test XSS', 'Look for input fields that reflect user data'], true),

('JWT Token Manipulation', 'This application uses JWT tokens for authentication. Can you forge an admin token?

Analyze and manipulate JWT tokens to gain unauthorized access.', 'Web', 'hard', 400, 'SEENAF{jwt_f0rg3ry_m4st3r}', ARRAY['Decode the JWT token', 'Try the "none" algorithm attack', 'Look for weak signing keys'], true),

('SSRF Exploitation', 'This web application fetches external resources. Can you make it fetch internal resources?

Exploit Server-Side Request Forgery to access internal services.', 'Web', 'hard', 350, 'SEENAF{ssrf_1nt3rn4l_4cc3ss}', ARRAY['Try accessing localhost URLs', 'Use different protocols (file://, gopher://)', 'Bypass IP filtering with different encodings'], true),

('Directory Traversal', 'This file viewer has a path traversal vulnerability. Can you read sensitive files?

Use directory traversal techniques to access files outside the web root.', 'Web', 'medium', 200, 'SEENAF{d1r3ct0ry_tr4v3rs4l_pwn}', ARRAY['Try ../ sequences', 'Look for /etc/passwd or similar files', 'Use URL encoding to bypass filters'], true),

-- Cryptography Challenges (7)
('The Numbers', 'The numbers... what do they mean?

13 9 3 15 3 20 6 { 20 8 5 14 21 13 2 5 18 19 13 1 19 15 14 }', 'Crypto', 'easy', 100, 'SEENAF{THENUMBERSMASON}', ARRAY['These look like numbers representing letters', 'A=1, B=2, C=3, etc.', 'Convert each number to its corresponding letter'], true),

('Caesar', 'Decrypt this message that was encrypted with a Caesar cipher.

VHHQDI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}', 'Crypto', 'easy', 150, 'SEENAF{CAESAR_CIPHER_IS_EASY_PEASY}', ARRAY['This is a Caesar cipher', 'Try different shift values', 'The shift is likely 3 (classic Caesar)'], true),

('Base64 Basics', 'Decode this Base64 encoded message to find the flag.

U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=', 'Crypto', 'easy', 75, 'SEENAF{base64_is_not_encryption}', ARRAY['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding at the end'], true),

('ROT13 Message', 'Decrypt this ROT13 encoded message.

FRRANS{ebg13_vf_whfg_n_pnrfne_pvcure}', 'Crypto', 'easy', 120, 'SEENAF{rot13_is_just_a_caesar_cipher}', ARRAY['ROT13 shifts each letter by 13 positions', 'A becomes N, B becomes O, etc.', 'Try an online ROT13 decoder'], true),

('RSA Weak Keys', 'This RSA implementation uses weak parameters. Can you factor the modulus?

Exploit weak RSA key generation to decrypt the message.', 'Crypto', 'hard', 450, 'SEENAF{rs4_w34k_k3ys_pwn3d}', ARRAY['Check if the modulus is small', 'Try factoring with online tools', 'Look for common factors between keys'], true),

('Hash Length Extension', 'This application uses a vulnerable hash construction. Can you extend the hash?

Exploit hash length extension attacks to forge valid signatures.', 'Crypto', 'hard', 375, 'SEENAF{h4sh_3xt3ns10n_4tt4ck}', ARRAY['Use hash_extender tool', 'You need to know the secret length', 'Append your payload to the original message'], true),

('Vigenère Cipher', 'Decrypt this Vigenère cipher to find the flag.

FRRANS{i1t3n3r3_p1cu3r_1f_3nfb_c34fb}', 'Crypto', 'medium', 200, 'SEENAF{vigenere_cipher_is_easy_peasy}', ARRAY['Try frequency analysis', 'The key might be a common word', 'Use online Vigenère solvers'], true),

-- Forensics Challenges (12)
('File Extensions', 'This file doesn''t seem to be what it appears to be.

Download the file and determine its real type to extract the flag.', 'Forensics', 'easy', 100, 'SEENAF{f1l3_3xt3ns10ns_l13}', ARRAY['Use the "file" command to check the real file type', 'The extension might be misleading', 'Try opening with different programs'], true),

('Hidden Message', 'This image looks innocent, but there''s a hidden message inside.

Use steganography tools to find the hidden flag.', 'Forensics', 'medium', 200, 'SEENAF{st3g4n0gr4phy_m4st3r}', ARRAY['Use steganography tools like steghide', 'Try the strings command on the image', 'Check the image metadata with exiftool'], true),

('Wireshark Analysis', 'Can you find the flag in this network capture?

Analyze the PCAP file to find suspicious network traffic containing the flag.', 'Forensics', 'medium', 250, 'SEENAF{n3tw0rk_tr4ff1c_4n4lys1s}', ARRAY['Use Wireshark to open the PCAP file', 'Look for HTTP traffic', 'Check POST requests and form data'], true),

('Memory Dump', 'We captured the memory of a compromised system. The attacker left traces.

Analyze the memory dump to find the flag.', 'Forensics', 'hard', 350, 'SEENAF{m3m0ry_f0r3ns1cs_3xp3rt}', ARRAY['Use Volatility framework', 'Look for suspicious processes', 'Check for injected code or strings'], true),

('Disk Image Analysis', 'We recovered a disk image from a suspect''s computer. Find the hidden evidence.

Use disk forensics tools to analyze the filesystem and recover deleted files.', 'Forensics', 'medium', 275, 'SEENAF{d1sk_f0r3ns1cs_m4st3r}', ARRAY['Use tools like Autopsy or FTK Imager', 'Look for deleted files in unallocated space', 'Check file system journals and logs'], true),

('PDF Malware', 'This PDF file contains malicious code. Analyze it to find the flag.

Use PDF analysis tools to examine the structure and extract embedded objects.', 'Forensics', 'hard', 400, 'SEENAF{pdf_m4lw4r3_4n4lys1s}', ARRAY['Use pdf-parser or peepdf tools', 'Look for JavaScript or embedded files', 'Check for suspicious streams and objects'], true),

('Registry Forensics', 'The Windows registry contains traces of malicious activity. Find the evidence.

Analyze Windows registry hives to find traces of malware persistence.', 'Forensics', 'medium', 225, 'SEENAF{r3g1stry_hunt3r_pr0}', ARRAY['Use RegRipper or Registry Explorer', 'Check Run keys for persistence', 'Look for unusual services and startup entries'], true),

('Mobile Forensics', 'We extracted data from a suspect''s Android device. Find the smoking gun.

Analyze mobile device artifacts including SMS, call logs, and app data.', 'Forensics', 'hard', 375, 'SEENAF{m0b1l3_f0r3ns1cs_n1nj4}', ARRAY['Look in SQLite databases', 'Check messaging app databases', 'Examine deleted SMS and call records'], true),

('Audio Steganography', 'This audio file sounds normal, but it hides a secret message.

Use audio analysis tools to find the hidden data in the sound file.', 'Forensics', 'medium', 200, 'SEENAF{4ud10_st3g0_m4st3r}', ARRAY['Use Audacity or SoX for analysis', 'Check the spectrogram view', 'Look for LSB steganography in audio samples'], true),

('Zip Password', 'This password-protected ZIP file contains the flag. Can you crack it?

Use password cracking techniques to break into the encrypted archive.', 'Forensics', 'easy', 125, 'SEENAF{z1p_cr4ck1ng_3z}', ARRAY['Try common passwords first', 'Use John the Ripper or hashcat', 'The password might be in a wordlist'], true),

('Timeline Analysis', 'Create a timeline of events from these log files to find when the breach occurred.

Analyze system logs to reconstruct the attack timeline.', 'Forensics', 'hard', 325, 'SEENAF{t1m3l1n3_4n4lyst_pr0}', ARRAY['Use log2timeline or Plaso', 'Look for authentication failures', 'Check for file access patterns'], true),

('Malware Strings', 'This malware sample contains interesting strings. Find the flag hidden in the binary.

Use static analysis to extract strings from the malware executable.', 'Forensics', 'easy', 150, 'SEENAF{str1ngs_4r3_y0ur_fr13nd}', ARRAY['Use the strings command', 'Look for base64 encoded data', 'Check for URLs and file paths'], true),

('Email Headers', 'This phishing email contains clues about its origin. Analyze the headers.

Examine email headers to trace the source and find hidden information.', 'Forensics', 'medium', 175, 'SEENAF{3m41l_h34d3r_d3t3ct1v3}', ARRAY['Check the Received headers', 'Look for spoofed sender information', 'Examine X-Originating-IP headers'], true),

('Database Recovery', 'This corrupted SQLite database contains sensitive information. Recover the flag.

Use database recovery techniques to extract data from the damaged file.', 'Forensics', 'hard', 300, 'SEENAF{db_r3c0v3ry_3xp3rt}', ARRAY['Use SQLite recovery tools', 'Check for deleted records', 'Look in unallocated database pages'], true),

('QR Code Forensics', 'This damaged QR code contains the flag. Can you repair and decode it?

Use image processing techniques to restore the corrupted QR code.', 'Forensics', 'medium', 180, 'SEENAF{qr_c0d3_r3p41r_n1nj4}', ARRAY['Use image editing software to repair damage', 'QR codes have error correction', 'Try different QR code readers'], true),

-- Network Analysis Challenges (6)
('What''s a NET?', 'How about you find the flag in this network capture?

Basic network analysis challenge - find the flag in HTTP traffic.', 'Network', 'easy', 100, 'SEENAF{n3tw0rk_b4s1cs_ftw}', ARRAY['Use Wireshark to analyze the PCAP', 'Look for HTTP GET/POST requests', 'The flag might be in plain text'], true),

('Shark on Wire 1', 'We found this packet capture. Recover the flag.

Intermediate network forensics - the flag is encoded or hidden in the traffic.', 'Network', 'medium', 200, 'SEENAF{sh4rk_0n_w1r3_1s_c00l}', ARRAY['Use Wireshark''s "Follow TCP Stream" feature', 'Look for base64 encoded data', 'Check different protocols (HTTP, FTP, etc.)'], true),

('DNS Exfiltration', 'Data was exfiltrated through DNS queries. Can you recover it?

Analyze DNS traffic to find the hidden data.', 'Network', 'medium', 250, 'SEENAF{dns_3xf1ltr4t10n_d3t3ct3d}', ARRAY['Look for unusual DNS queries', 'Check for data encoded in subdomain names', 'The data might be base64 encoded'], true),

('TFTP Transfer', 'Figure out how they moved the flag using TFTP.

This challenge involves analyzing TFTP (Trivial File Transfer Protocol) traffic.', 'Network', 'hard', 300, 'SEENAF{tftp_f1l3_tr4nsf3r_pwn3d}', ARRAY['Look for TFTP traffic in the capture', 'TFTP uses UDP port 69', 'Extract the transferred file'], true),

('WiFi Handshake', 'We captured a WiFi handshake. Can you crack the password?

Use wireless security tools to crack the WPA2 handshake.', 'Network', 'medium', 275, 'SEENAF{w1f1_h4ndsh4k3_cr4ck3d}', ARRAY['Use aircrack-ng with a wordlist', 'The password might be weak', 'Try common WiFi passwords'], true),

('Bluetooth Analysis', 'This Bluetooth capture contains sensitive data. Find the flag.

Analyze Bluetooth Low Energy (BLE) traffic to extract hidden information.', 'Network', 'hard', 325, 'SEENAF{blu3t00th_sn1ff3r_pr0}', ARRAY['Use Wireshark with Bluetooth support', 'Look for GATT characteristics', 'Check for unencrypted data transfers'], true),

-- Reverse Engineering Challenges (6)
('Simple Crackme', 'This binary asks for a password. Can you find it without running the program?

Reverse engineer the binary to find the correct password.', 'Reverse', 'easy', 150, 'SEENAF{r3v3rs3_3ng1n33r1ng_b4s1cs}', ARRAY['Use strings command first', 'Try a disassembler like Ghidra', 'Look for string comparisons'], true),

('Assembly Analysis', 'This assembly code contains the flag. Can you trace through the execution?

Analyze the assembly instructions to understand the program flow.', 'Reverse', 'medium', 225, 'SEENAF{4ss3mbly_4n4lys1s_pr0}', ARRAY['Follow the jumps and branches', 'Track register values', 'Look for XOR operations'], true),

('Packed Binary', 'This binary is packed with UPX. Unpack it and find the flag.

Use unpacking tools to reveal the original binary.', 'Reverse', 'medium', 275, 'SEENAF{unp4ck3d_b1n4ry_succ3ss}', ARRAY['Use UPX unpacker', 'Try upx -d command', 'Analyze the unpacked binary'], true),

('Anti-Debug', 'This binary has anti-debugging techniques. Bypass them to get the flag.

Defeat anti-debugging measures to analyze the program.', 'Reverse', 'hard', 400, 'SEENAF{4nt1_d3bug_byp4ss3d}', ARRAY['Patch the anti-debug checks', 'Use advanced debugging techniques', 'Look for IsDebuggerPresent calls'], true),

('Obfuscated Code', 'This code is heavily obfuscated. Can you deobfuscate it to find the flag?

Reverse engineer obfuscated code to reveal its true purpose.', 'Reverse', 'hard', 375, 'SEENAF{d30bfusc4t3d_c0d3_m4st3r}', ARRAY['Look for string decryption routines', 'Trace through the obfuscation layers', 'Use dynamic analysis'], true),

('Keygen Challenge', 'Create a keygen for this software. The flag is a valid serial number.

Reverse engineer the key validation algorithm.', 'Reverse', 'hard', 450, 'SEENAF{k3yg3n_4lg0r1thm_cr4ck3d}', ARRAY['Find the key validation function', 'Understand the algorithm', 'Generate a valid key'], true),

-- Binary Exploitation Challenges (3)
('Buffer Overflow', 'This program has a buffer overflow vulnerability. Exploit it to get the flag.

Craft a payload to overflow the buffer and control program execution.', 'Pwn', 'hard', 500, 'SEENAF{buff3r_0v3rfl0w_pwn3d}', ARRAY['Find the offset to overwrite return address', 'Use a debugger like GDB', 'Look for a win() function or similar'], true),

('Format String', 'This program has a format string vulnerability. Can you exploit it?

Use format string bugs to read memory and potentially execute code.', 'Pwn', 'hard', 450, 'SEENAF{f0rm4t_str1ng_3xpl01t}', ARRAY['Use %x to read stack values', 'Try %s to read strings from memory', 'Use %n to write to memory'], true),

-- OSINT Challenges (3)
('Social Media Hunt', 'Find information about the user "hackerman2024" across social media platforms.

Use open source intelligence techniques to gather information.', 'OSINT', 'medium', 200, 'SEENAF{0s1nt_s0c14l_m3d14_hunt3r}', ARRAY['Check multiple social media platforms', 'Look for linked accounts', 'Use reverse image search'], true),

('Geolocation', 'This photo was taken at a secret location. Can you find where?

Use image analysis and geolocation techniques to identify the location.', 'OSINT', 'hard', 350, 'SEENAF{g30l0c4t10n_m4st3r}', ARRAY['Check EXIF data for GPS coordinates', 'Use reverse image search', 'Look for landmarks or distinctive features'], true),

('Username Investigation', 'Investigate the username "cyb3r_gh0st_2024" and find their real identity.

Use OSINT techniques to trace digital footprints.', 'OSINT', 'medium', 225, 'SEENAF{us3rn4m3_tr4c3d_succ3ss}', ARRAY['Search across multiple platforms', 'Check for password breaches', 'Look for email patterns'], true),

-- Steganography Challenges (4)
('LSB Steganography', 'This image hides a message in its least significant bits.

Extract the hidden message using LSB steganography techniques.', 'Stego', 'easy', 125, 'SEENAF{lsb_st3g0_3xtr4ct3d}', ARRAY['Use stegsolve or similar tools', 'Check the least significant bits', 'Try different color channels'], true),

('Audio Frequency', 'This audio file contains a hidden message in specific frequencies.

Analyze the audio spectrum to find the hidden data.', 'Stego', 'medium', 200, 'SEENAF{4ud10_fr3qu3ncy_h1dd3n}', ARRAY['Use Audacity or similar audio tools', 'Check the spectrogram', 'Look for patterns in specific frequencies'], true),

('Polyglot File', 'This file is both a valid image and contains hidden data.

Find the hidden content in this polyglot file.', 'Stego', 'hard', 325, 'SEENAF{p0lygl0t_f1l3_m4st3r}', ARRAY['Check file headers and footers', 'Look for embedded files', 'Use hexdump to analyze structure'], true),

('Text Steganography', 'This text document contains a hidden message using whitespace steganography.

Find the message hidden in spaces and tabs.', 'Stego', 'medium', 175, 'SEENAF{wh1t3sp4c3_st3g0_pr0}', ARRAY['Look at whitespace characters', 'Check for patterns in spaces and tabs', 'Use a hex editor'], true),

-- Miscellaneous Challenges (4)
('Programming Logic', 'Solve this programming puzzle to get the flag.

Implement the correct algorithm to generate the flag.', 'Misc', 'medium', 200, 'SEENAF{pr0gr4mm1ng_l0g1c_s0lv3d}', ARRAY['Understand the algorithm requirements', 'Test with sample inputs', 'Look for mathematical patterns'], true),

('Esoteric Language', 'This code is written in an esoteric programming language. Execute it to get the flag.

Decode and execute this unusual programming language.', 'Misc', 'hard', 300, 'SEENAF{3s0t3r1c_l4ngu4g3_m4st3r}', ARRAY['Identify the programming language', 'Find an online interpreter', 'Common esoteric languages: Brainfuck, Whitespace, Malbolge'], true),

('Game Hacking', 'This simple game has a high score system. Can you hack it to get the flag?

Modify the game to achieve an impossible score.', 'Misc', 'medium', 250, 'SEENAF{g4m3_h4ck1ng_ch4mp10n}', ARRAY['Inspect the game files', 'Look for score validation', 'Try memory editing or file modification'], true),

('QR Code Puzzle', 'These QR codes form a puzzle. Solve it to get the flag.

Combine multiple QR codes to reveal the hidden message.', 'Misc', 'easy', 100, 'SEENAF{qr_c0d3_puzzl3_s0lv3d}', ARRAY['Scan all QR codes', 'Look for patterns or sequences', 'Combine the decoded messages'], true);

-- Verify all challenges were loaded
SELECT 
    'All Challenges Loaded!' as status,
    COUNT(*) as total_challenges,
    COUNT(CASE WHEN category = 'Web' THEN 1 END) as web_challenges,
    COUNT(CASE WHEN category = 'Crypto' THEN 1 END) as crypto_challenges,
    COUNT(CASE WHEN category = 'Forensics' THEN 1 END) as forensics_challenges,
    COUNT(CASE WHEN category = 'Network' THEN 1 END) as network_challenges,
    COUNT(CASE WHEN category = 'Reverse' THEN 1 END) as reverse_challenges,
    COUNT(CASE WHEN category = 'Pwn' THEN 1 END) as pwn_challenges,
    COUNT(CASE WHEN category = 'OSINT' THEN 1 END) as osint_challenges,
    COUNT(CASE WHEN category = 'Stego' THEN 1 END) as stego_challenges,
    COUNT(CASE WHEN category = 'Misc' THEN 1 END) as misc_challenges
FROM public.challenges;