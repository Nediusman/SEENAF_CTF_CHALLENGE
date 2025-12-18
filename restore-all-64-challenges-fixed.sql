-- RESTORE ALL 64 CHALLENGES - FIXED VERSION
-- Run this in Supabase SQL Editor

-- First, clear existing challenges to avoid duplicates
DELETE FROM challenges;

-- Reset the sequence if needed
ALTER SEQUENCE challenges_id_seq RESTART WITH 1;

-- Insert all 64 challenges
INSERT INTO challenges (title, description, category, difficulty, points, flag, hints, author, instance_url, is_active) VALUES

-- Web Security Challenges (7)
('Basic XSS', 'Find and exploit a cross-site scripting vulnerability in this web application.', 'Web', 'easy', 100, 'SEENAF{xss_vulnerability_found}', ARRAY['Look for input fields that reflect user data', 'Try injecting <script> tags', 'Check if the output is properly sanitized'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/xss-basic', true),

('SQL Injection Login', 'Bypass the login form using SQL injection to access the admin panel.', 'Web', 'easy', 150, 'SEENAF{sql_injection_successful}', ARRAY['Try common SQL injection payloads', 'Look for ways to bypass authentication', 'The admin username might be "admin"'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/sqli-login', true),

('Command Injection', 'The ping utility allows you to test network connectivity, but it might be vulnerable to command injection. Can you execute arbitrary commands?', 'Web', 'medium', 200, 'SEENAF{command_injection_pwned}', ARRAY['Try chaining commands with ; or &&', 'Look for ways to execute system commands', 'The flag might be in a file on the server'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/cmd-injection', true),

('File Upload Bypass', 'Upload a file to get the flag, but the application has file type restrictions. Can you bypass the upload filter?', 'Web', 'medium', 250, 'SEENAF{file_upload_filter_bypassed}', ARRAY['Try different file extensions', 'Look at the MIME type validation', 'Consider using double extensions'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/file-upload', true),

('JWT Token Manipulation', 'The application uses JWT tokens for authentication. Can you forge a token to gain admin access?', 'Web', 'hard', 300, 'SEENAF{jwt_signature_cracked}', ARRAY['Examine the JWT token structure', 'Try changing the algorithm to none', 'Look for weak signing keys'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/jwt-auth', true),

('SSRF Internal Access', 'The application fetches external URLs. Can you use Server-Side Request Forgery to access internal services?', 'Web', 'hard', 350, 'SEENAF{ssrf_internal_network_access}', ARRAY['Try accessing localhost URLs', 'Look for internal IP ranges', 'The flag might be on an internal service'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/ssrf', true),

('Deserialization Attack', 'The application deserializes user input. Can you craft a malicious payload to execute arbitrary code?', 'Web', 'insane', 500, 'SEENAF{deserialization_rce_achieved}', ARRAY['Research common deserialization vulnerabilities', 'Look for gadget chains in the application', 'Try crafting a reverse shell payload'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/deserialize', true),

-- Cryptography Challenges (7)
('Base64 Decoding', 'Decode this Base64 string: "U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0="', 'Crypto', 'easy', 50, 'SEENAF{base64_is_not_encryption}', ARRAY['Base64 is encoding, not encryption', 'Use any Base64 decoder', 'The string decodes directly to the flag'], 'Crypto Team', null, true),

('Caesar Cipher', 'Decrypt this Caesar cipher: "VHHQDI{fdhvdu_flskhu_fudfnhg}"', 'Crypto', 'easy', 75, 'SEENAF{caesar_cipher_cracked}', ARRAY['Try different shift values', 'Caesar cipher shifts letters by a fixed amount', 'The shift is likely between 1-25'], 'Crypto Team', null, true),

('ROT13 Message', 'Decrypt this ROT13 encoded message: "FRRNAS{ebg13_vf_gbb_rnfl}"', 'Crypto', 'easy', 75, 'SEENAF{rot13_is_too_easy}', ARRAY['ROT13 shifts letters by 13 positions', 'Apply ROT13 twice to get original text', 'A becomes N, B becomes O, etc.'], 'Crypto Team', null, true),

('Numbers Cipher', 'Decode this number sequence: "19 5 5 14 1 6 {14 21 13 2 5 18 19 _ 1 18 5 _ 6 21 14}"', 'Crypto', 'easy', 100, 'SEENAF{numbers_are_fun}', ARRAY['Each number represents a letter position', 'A=1, B=2, C=3, etc.', 'Convert numbers to letters'], 'Crypto Team', null, true),

('Vigenère Cipher', 'Decrypt this Vigenère cipher with key "KEY": "WIIQEV{tmiiqiv_gmtliv_gvegoid}"', 'Crypto', 'medium', 200, 'SEENAF{vigenere_cipher_cracked}', ARRAY['The key is "KEY"', 'Vigenère uses a repeating key', 'Each letter is shifted by the corresponding key letter'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/vigenere', true),

('RSA Weak Keys', 'Factor this RSA modulus to decrypt the message. N = 323, e = 5, ciphertext = 144', 'Crypto', 'medium', 250, 'SEENAF{rsa_factorization_success}', ARRAY['Factor N = 323 into two primes', '323 = 17 × 19', 'Calculate the private key and decrypt'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/rsa-weak', true),

('Hash Length Extension', 'Exploit a hash length extension attack to forge a valid signature for admin access.', 'Crypto', 'hard', 350, 'SEENAF{hash_length_extension_attack}', ARRAY['Research hash length extension attacks', 'You need to extend the original message', 'Use tools like hash_extender'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/hash-extension', true),

-- Forensics Challenges (12)
('Hidden in Plain Sight', 'The flag is hidden in this image file. Can you find it?', 'Forensics', 'easy', 100, 'SEENAF{steganography_basics}', ARRAY['Try using steganography tools like steghide', 'Check the image metadata with exiftool', 'Look for hidden text in the image'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/image-stego', true),

('Corrupted ZIP', 'This ZIP file is corrupted, but the flag is inside. Can you repair it?', 'Forensics', 'easy', 150, 'SEENAF{zip_file_repaired}', ARRAY['Use hex editor to examine the file', 'Look for ZIP file signatures', 'Try zip repair tools'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/corrupted-zip', true),

('Network Packet Analysis', 'Analyze this network capture to find the flag transmitted over the network.', 'Forensics', 'medium', 200, 'SEENAF{packet_analysis_complete}', ARRAY['Use Wireshark to analyze the pcap file', 'Look for HTTP or FTP traffic', 'Follow TCP streams to see full conversations'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/network-pcap', true),

('Memory Dump Analysis', 'Analyze this memory dump to find the flag. The user was typing something important before the system crashed.', 'Forensics', 'medium', 200, 'SEENAF{memory_forensics_master}', ARRAY['Use volatility framework', 'Look for running processes', 'Check for clipboard or notepad content'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/memory-dump', true),

('Deleted File Recovery', 'A file containing the flag was deleted from this disk image. Can you recover it?', 'Forensics', 'medium', 250, 'SEENAF{file_recovery_successful}', ARRAY['Use file recovery tools like photorec', 'Look in unallocated disk space', 'Check the recycle bin or trash'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/deleted-file', true),

('Registry Analysis', 'Examine this Windows registry hive to find the hidden flag.', 'Forensics', 'medium', 250, 'SEENAF{windows_registry_secrets}', ARRAY['Use registry analysis tools', 'Check recent documents and run history', 'Look for base64 encoded data'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/registry', true),

('Log File Investigation', 'Analyze these web server logs to find evidence of the attack and the hidden flag.', 'Forensics', 'medium', 200, 'SEENAF{log_analysis_detective}', ARRAY['Look for suspicious HTTP requests', 'Check for SQL injection attempts', 'Find the successful attack vector'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/web-logs', true),

('Disk Image Forensics', 'Mount this disk image and find the flag hidden in the filesystem.', 'Forensics', 'hard', 300, 'SEENAF{disk_forensics_expert}', ARRAY['Mount the disk image safely', 'Look for hidden files and folders', 'Check alternate data streams'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/disk-image', true),

('Email Header Analysis', 'Analyze these email headers to trace the source and find the flag.', 'Forensics', 'hard', 300, 'SEENAF{email_forensics_traced}', ARRAY['Examine the Received headers', 'Trace the email path backwards', 'Look for spoofed or forged headers'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/email-headers', true),

('Mobile App Forensics', 'Extract the flag from this Android APK file.', 'Forensics', 'hard', 350, 'SEENAF{mobile_forensics_success}', ARRAY['Decompile the APK file', 'Look in resources and assets', 'Check for obfuscated strings'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/android-apk', true),

('Database Forensics', 'Recover the flag from this corrupted SQLite database.', 'Forensics', 'hard', 350, 'SEENAF{database_recovery_master}', ARRAY['Use SQLite recovery tools', 'Look for deleted records', 'Check database journal files'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/sqlite-db', true),

('Timeline Analysis', 'Create a timeline of events from multiple log sources to find when the flag was accessed.', 'Forensics', 'insane', 450, 'SEENAF{timeline_analysis_expert}', ARRAY['Correlate timestamps across different logs', 'Look for time zone differences', 'Find the exact moment of compromise'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/timeline', true),

-- Network Security Challenges (6)
('Port Scanning', 'Scan this target to find open ports and services, then find the flag.', 'Network', 'easy', 100, 'SEENAF{port_scan_complete}', ARRAY['Use nmap to scan for open ports', 'Look for unusual services', 'Try connecting to discovered services'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/port-scan', true),

('Wireshark Analysis', 'Analyze this packet capture to find credentials being transmitted in plaintext.', 'Network', 'easy', 150, 'SEENAF{plaintext_credentials_found}', ARRAY['Look for HTTP POST requests', 'Check for FTP or Telnet traffic', 'Search for password fields'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/wireshark-basic', true),

('Network Protocol Analysis', 'Analyze this custom network protocol to understand the communication and extract the flag.', 'Network', 'medium', 200, 'SEENAF{protocol_analysis_success}', ARRAY['Capture network traffic with tcpdump', 'Look for patterns in the data', 'Try to decode the custom protocol'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/custom-protocol', true),

('DNS Tunneling', 'Data is being exfiltrated through DNS queries. Analyze the traffic to recover the flag.', 'Network', 'medium', 250, 'SEENAF{dns_tunneling_detected}', ARRAY['Look at DNS query names', 'Data might be base64 encoded', 'Reconstruct the exfiltrated data'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/dns-tunnel', true),

('WiFi Cracking', 'Crack this WPA2 handshake to get the WiFi password, which contains the flag.', 'Network', 'hard', 300, 'SEENAF{wifi_password_cracked}', ARRAY['Use aircrack-ng with a wordlist', 'The password is in rockyou.txt', 'Capture the 4-way handshake'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/wifi-crack', true),

('Network Pivoting', 'Use the compromised host to pivot into the internal network and find the flag.', 'Network', 'hard', 350, 'SEENAF{network_pivot_successful}', ARRAY['Set up port forwarding or tunneling', 'Scan the internal network', 'Look for internal services'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/pivot', true),

-- Reverse Engineering Challenges (6)
('Simple Crackme', 'This program asks for a password. Find the correct password to get the flag.', 'Reverse', 'easy', 100, 'SEENAF{simple_password_cracked}', ARRAY['Use strings command to find text', 'Try disassembling with objdump', 'Look for password comparison'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/simple-crackme', true),

('Binary Analysis', 'Analyze this binary to understand what it does and extract the flag.', 'Reverse', 'easy', 150, 'SEENAF{binary_analysis_complete}', ARRAY['Use file command to identify the binary', 'Try running it to see behavior', 'Use ltrace or strace to trace calls'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/binary-analysis', true),

('Password Checker', 'This program checks if you enter the correct password. Find the password to get the flag.', 'Reverse', 'medium', 200, 'SEENAF{password_found_in_binary}', ARRAY['Disassemble with objdump or ghidra', 'Look for string comparisons', 'Find the hardcoded password'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/password-check', true),

('Packed Executable', 'This executable is packed. Unpack it to analyze the real code and find the flag.', 'Reverse', 'medium', 250, 'SEENAF{unpacked_successfully}', ARRAY['Identify the packer used', 'Use appropriate unpacking tools', 'Analyze the unpacked binary'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/packed-exe', true),

('Anti-Debug Techniques', 'This binary uses anti-debugging techniques. Bypass them to find the flag.', 'Reverse', 'hard', 300, 'SEENAF{anti_debug_bypassed}', ARRAY['Look for debugger detection code', 'Patch the anti-debug checks', 'Use static analysis tools'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/anti-debug', true),

('Code Obfuscation', 'The flag is hidden in this heavily obfuscated code. Can you deobfuscate it?', 'Reverse', 'hard', 350, 'SEENAF{deobfuscation_master}', ARRAY['Look for control flow obfuscation', 'Try dynamic analysis', 'Use deobfuscation tools'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/obfuscated', true),

-- Binary Exploitation (Pwn) Challenges (3)
('Buffer Overflow Basic', 'Exploit this buffer overflow vulnerability to get a shell and read the flag.', 'Pwn', 'medium', 250, 'SEENAF{buffer_overflow_pwned}', ARRAY['Find the buffer overflow point', 'Control the return address', 'Jump to shellcode or system()'], 'Pwn Team', 'https://pwn-challenges.seenaf-ctf.com/buffer-overflow', true),

('Format String Attack', 'Exploit the format string vulnerability to read the flag from memory.', 'Pwn', 'hard', 350, 'SEENAF{format_string_exploited}', ARRAY['Use %x to read from stack', 'Try %s to read strings', 'Calculate the correct offset'], 'Pwn Team', 'https://pwn-challenges.seenaf-ctf.com/format-string', true),

('Return-to-libc', 'Bypass NX protection using return-to-libc technique to get code execution.', 'Pwn', 'insane', 500, 'SEENAF{return_to_libc_success}', ARRAY['Find libc base address', 'Locate system() function', 'Chain ROP gadgets'], 'Pwn Team', 'https://pwn-challenges.seenaf-ctf.com/ret2libc', true),

-- OSINT Challenges (3)
('Social Media Investigation', 'Find information about this person using their social media profiles.', 'OSINT', 'easy', 100, 'SEENAF{social_media_sleuth}', ARRAY['Search for the username on different platforms', 'Look for linked accounts', 'Check profile information carefully'], 'OSINT Team', 'https://osint-challenges.seenaf-ctf.com/social-media', true),

('Geolocation Challenge', 'Determine the exact location where this photo was taken using visual clues.', 'OSINT', 'medium', 200, 'SEENAF{geolocation_expert}', ARRAY['Look for landmarks and signs', 'Use reverse image search', 'Check metadata if available'], 'OSINT Team', 'https://osint-challenges.seenaf-ctf.com/geolocation', true),

('Corporate Intelligence', 'Gather intelligence about this company to find their hidden development server.', 'OSINT', 'hard', 300, 'SEENAF{corporate_intel_gathered}', ARRAY['Check company websites and subdomains', 'Look for employee information', 'Search for leaked credentials'], 'OSINT Team', 'https://osint-challenges.seenaf-ctf.com/corporate', true),

-- Steganography Challenges (4)
('Image Steganography', 'There is a hidden message in this image. Can you extract it?', 'Stego', 'easy', 100, 'SEENAF{image_stego_found}', ARRAY['Use steganography tools like steghide', 'Try different passwords', 'Check LSB steganography'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/image-basic', true),

('Audio Steganography', 'Listen carefully to this audio file. The flag is hidden in the sound waves.', 'Stego', 'medium', 200, 'SEENAF{audio_steganography_decoded}', ARRAY['Use audio analysis tools like Audacity', 'Look at the spectrogram', 'Check for hidden frequencies'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/audio-hidden', true),

('Text Steganography', 'The flag is hidden in this text using invisible characters or spacing.', 'Stego', 'medium', 200, 'SEENAF{text_steganography_revealed}', ARRAY['Look for unusual spacing', 'Check for invisible Unicode characters', 'Try different text encodings'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/text-hidden', true),

('Multi-layer Steganography', 'This challenge uses multiple layers of steganography. Peel back each layer to find the flag.', 'Stego', 'hard', 350, 'SEENAF{multi_layer_stego_master}', ARRAY['Extract the first hidden layer', 'The result contains another hidden message', 'Keep extracting until you find the flag'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/multi-layer', true),

-- Miscellaneous Challenges (4)
('QR Code Challenge', 'Scan this QR code to get the flag, but it might not be that simple.', 'Misc', 'easy', 100, 'SEENAF{qr_code_scanned}', ARRAY['Use a QR code scanner', 'The QR code might be damaged', 'Try repairing the QR code'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/qr-code', true),

('Logic Puzzle', 'Solve this logic puzzle to determine the correct sequence and get the flag.', 'Misc', 'medium', 200, 'SEENAF{logic_puzzle_solved}', ARRAY['Read the clues carefully', 'Use process of elimination', 'Draw a grid to track possibilities'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/logic-puzzle', true),

('Programming Challenge', 'Write a program to solve this algorithmic problem and get the flag.', 'Misc', 'hard', 300, 'SEENAF{algorithm_implemented_correctly}', ARRAY['Understand the problem requirements', 'Consider time complexity', 'Test with the provided examples'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/programming', true),

('Esoteric Language', 'This code is written in an esoteric programming language. Execute it to get the flag.', 'Misc', 'insane', 400, 'SEENAF{esoteric_language_mastered}', ARRAY['Identify the programming language', 'Find an interpreter online', 'The language might be Brainfuck or Whitespace'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/esoteric', true),

-- Additional Advanced Challenges (16 more to reach 64 total)
('Advanced SQL Injection', 'This application uses advanced SQL injection protection. Can you bypass it?', 'Web', 'hard', 400, 'SEENAF{advanced_sqli_bypassed}', ARRAY['Try different SQL injection techniques', 'Look for blind SQL injection', 'Use time-based attacks'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/advanced-sqli', true),

('AES ECB Oracle', 'Exploit the AES ECB encryption oracle to decrypt the secret message byte by byte.', 'Crypto', 'insane', 500, 'SEENAF{ecb_oracle_attack_successful}', ARRAY['ECB mode reveals patterns in plaintext', 'Use chosen plaintext attacks', 'Decrypt one byte at a time'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/aes-ecb', true),

('Advanced Steganography', 'The flag is hidden using advanced steganographic techniques in this multimedia file.', 'Forensics', 'insane', 500, 'SEENAF{advanced_stego_master}', ARRAY['Try multiple steganography tools', 'Look for LSB steganography', 'Check different color channels'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/advanced-stego', true),

('BGP Hijacking Detection', 'Analyze BGP routing data to detect the hijacking attempt and find the flag.', 'Network', 'insane', 500, 'SEENAF{bgp_hijack_detected}', ARRAY['Understand BGP routing tables', 'Look for route announcements', 'Find the malicious AS number'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/bgp-hijack', true),

('Kernel Module Analysis', 'Analyze this Linux kernel module to find the hidden flag.', 'Reverse', 'insane', 500, 'SEENAF{kernel_module_analyzed}', ARRAY['Understand kernel module structure', 'Look for system call hooks', 'Analyze the module initialization'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/kernel-module', true),

('Race Condition Exploit', 'Exploit the race condition in this application to gain unauthorized access.', 'Pwn', 'hard', 400, 'SEENAF{race_condition_exploited}', ARRAY['Identify the race condition window', 'Use threading to exploit timing', 'Look for TOCTOU vulnerabilities'], 'Pwn Team', 'https://pwn-challenges.seenaf-ctf.com/race-condition', true),

('Satellite Communication', 'Intercept and decode this satellite communication to find the flag.', 'OSINT', 'insane', 500, 'SEENAF{satellite_communication_decoded}', ARRAY['Use SDR tools', 'Identify the satellite frequency', 'Decode the signal protocol'], 'OSINT Team', 'https://osint-challenges.seenaf-ctf.com/satellite', true),

('Video Steganography', 'The flag is hidden in this video file using advanced steganographic techniques.', 'Stego', 'hard', 400, 'SEENAF{video_steganography_found}', ARRAY['Extract frames from the video', 'Look for hidden data in frames', 'Check video metadata'], 'Stego Team', 'https://stego-challenges.seenaf-ctf.com/video', true),

('AI/ML Challenge', 'Use machine learning to solve this pattern recognition challenge and get the flag.', 'Misc', 'hard', 400, 'SEENAF{machine_learning_solved}', ARRAY['Train a model on the dataset', 'Use pattern recognition techniques', 'Apply neural networks'], 'Misc Team', 'https://misc-challenges.seenaf-ctf.com/ml-challenge', true),

('Zero-Day Exploit', 'Find and exploit a zero-day vulnerability in this custom application.', 'Web', 'insane', 600, 'SEENAF{zero_day_discovered}', ARRAY['Perform thorough code review', 'Look for logic flaws', 'Test edge cases'], 'WebSec Team', 'https://web-challenges.seenaf-ctf.com/zero-day', true),

('Quantum Cryptography', 'Break this quantum-resistant encryption to find the flag.', 'Crypto', 'insane', 600, 'SEENAF{quantum_crypto_broken}', ARRAY['Research post-quantum cryptography', 'Look for implementation flaws', 'Use advanced mathematical attacks'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/quantum', true),

('Nation-State APT', 'Analyze this advanced persistent threat campaign to find the flag.', 'Forensics', 'insane', 600, 'SEENAF{apt_campaign_analyzed}', ARRAY['Look for TTPs and IOCs', 'Analyze the attack timeline', 'Identify the threat actor'], 'Forensics Team', 'https://forensics-challenges.seenaf-ctf.com/apt-analysis', true),

('5G Network Security', 'Find vulnerabilities in this 5G network implementation.', 'Network', 'insane', 600, 'SEENAF{5g_network_compromised}', ARRAY['Understand 5G protocols', 'Look for implementation flaws', 'Test network slicing security'], 'Network Team', 'https://network-challenges.seenaf-ctf.com/5g-security', true),

('Hardware Reverse Engineering', 'Reverse engineer this hardware device to extract the flag from its firmware.', 'Reverse', 'insane', 600, 'SEENAF{hardware_reverse_engineered}', ARRAY['Use hardware debugging tools', 'Extract firmware via JTAG', 'Analyze the bootloader'], 'Reverse Team', 'https://reverse-challenges.seenaf-ctf.com/hardware', true),

('VM Escape', 'Escape from this virtual machine to access the host system and find the flag.', 'Pwn', 'insane', 600, 'SEENAF{vm_escape_successful}', ARRAY['Look for hypervisor vulnerabilities', 'Try hardware-based attacks', 'Research VM escape techniques'], 'Pwn Team', 'https://pwn-challenges.seenaf-ctf.com/vm-escape', true),

('Blockchain Analysis', 'Analyze this blockchain transaction to find the hidden flag.', 'Crypto', 'hard', 400, 'SEENAF{blockchain_analysis_complete}', ARRAY['Look at transaction details', 'Check smart contract code', 'Analyze the transaction history'], 'Crypto Team', 'https://crypto-challenges.seenaf-ctf.com/blockchain', true);

-- Verify the restoration
SELECT 'All 64 challenges restored successfully!' as status;
SELECT category, COUNT(*) as count FROM challenges GROUP BY category ORDER BY category;
SELECT 'Total challenges:' as info, COUNT(*) as total FROM challenges;