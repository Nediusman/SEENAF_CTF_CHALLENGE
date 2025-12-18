-- COMPLETE CHALLENGE SETUP - Run this in Supabase SQL Editor
-- This will create the challenges table and load all 52 challenges

-- Step 1: Create challenges table if it doesn't exist
CREATE TABLE IF NOT EXISTS challenges (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard', 'insane')),
    points INTEGER NOT NULL DEFAULT 100,
    flag TEXT NOT NULL,
    hints TEXT[],
    author TEXT,
    instance_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 2: Clear existing challenges (if any)
DELETE FROM challenges;

-- Step 3: Insert all 52 challenges
INSERT INTO challenges (title, description, category, difficulty, points, flag, hints, author, instance_url, is_active) VALUES

-- WEB SECURITY CHALLENGES (7)
('SQL Injection Basics', 'Find the hidden flag by exploiting a SQL injection vulnerability in the login form. The application uses a simple SELECT query to authenticate users.', 'Web', 'easy', 100, 'SEENAF{sql_injection_is_dangerous}', ARRAY['Try using single quotes to break the query', 'Look for ways to bypass authentication', 'Use OR 1=1 to make the condition always true'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/sqli-basic', true),

('XSS Reflected', 'Exploit a reflected Cross-Site Scripting vulnerability to steal the admin''s session cookie. The search parameter is not properly sanitized.', 'Web', 'easy', 150, 'SEENAF{xss_cookie_theft_success}', ARRAY['The search parameter is reflected in the page', 'Try injecting JavaScript code', 'Use document.cookie to access cookies'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/xss-reflected', true),

('Command Injection', 'The ping utility allows you to test network connectivity, but it might be vulnerable to command injection. Can you execute arbitrary commands?', 'Web', 'medium', 200, 'SEENAF{command_injection_pwned}', ARRAY['Try chaining commands with ; or &&', 'Look for ways to execute system commands', 'The flag might be in a file on the server'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/cmd-injection', true),

('File Upload Bypass', 'Upload a file to get the flag, but the application has file type restrictions. Can you bypass the upload filter?', 'Web', 'medium', 250, 'SEENAF{file_upload_filter_bypassed}', ARRAY['Try different file extensions', 'Look at the MIME type validation', 'Consider using double extensions'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/file-upload', true),

('JWT Token Manipulation', 'The application uses JWT tokens for authentication. Can you forge a token to gain admin access?', 'Web', 'hard', 300, 'SEENAF{jwt_signature_cracked}', ARRAY['Examine the JWT token structure', 'Try changing the algorithm to none', 'Look for weak signing keys'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/jwt-auth', true),

('SSRF Internal Access', 'The application fetches external URLs. Can you use Server-Side Request Forgery to access internal services?', 'Web', 'hard', 350, 'SEENAF{ssrf_internal_network_access}', ARRAY['Try accessing localhost URLs', 'Look for internal IP ranges', 'The flag might be on an internal service'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/ssrf', true),

('Deserialization Attack', 'The application deserializes user input. Can you craft a malicious payload to execute arbitrary code?', 'Web', 'insane', 500, 'SEENAF{deserialization_rce_achieved}', ARRAY['Research common deserialization vulnerabilities', 'Look for gadget chains in the application', 'Try crafting a reverse shell payload'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/deserialize', true),

-- CRYPTOGRAPHY CHALLENGES (7)
('Caesar Cipher', 'Decrypt this message encrypted with a Caesar cipher: "FRPHFXULWB_LV_IXQ"', 'Crypto', 'easy', 50, 'SEENAF{security_is_fun}', ARRAY['Try different shift values', 'Caesar cipher shifts each letter by a fixed amount', 'The shift value is between 1 and 25'], 'Crypto Team', null, true),

('Base64 Decoding', 'Decode this Base64 string to find the flag: U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=', 'Crypto', 'easy', 75, 'SEENAF{base64_is_not_encryption}', ARRAY['Base64 is encoding, not encryption', 'Use any Base64 decoder', 'The string contains the flag directly'], 'Crypto Team', null, true),

('ROT13 Message', 'Decrypt this ROT13 encoded message: "FRRNAS{ebg13_vf_gbb_rnfl}"', 'Crypto', 'easy', 75, 'SEENAF{rot13_is_too_easy}', ARRAY['ROT13 shifts letters by 13 positions', 'Apply ROT13 twice to get original text', 'A becomes N, B becomes O, etc.'], 'Crypto Team', null, true),

('Vigenère Cipher', 'Decrypt this Vigenère cipher with key "KEY": "WIIQEV{tmiiqiv_gmtliv_gvegoid}"', 'Crypto', 'medium', 200, 'SEENAF{vigenere_cipher_cracked}', ARRAY['The key is "KEY"', 'Vigenère uses a repeating key', 'Each letter is shifted by the corresponding key letter'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/vigenere', true),

('RSA Weak Keys', 'Factor this RSA modulus to decrypt the message. N = 323, e = 5, ciphertext = 144', 'Crypto', 'medium', 250, 'SEENAF{rsa_factorization_success}', ARRAY['Factor N = 323 into two primes', '323 = 17 × 19', 'Calculate the private key and decrypt'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/rsa-weak', true),

('Hash Length Extension', 'Exploit a hash length extension attack to forge a valid signature for admin access.', 'Crypto', 'hard', 350, 'SEENAF{hash_length_extension_attack}', ARRAY['Research hash length extension attacks', 'You need to extend the original message', 'Use tools like hash_extender'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/hash-extension', true),

('AES ECB Oracle', 'Exploit the AES ECB encryption oracle to decrypt the secret message byte by byte.', 'Crypto', 'insane', 500, 'SEENAF{ecb_oracle_attack_successful}', ARRAY['ECB mode reveals patterns in plaintext', 'Use chosen plaintext attacks', 'Decrypt one byte at a time'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/aes-ecb', true),

-- FORENSICS CHALLENGES (12)
('Hidden in Plain Sight', 'Examine this image file carefully. The flag is hidden somewhere inside.', 'Forensics', 'easy', 100, 'SEENAF{steganography_basics}', ARRAY['Use strings command on the image', 'Check the image metadata', 'Look for hidden data in the file'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/hidden-image', true),

('Memory Dump Analysis', 'Analyze this memory dump to find the flag. The user was typing something important before the system crashed.', 'Forensics', 'medium', 200, 'SEENAF{memory_forensics_master}', ARRAY['Use volatility framework', 'Look for running processes', 'Check for clipboard or notepad content'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/memory-dump', true),

('Network Packet Analysis', 'Analyze this network capture to find the flag transmitted over the network.', 'Forensics', 'medium', 200, 'SEENAF{wireshark_packet_analysis}', ARRAY['Use Wireshark to analyze the pcap', 'Look for HTTP or FTP traffic', 'Follow TCP streams for complete data'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/network-capture', true),

('Deleted File Recovery', 'A file containing the flag was deleted from this disk image. Can you recover it?', 'Forensics', 'medium', 250, 'SEENAF{file_recovery_successful}', ARRAY['Use file recovery tools like photorec', 'Look in unallocated disk space', 'Check the recycle bin or trash'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/deleted-file', true),

('Registry Analysis', 'Examine this Windows registry hive to find the hidden flag.', 'Forensics', 'medium', 250, 'SEENAF{windows_registry_secrets}', ARRAY['Use registry analysis tools', 'Check recent documents and run history', 'Look for base64 encoded data'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/registry', true),

('Log File Investigation', 'Analyze these web server logs to find evidence of the attack and the hidden flag.', 'Forensics', 'medium', 200, 'SEENAF{log_analysis_detective}', ARRAY['Look for suspicious HTTP requests', 'Check for SQL injection attempts', 'Find the successful attack vector'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/web-logs', true),

('Disk Image Forensics', 'Mount this disk image and find the flag hidden in the filesystem.', 'Forensics', 'hard', 300, 'SEENAF{disk_forensics_expert}', ARRAY['Mount the disk image safely', 'Look for hidden files and folders', 'Check alternate data streams'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/disk-image', true),

('Email Header Analysis', 'Analyze these email headers to trace the source and find the flag.', 'Forensics', 'hard', 300, 'SEENAF{email_forensics_traced}', ARRAY['Examine the Received headers', 'Trace the email path backwards', 'Look for spoofed or forged headers'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/email-headers', true),

('Mobile App Forensics', 'Extract the flag from this Android APK file.', 'Forensics', 'hard', 350, 'SEENAF{mobile_forensics_success}', ARRAY['Decompile the APK file', 'Look in resources and assets', 'Check for obfuscated strings'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/android-apk', true),

('Database Forensics', 'Recover the flag from this corrupted SQLite database.', 'Forensics', 'hard', 350, 'SEENAF{database_recovery_master}', ARRAY['Use SQLite recovery tools', 'Look for deleted records', 'Check database journal files'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/sqlite-db', true),

('Timeline Analysis', 'Create a timeline of events from multiple log sources to find when the flag was accessed.', 'Forensics', 'insane', 450, 'SEENAF{timeline_analysis_expert}', ARRAY['Correlate timestamps across different logs', 'Look for time zone differences', 'Find the exact moment of compromise'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/timeline', true),

('Advanced Steganography', 'The flag is hidden using advanced steganographic techniques in this multimedia file.', 'Forensics', 'insane', 500, 'SEENAF{advanced_stego_master}', ARRAY['Try multiple steganography tools', 'Look for LSB steganography', 'Check different color channels'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/advanced-stego', true),

-- NETWORK CHALLENGES (6)
('Port Scanning', 'Scan the target network to find open ports and services. The flag is in the service banner.', 'Network', 'easy', 100, 'SEENAF{nmap_port_discovery}', ARRAY['Use nmap to scan for open ports', 'Check service banners with -sV', 'Look for unusual port numbers'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/port-scan', true),

('Network Protocol Analysis', 'Analyze this custom network protocol to understand the communication and extract the flag.', 'Network', 'medium', 200, 'SEENAF{protocol_analysis_success}', ARRAY['Capture network traffic with tcpdump', 'Look for patterns in the data', 'Try to decode the custom protocol'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/custom-protocol', true),

('DNS Tunneling', 'Data is being exfiltrated through DNS queries. Analyze the traffic to recover the flag.', 'Network', 'medium', 250, 'SEENAF{dns_tunneling_detected}', ARRAY['Look at DNS query names', 'Data might be base64 encoded', 'Reconstruct the exfiltrated data'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/dns-tunnel', true),

('WiFi Cracking', 'Crack this WPA2 handshake to get the WiFi password, which contains the flag.', 'Network', 'hard', 300, 'SEENAF{wifi_password_cracked}', ARRAY['Use aircrack-ng with a wordlist', 'The password is in rockyou.txt', 'Capture the 4-way handshake'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/wifi-crack', true),

('Network Pivoting', 'Use the compromised host to pivot into the internal network and find the flag.', 'Network', 'hard', 350, 'SEENAF{network_pivot_successful}', ARRAY['Set up port forwarding or tunneling', 'Scan the internal network', 'Look for internal services'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/pivot', true),

('BGP Hijacking Detection', 'Analyze BGP routing data to detect the hijacking attempt and find the flag.', 'Network', 'insane', 500, 'SEENAF{bgp_hijack_detected}', ARRAY['Understand BGP routing tables', 'Look for route announcements', 'Find the malicious AS number'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/bgp-hijack', true),

-- REVERSE ENGINEERING CHALLENGES (6)
('Basic Binary Analysis', 'Reverse engineer this simple binary to find the flag.', 'Reverse', 'easy', 150, 'SEENAF{reverse_engineering_basics}', ARRAY['Use strings command first', 'Try running the binary', 'Look for hardcoded strings'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/basic-binary', true),

('Password Checker', 'This program checks if you enter the correct password. Find the password to get the flag.', 'Reverse', 'medium', 200, 'SEENAF{password_found_in_binary}', ARRAY['Disassemble with objdump or ghidra', 'Look for string comparisons', 'Find the hardcoded password'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/password-check', true),

('Packed Executable', 'This executable is packed. Unpack it to analyze the real code and find the flag.', 'Reverse', 'medium', 250, 'SEENAF{unpacked_successfully}', ARRAY['Identify the packer used', 'Use appropriate unpacking tools', 'Analyze the unpacked binary'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/packed-exe', true),

('Anti-Debug Techniques', 'This binary uses anti-debugging techniques. Bypass them to find the flag.', 'Reverse', 'hard', 300, 'SEENAF{anti_debug_bypassed}', ARRAY['Look for debugger detection code', 'Patch the anti-debug checks', 'Use static analysis tools'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/anti-debug', true),

('Code Obfuscation', 'The flag is hidden in this heavily obfuscated code. Can you deobfuscate it?', 'Reverse', 'hard', 350, 'SEENAF{deobfuscation_master}', ARRAY['Look for control flow obfuscation', 'Try dynamic analysis', 'Use deobfuscation tools'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/obfuscated', true),

('Kernel Module Analysis', 'Analyze this Linux kernel module to find the hidden flag.', 'Reverse', 'insane', 500, 'SEENAF{kernel_module_analyzed}', ARRAY['Understand kernel module structure', 'Look for system call hooks', 'Analyze the module initialization'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/kernel-module', true),

-- BINARY EXPLOITATION CHALLENGES (3)
('Buffer Overflow Basic', 'Exploit this buffer overflow vulnerability to get a shell and read the flag.', 'Pwn', 'medium', 250, 'SEENAF{buffer_overflow_pwned}', ARRAY['Find the buffer overflow point', 'Control the return address', 'Jump to shellcode or system()'], 'Pwn Team', 'https://pwn-challenges.seenaf-ctf.com/buffer-overflow', true),

('Format String Attack', 'Exploit the format string vulnerability to read the flag from memory.', 'Pwn', 'hard', 350, 'SEENAF{format_string_exploited}', ARRAY['Use %x to read from stack', 'Try %s to read strings', 'Calculate the correct offset'], 'Pwn Team', 'https://pwn-challenges.seenaf-ctf.com/format-string', true),

('Return-to-libc', 'Bypass NX protection using return-to-libc technique to get code execution.', 'Pwn', 'insane', 500, 'SEENAF{return_to_libc_success}', ARRAY['Find libc base address', 'Locate system() function', 'Chain ROP gadgets'], 'Pwn Team', 'https://pwn-challenges.seenaf-ctf.com/ret2libc', true),

-- OSINT CHALLENGES (3)
('Social Media Investigation', 'Find information about this person using only their username: "cyberdetective2024"', 'OSINT', 'easy', 100, 'SEENAF{social_media_sleuth}', ARRAY['Search across multiple platforms', 'Look for linked accounts', 'Check profile information carefully'], 'OSINT Team', 'https://osint-challenges.seenaf-ctf.com/social-media', true),

('Geolocation Challenge', 'Determine the exact location where this photo was taken using visual clues.', 'OSINT', 'medium', 200, 'SEENAF{geolocation_expert}', ARRAY['Look for landmarks and signs', 'Use reverse image search', 'Check metadata if available'], 'OSINT Team', 'https://osint-challenges.seenaf-ctf.com/geolocation', true),

('Corporate Intelligence', 'Gather intelligence about this company to find their hidden development server.', 'OSINT', 'hard', 300, 'SEENAF{corporate_intel_gathered}', ARRAY['Check company websites and subdomains', 'Look for employee information', 'Search for leaked credentials'], 'OSINT Team', 'https://osint-challenges.seenaf-ctf.com/corporate', true),

-- STEGANOGRAPHY CHALLENGES (4)
('Image Steganography', 'The flag is hidden in this image using LSB steganography.', 'Stego', 'easy', 100, 'SEENAF{lsb_steganography_found}', ARRAY['Use steganography tools like steghide', 'Try LSB extraction tools', 'Check different color channels'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/image-lsb', true),

('Audio Steganography', 'Listen carefully to this audio file. The flag is hidden in the sound waves.', 'Stego', 'medium', 200, 'SEENAF{audio_steganography_decoded}', ARRAY['Use audio analysis tools like Audacity', 'Look at the spectrogram', 'Check for hidden frequencies'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/audio-hidden', true),

('Text Steganography', 'The flag is hidden in this text using invisible characters or spacing.', 'Stego', 'medium', 200, 'SEENAF{text_steganography_revealed}', ARRAY['Look for unusual spacing', 'Check for invisible Unicode characters', 'Try different text encodings'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/text-hidden', true),

('Multi-layer Steganography', 'This challenge uses multiple layers of steganography. Peel back each layer to find the flag.', 'Stego', 'hard', 350, 'SEENAF{multi_layer_stego_master}', ARRAY['Extract the first hidden layer', 'The result contains another hidden message', 'Keep extracting until you find the flag'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/multi-layer', true),

-- MISCELLANEOUS CHALLENGES (4)
('QR Code Puzzle', 'Scan this QR code to get the flag, but it might not be that simple.', 'Misc', 'easy', 75, 'SEENAF{qr_code_scanned_successfully}', ARRAY['Use a QR code scanner', 'The QR code might be damaged', 'Try error correction'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/qr-puzzle', true),

('Logic Puzzle', 'Solve this logic puzzle to determine the correct sequence and get the flag.', 'Misc', 'medium', 200, 'SEENAF{logic_puzzle_solved}', ARRAY['Read the clues carefully', 'Use process of elimination', 'Draw a grid to track possibilities'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/logic-puzzle', true),

('Programming Challenge', 'Write a program to solve this algorithmic problem and get the flag.', 'Misc', 'hard', 300, 'SEENAF{algorithm_implemented_correctly}', ARRAY['Understand the problem requirements', 'Consider time complexity', 'Test with the provided examples'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/programming', true),

('Esoteric Language', 'This code is written in an esoteric programming language. Execute it to get the flag.', 'Misc', 'insane', 400, 'SEENAF{esoteric_language_mastered}', ARRAY['Identify the programming language', 'Find an interpreter online', 'The language might be Brainfuck or Whitespace'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/esoteric', true);

-- Step 4: Disable RLS temporarily for easier access
ALTER TABLE challenges DISABLE ROW LEVEL SECURITY;

-- Step 5: Grant permissions
GRANT ALL ON challenges TO authenticated;
GRANT ALL ON challenges TO anon;

-- Step 6: Verify the data was inserted
SELECT 'Challenge loading complete!' as status;
SELECT category, COUNT(*) as count FROM challenges GROUP BY category ORDER BY category;
SELECT 'Total challenges loaded:' as info, COUNT(*) as total FROM challenges;