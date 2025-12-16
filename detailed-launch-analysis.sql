-- DETAILED LAUNCH BUTTON ANALYSIS FOR ALL CHALLENGES
-- Based on actual challenge requirements and types

-- ========================================
-- ANALYSIS: What Each Challenge Type Needs
-- ========================================

/*
WEB CHALLENGES (7 total):
1. "Inspect HTML" - Needs: Live webpage to inspect
2. "Cookies" - Needs: Live web app with cookie manipulation
3. "SQL Injection" - Needs: Vulnerable login form
4. "XSS Playground" - Needs: Comment system to test XSS
5. "JWT Token Manipulation" - Needs: JWT-based web app
6. "SSRF Exploitation" - Needs: Web app that fetches URLs
7. "Directory Traversal" - Needs: File viewer web app

CRYPTO CHALLENGES (7 total):
1. "The Numbers" - Needs: Just cipher tools (online decoder)
2. "Caesar" - Needs: Caesar cipher decoder
3. "Base64 Basics" - Needs: Base64 decoder
4. "ROT13 Message" - Needs: ROT13 decoder
5. "RSA Weak Keys" - Needs: RSA factoring tools
6. "Hash Length Extension" - Needs: Hash extension tools
7. "Vigenère Cipher" - Needs: Vigenère cipher solver

FORENSICS CHALLENGES (32 total):
1. "File Extensions" - Needs: Download suspicious file
2. "Hidden Message" - Needs: Download image with steganography
3. "Wireshark Analysis" - Needs: Download PCAP file
4. "Memory Dump" - Needs: Download memory dump file
5. "Disk Image Analysis" - Needs: Download disk image
6. "PDF Malware" - Needs: Download malicious PDF
7. "Registry Forensics" - Needs: Download registry hives
8. "Mobile Forensics" - Needs: Download mobile backup
9. "Audio Steganography" - Needs: Download audio file
10. "Zip Password" - Needs: Download password-protected ZIP
11. "Timeline Analysis" - Needs: Download log files
12. "Malware Strings" - Needs: Download malware sample
13. "Email Headers" - Needs: Download email file
14. "Database Recovery" - Needs: Download corrupted database
15. "QR Code Forensics" - Needs: Download damaged QR image
16. "Deleted Files Recovery" - Needs: Download disk image
17. "EXIF Data Hunt" - Needs: Download photo with metadata
... (All forensics need file downloads)

NETWORK CHALLENGES (6 total):
1. "What's a NET?" - Needs: Download PCAP file
2. "Shark on Wire 1" - Needs: Download PCAP file
3. "DNS Exfiltration" - Needs: Download DNS traffic PCAP
4. "TFTP Transfer" - Needs: Download TFTP traffic PCAP
5. "WiFi Handshake" - Needs: Download WiFi capture
6. "Bluetooth Analysis" - Needs: Download Bluetooth capture

REVERSE ENGINEERING (6 total):
1. "Simple Crackme" - Needs: Download binary executable
2. "Assembly Analysis" - Needs: Download assembly file or binary
3. "Packed Binary" - Needs: Download UPX-packed binary
4. "Anti-Debug" - Needs: Download protected binary
5. "Obfuscated Code" - Needs: Download obfuscated binary
6. "Keygen Challenge" - Needs: Download software to crack

PWN CHALLENGES (3 total):
1. "Buffer Overflow" - Needs: Download vulnerable binary
2. "Format String" - Needs: Download vulnerable binary

OSINT CHALLENGES (3 total):
1. "Social Media Hunt" - Needs: Links to investigation tools
2. "Geolocation" - Needs: Download photo for analysis
3. "Username Investigation" - Needs: Links to search tools

STEGANOGRAPHY (4 total):
1. "LSB Steganography" - Needs: Download image with hidden data
2. "Audio Frequency" - Needs: Download audio file
3. "Polyglot File" - Needs: Download polyglot file
4. "Text Steganography" - Needs: Download text document

MISCELLANEOUS (4 total):
1. "Programming Logic" - Needs: Code environment or problem statement
2. "Esoteric Language" - Needs: Code file and interpreter links
3. "Game Hacking" - Needs: Download game files
4. "QR Code Puzzle" - Needs: Download QR code images
*/

-- ========================================
-- IMPLEMENTATION: SPECIFIC URLS FOR EACH CHALLENGE
-- ========================================

-- WEB CHALLENGES - Live environments
UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/inspect-html'
WHERE title = 'Inspect HTML';

UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/cookies'
WHERE title = 'Cookies';

UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/sql-injection'
WHERE title = 'SQL Injection';

UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/xss-playground'
WHERE title = 'XSS Playground';

UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/jwt-manipulation'
WHERE title = 'JWT Token Manipulation';

UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/ssrf-exploitation'
WHERE title = 'SSRF Exploitation';

UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/directory-traversal'
WHERE title = 'Directory Traversal';

-- CRYPTO CHALLENGES - Online tools
UPDATE public.challenges 
SET instance_url = 'https://www.dcode.fr/letter-number-cipher'
WHERE title = 'The Numbers';

UPDATE public.challenges 
SET instance_url = 'https://cryptii.com/pipes/caesar-cipher'
WHERE title = 'Caesar';

UPDATE public.challenges 
SET instance_url = 'https://www.base64decode.org/'
WHERE title = 'Base64 Basics';

UPDATE public.challenges 
SET instance_url = 'https://rot13.com/'
WHERE title = 'ROT13 Message';

UPDATE public.challenges 
SET instance_url = 'http://factordb.com/'
WHERE title = 'RSA Weak Keys';

UPDATE public.challenges 
SET instance_url = 'https://github.com/iagox86/hash_extender'
WHERE title = 'Hash Length Extension';

UPDATE public.challenges 
SET instance_url = 'https://www.dcode.fr/vigenere-cipher'
WHERE title = 'Vigenère Cipher';

-- FORENSICS CHALLENGES - File downloads
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/suspicious-file.txt'
WHERE title = 'File Extensions';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/hidden-message.png'
WHERE title = 'Hidden Message';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/network-capture.pcap'
WHERE title = 'Wireshark Analysis';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/memory-dump.raw'
WHERE title = 'Memory Dump';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/disk-image.dd'
WHERE title = 'Disk Image Analysis';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/malicious.pdf'
WHERE title = 'PDF Malware';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/registry-hives.zip'
WHERE title = 'Registry Forensics';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/mobile-backup.tar'
WHERE title = 'Mobile Forensics';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/hidden-audio.wav'
WHERE title = 'Audio Steganography';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/password-protected.zip'
WHERE title = 'Zip Password';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/system-logs.zip'
WHERE title = 'Timeline Analysis';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/malware-sample.exe'
WHERE title = 'Malware Strings';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/phishing-email.eml'
WHERE title = 'Email Headers';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/corrupted-database.db'
WHERE title = 'Database Recovery';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/damaged-qr.png'
WHERE title = 'QR Code Forensics';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/usb-image.dd'
WHERE title = 'Deleted Files Recovery';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/photo-with-gps.jpg'
WHERE title = 'EXIF Data Hunt';

-- Continue for all other forensics challenges...
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-')) || 
    CASE 
        WHEN title ILIKE '%image%' OR title ILIKE '%photo%' THEN '.jpg'
        WHEN title ILIKE '%audio%' OR title ILIKE '%sound%' THEN '.wav'
        WHEN title ILIKE '%pcap%' OR title ILIKE '%network%' THEN '.pcap'
        WHEN title ILIKE '%zip%' OR title ILIKE '%archive%' THEN '.zip'
        WHEN title ILIKE '%pdf%' THEN '.pdf'
        WHEN title ILIKE '%memory%' OR title ILIKE '%dump%' THEN '.raw'
        WHEN title ILIKE '%disk%' THEN '.dd'
        ELSE '.bin'
    END
WHERE category = 'Forensics' AND instance_url IS NULL;

-- NETWORK CHALLENGES - PCAP downloads
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/network/raw/main/basic-capture.pcap'
WHERE title = 'What''s a NET?';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/network/raw/main/shark-wire-1.pcap'
WHERE title = 'Shark on Wire 1';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/network/raw/main/dns-exfiltration.pcap'
WHERE title = 'DNS Exfiltration';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/network/raw/main/tftp-transfer.pcap'
WHERE title = 'TFTP Transfer';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/network/raw/main/wifi-handshake.cap'
WHERE title = 'WiFi Handshake';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/network/raw/main/bluetooth-capture.pcap'
WHERE title = 'Bluetooth Analysis';

-- REVERSE ENGINEERING - Binary downloads
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/reverse/raw/main/simple-crackme'
WHERE title = 'Simple Crackme';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/reverse/raw/main/assembly-challenge.asm'
WHERE title = 'Assembly Analysis';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/reverse/raw/main/packed-binary'
WHERE title = 'Packed Binary';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/reverse/raw/main/anti-debug-binary'
WHERE title = 'Anti-Debug';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/reverse/raw/main/obfuscated-binary'
WHERE title = 'Obfuscated Code';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/reverse/raw/main/keygen-challenge.exe'
WHERE title = 'Keygen Challenge';

-- PWN CHALLENGES - Vulnerable binaries
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/pwn/raw/main/buffer-overflow'
WHERE title = 'Buffer Overflow';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/pwn/raw/main/format-string'
WHERE title = 'Format String';

-- OSINT CHALLENGES - Investigation tools
UPDATE public.challenges 
SET instance_url = 'https://osintframework.com/'
WHERE title = 'Social Media Hunt';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/osint/raw/main/secret-location.jpg'
WHERE title = 'Geolocation';

UPDATE public.challenges 
SET instance_url = 'https://namechk.com/'
WHERE title = 'Username Investigation';

-- STEGANOGRAPHY - Files with hidden data
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/stego/raw/main/lsb-image.png'
WHERE title = 'LSB Steganography';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/stego/raw/main/frequency-audio.wav'
WHERE title = 'Audio Frequency';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/stego/raw/main/polyglot-file.jpg'
WHERE title = 'Polyglot File';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/stego/raw/main/whitespace-text.txt'
WHERE title = 'Text Steganography';

-- MISCELLANEOUS - Various resources
UPDATE public.challenges 
SET instance_url = 'https://replit.com/@seenaf-ctf/programming-logic'
WHERE title = 'Programming Logic';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/misc/raw/main/esoteric-code.bf'
WHERE title = 'Esoteric Language';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/misc/raw/main/hackable-game.zip'
WHERE title = 'Game Hacking';

UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/misc/raw/main/qr-puzzle.zip'
WHERE title = 'QR Code Puzzle';

-- ========================================
-- VERIFICATION: Show what each challenge gets
-- ========================================

SELECT 
    category,
    title,
    CASE 
        WHEN category = 'Web' THEN '🌐 Live Web App'
        WHEN category = 'Crypto' THEN '🔐 Cipher Tools'
        WHEN category = 'Forensics' THEN '📁 Download Files'
        WHEN category = 'Network' THEN '📁 Download PCAP'
        WHEN category = 'Reverse' THEN '📁 Download Binary'
        WHEN category = 'Pwn' THEN '📁 Download Binary'
        WHEN category = 'OSINT' THEN '🔍 Investigation Tools'
        WHEN category = 'Stego' THEN '📁 Download Files'
        WHEN category = 'Misc' THEN '🎲 Various Resources'
        ELSE '❓ Unknown'
    END as launch_type,
    LEFT(instance_url, 50) || '...' as url_preview
FROM public.challenges 
ORDER BY category, title;

-- Summary by category
SELECT 
    category,
    COUNT(*) as total_challenges,
    COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) as with_launch_buttons,
    CASE 
        WHEN category = 'Web' THEN 'Live web applications for testing'
        WHEN category = 'Crypto' THEN 'Online cipher and crypto tools'
        WHEN category = 'Forensics' THEN 'Downloadable evidence files'
        WHEN category = 'Network' THEN 'Network capture files (PCAP)'
        WHEN category = 'Reverse' THEN 'Executable binaries to analyze'
        WHEN category = 'Pwn' THEN 'Vulnerable binaries to exploit'
        WHEN category = 'OSINT' THEN 'Investigation and search tools'
        WHEN category = 'Stego' THEN 'Files with hidden data'
        WHEN category = 'Misc' THEN 'Programming environments and puzzles'
        ELSE 'Various resources'
    END as description
FROM public.challenges 
GROUP BY category
ORDER BY category;

SELECT '🎉 ANALYSIS COMPLETE!' as status,
       'All challenges categorized with appropriate launch functionality!' as result;