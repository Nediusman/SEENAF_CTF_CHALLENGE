import { supabase } from '@/integrations/supabase/client';

export const loadBasicChallenges = async () => {
  const challenges = [
    {
      title: 'Inspect HTML',
      description: 'Can you find the flag that\'s hiding in this webpage?\n\nThis is a basic web challenge where you need to examine the HTML source code of a webpage to find a hidden flag.',
      category: 'Web',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{1nsp3ct_th3_html_s0urc3}',
      hints: ['Try right-clicking and selecting "View Page Source"', 'Look for HTML comments', 'The flag might be in a hidden div or comment'],
      is_active: true
    },
    {
      title: 'Cookies',
      description: 'I heard you like cookies. Nom nom nom.\n\nThis challenge involves manipulating browser cookies to access restricted content.',
      category: 'Web',
      difficulty: 'easy',
      points: 150,
      flag: 'SEENAF{c00k13_m0nst3r_0mg}',
      hints: ['Check your browser\'s cookies for this site', 'Try changing cookie values', 'Look for cookies named "admin" or "role"'],
      is_active: true
    },
    {
      title: 'SQL Injection',
      description: 'Login as the admin user to get the flag.\n\nThis login form is vulnerable to SQL injection. The admin username is "admin".',
      category: 'Web',
      difficulty: 'medium',
      points: 250,
      flag: 'SEENAF{sql_1nj3ct10n_1s_d4ng3r0us}',
      hints: ['Try SQL injection in the password field', 'Use OR 1=1 to bypass authentication', 'Comment out the rest of the query with --'],
      is_active: true
    },
    {
      title: 'XSS Playground',
      description: 'This comment system doesn\'t properly sanitize user input. Can you execute JavaScript code?\n\nFind a way to execute JavaScript in the comment system.',
      category: 'Web',
      difficulty: 'medium',
      points: 300,
      flag: 'SEENAF{xss_4tt4ck_succ3ssful}',
      hints: ['Try injecting <script> tags in comments', 'Use alert() to test XSS', 'Look for input fields that reflect user data'],
      is_active: true
    },
    {
      title: 'The Numbers',
      description: 'The numbers... what do they mean?\n\n13 9 3 15 3 20 6 { 20 8 5 14 21 13 2 5 18 19 13 1 19 15 14 }',
      category: 'Crypto',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{THENUMBERSMASON}',
      hints: ['These look like numbers representing letters', 'A=1, B=2, C=3, etc.', 'Convert each number to its corresponding letter'],
      is_active: true
    },
    {
      title: 'Caesar',
      description: 'Decrypt this message that was encrypted with a Caesar cipher.\n\nVHHQDI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}',
      category: 'Crypto',
      difficulty: 'easy',
      points: 150,
      flag: 'SEENAF{CAESAR_CIPHER_IS_EASY_PEASY}',
      hints: ['This is a Caesar cipher', 'Try different shift values', 'The shift is likely 3 (classic Caesar)'],
      is_active: true
    },
    {
      title: 'Base64 Basics',
      description: 'Decode this Base64 encoded message to find the flag.\n\nU0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=',
      category: 'Crypto',
      difficulty: 'easy',
      points: 75,
      flag: 'SEENAF{base64_is_not_encryption}',
      hints: ['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding at the end'],
      is_active: true
    },
    {
      title: 'ROT13 Message',
      description: 'Decrypt this ROT13 encoded message.\n\nFRRANS{ebg13_vf_whfg_n_pnrfne_pvcure}',
      category: 'Crypto',
      difficulty: 'easy',
      points: 120,
      flag: 'SEENAF{rot13_is_just_a_caesar_cipher}',
      hints: ['ROT13 shifts each letter by 13 positions', 'A becomes N, B becomes O, etc.', 'Try an online ROT13 decoder'],
      is_active: true
    },
    {
      title: 'File Extensions',
      description: 'This file doesn\'t seem to be what it appears to be.\n\nDownload the file and determine its real type to extract the flag.',
      category: 'Forensics',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{f1l3_3xt3ns10ns_l13}',
      hints: ['Use the "file" command to check the real file type', 'The extension might be misleading', 'Try opening with different programs'],
      is_active: true
    },
    {
      title: 'Hidden Message',
      description: 'This image looks innocent, but there\'s a hidden message inside.\n\nUse steganography tools to find the hidden flag.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{st3g4n0gr4phy_m4st3r}',
      hints: ['Use steganography tools like steghide', 'Try the strings command on the image', 'Check the image metadata with exiftool'],
      is_active: true
    },
    {
      title: 'Wireshark Analysis',
      description: 'Can you find the flag in this network capture?\n\nAnalyze the PCAP file to find suspicious network traffic containing the flag.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 250,
      flag: 'SEENAF{n3tw0rk_tr4ff1c_4n4lys1s}',
      hints: ['Use Wireshark to open the PCAP file', 'Look for HTTP traffic', 'Check POST requests and form data'],
      is_active: true
    },
    {
      title: 'Memory Dump',
      description: 'We captured the memory of a compromised system. The attacker left traces.\n\nAnalyze the memory dump to find the flag.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 350,
      flag: 'SEENAF{m3m0ry_f0r3ns1cs_3xp3rt}',
      hints: ['Use Volatility framework', 'Look for suspicious processes', 'Check for injected code or strings'],
      is_active: true
    },
    {
      title: 'Disk Image Analysis',
      description: 'We recovered a disk image from a suspect\'s computer. Find the hidden evidence.\n\nUse disk forensics tools to analyze the filesystem and recover deleted files.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 275,
      flag: 'SEENAF{d1sk_f0r3ns1cs_m4st3r}',
      hints: ['Use tools like Autopsy or FTK Imager', 'Look for deleted files in unallocated space', 'Check file system journals and logs'],
      is_active: true
    },
    {
      title: 'PDF Malware',
      description: 'This PDF file contains malicious code. Analyze it to find the flag.\n\nUse PDF analysis tools to examine the structure and extract embedded objects.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 400,
      flag: 'SEENAF{pdf_m4lw4r3_4n4lys1s}',
      hints: ['Use pdf-parser or peepdf tools', 'Look for JavaScript or embedded files', 'Check for suspicious streams and objects'],
      is_active: true
    },
    {
      title: 'Registry Forensics',
      description: 'The Windows registry contains traces of malicious activity. Find the evidence.\n\nAnalyze Windows registry hives to find traces of malware persistence.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 225,
      flag: 'SEENAF{r3g1stry_hunt3r_pr0}',
      hints: ['Use RegRipper or Registry Explorer', 'Check Run keys for persistence', 'Look for unusual services and startup entries'],
      is_active: true
    },
    {
      title: 'Mobile Forensics',
      description: 'We extracted data from a suspect\'s Android device. Find the smoking gun.\n\nAnalyze mobile device artifacts including SMS, call logs, and app data.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 375,
      flag: 'SEENAF{m0b1l3_f0r3ns1cs_n1nj4}',
      hints: ['Look in SQLite databases', 'Check messaging app databases', 'Examine deleted SMS and call records'],
      is_active: true
    },
    {
      title: 'Audio Steganography',
      description: 'This audio file sounds normal, but it hides a secret message.\n\nUse audio analysis tools to find the hidden data in the sound file.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{4ud10_st3g0_m4st3r}',
      hints: ['Use Audacity or SoX for analysis', 'Check the spectrogram view', 'Look for LSB steganography in audio samples'],
      is_active: true
    },
    {
      title: 'Zip Password',
      description: 'This password-protected ZIP file contains the flag. Can you crack it?\n\nUse password cracking techniques to break into the encrypted archive.',
      category: 'Forensics',
      difficulty: 'easy',
      points: 125,
      flag: 'SEENAF{z1p_cr4ck1ng_3z}',
      hints: ['Try common passwords first', 'Use John the Ripper or hashcat', 'The password might be in a wordlist'],
      is_active: true
    },
    {
      title: 'Timeline Analysis',
      description: 'Create a timeline of events from these log files to find when the breach occurred.\n\nAnalyze system logs to reconstruct the attack timeline.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 325,
      flag: 'SEENAF{t1m3l1n3_4n4lyst_pr0}',
      hints: ['Use log2timeline or Plaso', 'Look for authentication failures', 'Check for file access patterns'],
      is_active: true
    },
    {
      title: 'Malware Strings',
      description: 'This malware sample contains interesting strings. Find the flag hidden in the binary.\n\nUse static analysis to extract strings from the malware executable.',
      category: 'Forensics',
      difficulty: 'easy',
      points: 150,
      flag: 'SEENAF{str1ngs_4r3_y0ur_fr13nd}',
      hints: ['Use the strings command', 'Look for base64 encoded data', 'Check for URLs and file paths'],
      is_active: true
    },
    {
      title: 'Email Headers',
      description: 'This phishing email contains clues about its origin. Analyze the headers.\n\nExamine email headers to trace the source and find hidden information.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 175,
      flag: 'SEENAF{3m41l_h34d3r_d3t3ct1v3}',
      hints: ['Check the Received headers', 'Look for spoofed sender information', 'Examine X-Originating-IP headers'],
      is_active: true
    },
    {
      title: 'Database Recovery',
      description: 'This corrupted SQLite database contains sensitive information. Recover the flag.\n\nUse database recovery techniques to extract data from the damaged file.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 300,
      flag: 'SEENAF{db_r3c0v3ry_3xp3rt}',
      hints: ['Use SQLite recovery tools', 'Check for deleted records', 'Look in unallocated database pages'],
      is_active: true
    },
    {
      title: 'QR Code Forensics',
      description: 'This damaged QR code contains the flag. Can you repair and decode it?\n\nUse image processing techniques to restore the corrupted QR code.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 180,
      flag: 'SEENAF{qr_c0d3_r3p41r_n1nj4}',
      hints: ['Use image editing software to repair damage', 'QR codes have error correction', 'Try different QR code readers'],
      is_active: true
    },
    {
      title: 'Deleted Files Recovery',
      description: 'Someone deleted important files from this USB drive, but digital forensics never forgets.\n\nRecover the deleted files to find the hidden flag.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{d3l3t3d_but_n0t_f0rg0tt3n}',
      hints: ['Use file recovery tools like PhotoRec or TestDisk', 'Check the file system\'s unallocated space', 'Look for file signatures in raw data'],
      is_active: true
    },
    {
      title: 'EXIF Data Hunt',
      description: 'This photo was taken at a secret location. The photographer forgot to remove the metadata.\n\nExtract the GPS coordinates and other hidden information from the image.',
      category: 'Forensics',
      difficulty: 'easy',
      points: 120,
      flag: 'SEENAF{3x1f_d4t4_l34k5_l0c4t10n}',
      hints: ['Use exiftool to extract metadata', 'Look for GPS coordinates in EXIF data', 'Check for camera model and timestamp'],
      is_active: true
    },
    {
      title: 'Registry Forensics',
      description: 'A Windows system was compromised. The attacker modified registry keys to maintain persistence.\n\nAnalyze the registry hive to find evidence of the attack.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 400,
      flag: 'SEENAF{r3g1stry_p3rs1st3nc3_d3t3ct3d}',
      hints: ['Use tools like RegRipper or Registry Explorer', 'Check Run keys for persistence mechanisms', 'Look for unusual services or startup programs'],
      is_active: true
    },
    {
      title: 'Disk Image Analysis',
      description: 'We have a full disk image from a suspect\'s computer. Find the evidence hidden in the file system.\n\nMount and analyze the disk image to recover deleted evidence.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 450,
      flag: 'SEENAF{d1sk_1m4g3_4n4lys1s_m4st3r}',
      hints: ['Use Autopsy or FTK Imager to analyze the disk', 'Check deleted files and unallocated space', 'Look for hidden partitions or encrypted volumes'],
      is_active: true
    },
    {
      title: 'Log File Investigation',
      description: 'A web server was attacked. The evidence is buried in thousands of log entries.\n\nAnalyze the Apache access logs to find the attack pattern and extract the flag.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 180,
      flag: 'SEENAF{l0g_4n4lys1s_d3t3ct1v3}',
      hints: ['Look for unusual HTTP requests or response codes', 'Check for SQL injection or XSS attempts', 'Use grep or log analysis tools to filter entries'],
      is_active: true
    },
    {
      title: 'Mobile Forensics',
      description: 'We extracted data from a suspect\'s Android phone. The flag is hidden in the app data.\n\nAnalyze the mobile device backup to find incriminating evidence.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 380,
      flag: 'SEENAF{m0b1l3_f0r3ns1cs_und3rc0v3r}',
      hints: ['Use tools like ALEAPP or Cellebrite', 'Check SQLite databases in app folders', 'Look for deleted messages or call logs'],
      is_active: true
    },
    {
      title: 'Timeline Analysis',
      description: 'Create a timeline of events from this compromised system to understand the attack sequence.\n\nAnalyze file timestamps and system events to reconstruct what happened.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 220,
      flag: 'SEENAF{t1m3l1n3_r3c0nstruct10n}',
      hints: ['Use tools like log2timeline or Plaso', 'Check file creation, modification, and access times', 'Correlate events across different log sources'],
      is_active: true
    },
    {
      title: 'Encrypted Archive',
      description: 'We found a password-protected ZIP file on the suspect\'s computer. Crack it open!\n\nUse various techniques to break the encryption and access the hidden files.',
      category: 'Forensics',
      difficulty: 'medium',
      points: 240,
      flag: 'SEENAF{3ncrypt3d_4rch1v3_cr4ck3d}',
      hints: ['Try dictionary attacks with common passwords', 'Use tools like John the Ripper or hashcat', 'Check for weak encryption methods'],
      is_active: true
    },
    {
      title: 'Network Packet Carving',
      description: 'Files were transferred over the network, but the packets are fragmented and out of order.\n\nReassemble the network traffic to recover the transmitted files.',
      category: 'Forensics',
      difficulty: 'hard',
      points: 420,
      flag: 'SEENAF{p4ck3t_c4rv1ng_m4st3r}',
      hints: ['Use Wireshark to export objects from HTTP traffic', 'Check for file transfers in FTP or SMB protocols', 'Reassemble fragmented packets manually if needed'],
      is_active: true
    },
    {
      title: 'What\'s a NET?',
      description: 'How about you find the flag in this network capture?\n\nBasic network analysis challenge - find the flag in HTTP traffic.',
      category: 'Network',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{n3tw0rk_b4s1cs_ftw}',
      hints: ['Use Wireshark to analyze the PCAP', 'Look for HTTP GET/POST requests', 'The flag might be in plain text'],
      is_active: true
    },
    {
      title: 'Shark on Wire 1',
      description: 'We found this packet capture. Recover the flag.\n\nIntermediate network forensics - the flag is encoded or hidden in the traffic.',
      category: 'Network',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{sh4rk_0n_w1r3_1s_c00l}',
      hints: ['Use Wireshark\'s "Follow TCP Stream" feature', 'Look for base64 encoded data', 'Check different protocols (HTTP, FTP, etc.)'],
      is_active: true
    },
    {
      title: 'DNS Exfiltration',
      description: 'Data was exfiltrated through DNS queries. Can you recover it?\n\nAnalyze DNS traffic to find the hidden data.',
      category: 'Network',
      difficulty: 'medium',
      points: 250,
      flag: 'SEENAF{dns_3xf1ltr4t10n_d3t3ct3d}',
      hints: ['Look for unusual DNS queries', 'Check for data encoded in subdomain names', 'The data might be base64 encoded'],
      is_active: true
    },
    {
      title: 'TFTP Transfer',
      description: 'Figure out how they moved the flag using TFTP.\n\nThis challenge involves analyzing TFTP (Trivial File Transfer Protocol) traffic.',
      category: 'Network',
      difficulty: 'hard',
      points: 300,
      flag: 'SEENAF{tftp_f1l3_tr4nsf3r_pwn3d}',
      hints: ['Look for TFTP traffic in the capture', 'TFTP uses UDP port 69', 'Extract the transferred file'],
      is_active: true
    },
    // Additional Web Challenges
    {
      title: 'JWT Token Manipulation',
      description: 'This application uses JWT tokens for authentication. Can you forge an admin token?\n\nAnalyze and manipulate JWT tokens to gain unauthorized access.',
      category: 'Web',
      difficulty: 'hard',
      points: 400,
      flag: 'SEENAF{jwt_f0rg3ry_m4st3r}',
      hints: ['Decode the JWT token', 'Try the "none" algorithm attack', 'Look for weak signing keys'],
      is_active: true
    },
    {
      title: 'SSRF Exploitation',
      description: 'This web application fetches external resources. Can you make it fetch internal resources?\n\nExploit Server-Side Request Forgery to access internal services.',
      category: 'Web',
      difficulty: 'hard',
      points: 350,
      flag: 'SEENAF{ssrf_1nt3rn4l_4cc3ss}',
      hints: ['Try accessing localhost URLs', 'Use different protocols (file://, gopher://)', 'Bypass IP filtering with different encodings'],
      is_active: true
    },
    {
      title: 'Directory Traversal',
      description: 'This file viewer has a path traversal vulnerability. Can you read sensitive files?\n\nUse directory traversal techniques to access files outside the web root.',
      category: 'Web',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{d1r3ct0ry_tr4v3rs4l_pwn}',
      hints: ['Try ../ sequences', 'Look for /etc/passwd or similar files', 'Use URL encoding to bypass filters'],
      is_active: true
    },
    // Additional Crypto Challenges
    {
      title: 'RSA Weak Keys',
      description: 'This RSA implementation uses weak parameters. Can you factor the modulus?\n\nExploit weak RSA key generation to decrypt the message.',
      category: 'Crypto',
      difficulty: 'hard',
      points: 450,
      flag: 'SEENAF{rs4_w34k_k3ys_pwn3d}',
      hints: ['Check if the modulus is small', 'Try factoring with online tools', 'Look for common factors between keys'],
      is_active: true
    },
    {
      title: 'Hash Length Extension',
      description: 'This application uses a vulnerable hash construction. Can you extend the hash?\n\nExploit hash length extension attacks to forge valid signatures.',
      category: 'Crypto',
      difficulty: 'hard',
      points: 375,
      flag: 'SEENAF{h4sh_3xt3ns10n_4tt4ck}',
      hints: ['Use hash_extender tool', 'You need to know the secret length', 'Append your payload to the original message'],
      is_active: true
    },
    {
      title: 'Vigenère Cipher',
      description: 'Decrypt this Vigenère cipher to find the flag.\n\nFRRANS{i1t3n3r3_p1cu3r_1f_3nfb_c34fb}',
      category: 'Crypto',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{vigenere_cipher_is_easy_peasy}',
      hints: ['Try frequency analysis', 'The key might be a common word', 'Use online Vigenère solvers'],
      is_active: true
    },
    // Additional Network Challenges
    {
      title: 'WiFi Handshake',
      description: 'We captured a WiFi handshake. Can you crack the password?\n\nUse wireless security tools to crack the WPA2 handshake.',
      category: 'Network',
      difficulty: 'medium',
      points: 275,
      flag: 'SEENAF{w1f1_h4ndsh4k3_cr4ck3d}',
      hints: ['Use aircrack-ng with a wordlist', 'The password might be weak', 'Try common WiFi passwords'],
      is_active: true
    },
    {
      title: 'Bluetooth Analysis',
      description: 'This Bluetooth capture contains sensitive data. Find the flag.\n\nAnalyze Bluetooth Low Energy (BLE) traffic to extract hidden information.',
      category: 'Network',
      difficulty: 'hard',
      points: 325,
      flag: 'SEENAF{blu3t00th_sn1ff3r_pr0}',
      hints: ['Use Wireshark with Bluetooth support', 'Look for GATT characteristics', 'Check for unencrypted data transfers'],
      is_active: true
    },
    // Reverse Engineering Challenges
    {
      title: 'Simple Crackme',
      description: 'This binary asks for a password. Can you find it without running the program?\n\nReverse engineer the binary to find the correct password.',
      category: 'Reverse',
      difficulty: 'easy',
      points: 150,
      flag: 'SEENAF{r3v3rs3_3ng1n33r1ng_b4s1cs}',
      hints: ['Use strings command first', 'Try a disassembler like Ghidra', 'Look for string comparisons'],
      is_active: true
    },
    {
      title: 'Assembly Analysis',
      description: 'This assembly code contains the flag. Can you trace through the execution?\n\nAnalyze the assembly instructions to understand the program flow.',
      category: 'Reverse',
      difficulty: 'medium',
      points: 225,
      flag: 'SEENAF{4ss3mbly_4n4lys1s_pr0}',
      hints: ['Follow the jumps and branches', 'Track register values', 'Look for XOR operations'],
      is_active: true
    },
    {
      title: 'Packed Binary',
      description: 'This binary is packed with UPX. Unpack it and find the flag.\n\nUse unpacking tools to reveal the original binary.',
      category: 'Reverse',
      difficulty: 'medium',
      points: 275,
      flag: 'SEENAF{unp4ck3d_b1n4ry_succ3ss}',
      hints: ['Use UPX unpacker', 'Try upx -d command', 'Analyze the unpacked binary'],
      is_active: true
    },
    {
      title: 'Anti-Debug',
      description: 'This binary has anti-debugging techniques. Bypass them to get the flag.\n\nDefeat anti-debugging measures to analyze the program.',
      category: 'Reverse',
      difficulty: 'hard',
      points: 400,
      flag: 'SEENAF{4nt1_d3bug_byp4ss3d}',
      hints: ['Patch the anti-debug checks', 'Use advanced debugging techniques', 'Look for IsDebuggerPresent calls'],
      is_active: true
    },
    {
      title: 'Obfuscated Code',
      description: 'This code is heavily obfuscated. Can you deobfuscate it to find the flag?\n\nReverse engineer obfuscated code to reveal its true purpose.',
      category: 'Reverse',
      difficulty: 'hard',
      points: 375,
      flag: 'SEENAF{d30bfusc4t3d_c0d3_m4st3r}',
      hints: ['Look for string decryption routines', 'Trace through the obfuscation layers', 'Use dynamic analysis'],
      is_active: true
    },
    {
      title: 'Keygen Challenge',
      description: 'Create a keygen for this software. The flag is a valid serial number.\n\nReverse engineer the key validation algorithm.',
      category: 'Reverse',
      difficulty: 'hard',
      points: 450,
      flag: 'SEENAF{k3yg3n_4lg0r1thm_cr4ck3d}',
      hints: ['Find the key validation function', 'Understand the algorithm', 'Generate a valid key'],
      is_active: true
    },
    {
      title: 'Buffer Overflow',
      description: 'This program has a buffer overflow vulnerability. Exploit it to get the flag.\n\nCraft a payload to overflow the buffer and control program execution.',
      category: 'Pwn',
      difficulty: 'hard',
      points: 500,
      flag: 'SEENAF{buff3r_0v3rfl0w_pwn3d}',
      hints: ['Find the offset to overwrite return address', 'Use a debugger like GDB', 'Look for a win() function or similar'],
      is_active: true
    },
    {
      title: 'Format String',
      description: 'This program has a format string vulnerability. Can you exploit it?\n\nUse format string bugs to read memory and potentially execute code.',
      category: 'Pwn',
      difficulty: 'hard',
      points: 450,
      flag: 'SEENAF{f0rm4t_str1ng_3xpl01t}',
      hints: ['Use %x to read stack values', 'Try %s to read strings from memory', 'Use %n to write to memory'],
      is_active: true
    },
    // OSINT Challenges
    {
      title: 'Social Media Hunt',
      description: 'Find information about the user "hackerman2024" across social media platforms.\n\nUse open source intelligence techniques to gather information.',
      category: 'OSINT',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{0s1nt_s0c14l_m3d14_hunt3r}',
      hints: ['Check multiple social media platforms', 'Look for linked accounts', 'Use reverse image search'],
      is_active: true
    },
    {
      title: 'Geolocation',
      description: 'This photo was taken at a secret location. Can you find where?\n\nUse image analysis and geolocation techniques to identify the location.',
      category: 'OSINT',
      difficulty: 'hard',
      points: 350,
      flag: 'SEENAF{g30l0c4t10n_m4st3r}',
      hints: ['Check EXIF data for GPS coordinates', 'Use reverse image search', 'Look for landmarks or distinctive features'],
      is_active: true
    },
    {
      title: 'Username Investigation',
      description: 'Investigate the username "cyb3r_gh0st_2024" and find their real identity.\n\nUse OSINT techniques to trace digital footprints.',
      category: 'OSINT',
      difficulty: 'medium',
      points: 225,
      flag: 'SEENAF{us3rn4m3_tr4c3d_succ3ss}',
      hints: ['Search across multiple platforms', 'Check for password breaches', 'Look for email patterns'],
      is_active: true
    },
    // Steganography Challenges
    {
      title: 'LSB Steganography',
      description: 'This image hides a message in its least significant bits.\n\nExtract the hidden message using LSB steganography techniques.',
      category: 'Stego',
      difficulty: 'easy',
      points: 125,
      flag: 'SEENAF{lsb_st3g0_3xtr4ct3d}',
      hints: ['Use stegsolve or similar tools', 'Check the least significant bits', 'Try different color channels'],
      is_active: true
    },
    {
      title: 'Audio Frequency',
      description: 'This audio file contains a hidden message in specific frequencies.\n\nAnalyze the audio spectrum to find the hidden data.',
      category: 'Stego',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{4ud10_fr3qu3ncy_h1dd3n}',
      hints: ['Use Audacity or similar audio tools', 'Check the spectrogram', 'Look for patterns in specific frequencies'],
      is_active: true
    },
    {
      title: 'Polyglot File',
      description: 'This file is both a valid image and contains hidden data.\n\nFind the hidden content in this polyglot file.',
      category: 'Stego',
      difficulty: 'hard',
      points: 325,
      flag: 'SEENAF{p0lygl0t_f1l3_m4st3r}',
      hints: ['Check file headers and footers', 'Look for embedded files', 'Use hexdump to analyze structure'],
      is_active: true
    },
    {
      title: 'Text Steganography',
      description: 'This text document contains a hidden message using whitespace steganography.\n\nFind the message hidden in spaces and tabs.',
      category: 'Stego',
      difficulty: 'medium',
      points: 175,
      flag: 'SEENAF{wh1t3sp4c3_st3g0_pr0}',
      hints: ['Look at whitespace characters', 'Check for patterns in spaces and tabs', 'Use a hex editor'],
      is_active: true
    },
    // Miscellaneous Challenges
    {
      title: 'Programming Logic',
      description: 'Solve this programming puzzle to get the flag.\n\nImplement the correct algorithm to generate the flag.',
      category: 'Misc',
      difficulty: 'medium',
      points: 200,
      flag: 'SEENAF{pr0gr4mm1ng_l0g1c_s0lv3d}',
      hints: ['Understand the algorithm requirements', 'Test with sample inputs', 'Look for mathematical patterns'],
      is_active: true
    },
    {
      title: 'Esoteric Language',
      description: 'This code is written in an esoteric programming language. Execute it to get the flag.\n\nDecode and execute this unusual programming language.',
      category: 'Misc',
      difficulty: 'hard',
      points: 300,
      flag: 'SEENAF{3s0t3r1c_l4ngu4g3_m4st3r}',
      hints: ['Identify the programming language', 'Find an online interpreter', 'Common esoteric languages: Brainfuck, Whitespace, Malbolge'],
      is_active: true
    },
    {
      title: 'Game Hacking',
      description: 'This simple game has a high score system. Can you hack it to get the flag?\n\nModify the game to achieve an impossible score.',
      category: 'Misc',
      difficulty: 'medium',
      points: 250,
      flag: 'SEENAF{g4m3_h4ck1ng_ch4mp10n}',
      hints: ['Inspect the game files', 'Look for score validation', 'Try memory editing or file modification'],
      is_active: true
    },
    {
      title: 'QR Code Puzzle',
      description: 'These QR codes form a puzzle. Solve it to get the flag.\n\nCombine multiple QR codes to reveal the hidden message.',
      category: 'Misc',
      difficulty: 'easy',
      points: 100,
      flag: 'SEENAF{qr_c0d3_puzzl3_s0lv3d}',
      hints: ['Scan all QR codes', 'Look for patterns or sequences', 'Combine the decoded messages'],
      is_active: true
    }
  ];

  try {
    // Clear existing challenges first
    await supabase.from('challenges').delete().neq('id', '00000000-0000-0000-0000-000000000000');
    
    // Insert new challenges
    const { data, error } = await supabase
      .from('challenges')
      .insert(challenges)
      .select();

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true, count: data?.length || 0 };
    
  } catch (error: any) {
    return { success: false, error: error.message };
  }
};