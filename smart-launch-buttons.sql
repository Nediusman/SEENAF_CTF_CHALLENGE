-- SMART LAUNCH BUTTON ANALYSIS
-- Only add launch buttons where they're actually needed

-- ========================================
-- CHALLENGES that DON'T NEED LAUNCH BUTTONS
-- (Everything is provided in the description)
-- ========================================

/*
CRYPTO CHALLENGES - NO LAUNCH NEEDED:
1. "The Numbers" - Numbers given in description: 13 9 3 15 3 20 6...
2. "Caesar" - Cipher text given: VHHDQI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}
3. "Base64 Basics" - Base64 string given: U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=
4. "ROT13 Message" - ROT13 text given: FRRAQS{ebg13_vf_whfg_n_pnrfne_pvcure}
5. "Vigenère Cipher" - Cipher text given in description

SOME MISC CHALLENGES - NO LAUNCH NEEDED:
1. "QR Code Puzzle" - If QR codes are shown in description
2. "Programming Logic" - If algorithm is described in text

SOME REVERSE CHALLENGES - NO LAUNCH NEEDED:
1. "Assembly Analysis" - If assembly code is provided in description
*/

-- ========================================
-- CHALLENGES that DEFINITELY NEED LAUNCH BUTTONS
-- ========================================

/*
WEB CHALLENGES - NEED LIVE ENVIRONMENTS:
- All web challenges need actual web applications to test

FORENSICS CHALLENGES - NEED FILE DOWNLOADS:
- All forensics challenges need actual files to analyze
- Images, memory dumps, PCAP files, ZIP files, etc.

NETWORK CHALLENGES - NEED PCAP DOWNLOADS:
- All network challenges need packet capture files

REVERSE ENGINEERING - NEED BINARY DOWNLOADS:
- Most reverse challenges need actual executables
- Exception: Assembly code provided in text

PWN CHALLENGES - NEED VULNERABLE BINARIES:
- All pwn challenges need actual vulnerable programs

STEGANOGRAPHY - NEED FILES WITH HIDDEN DATA:
- All stego challenges need actual files with hidden content

OSINT CHALLENGES - MIXED:
- Some need investigation tools (links)
- Some need files to analyze
- Some might have all info in description
*/

-- ========================================
-- IMPLEMENTATION: SMART LAUNCH BUTTONS
-- ========================================

-- First, remove ALL instance URLs to start fresh
UPDATE public.challenges SET instance_url = NULL;

-- WEB CHALLENGES - All need live environments
UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/' || LOWER(REPLACE(title, ' ', '-'))
WHERE category = 'Web';

-- CRYPTO CHALLENGES - Most DON'T need launch buttons (cipher text in description)
-- Only add for challenges that need tools
UPDATE public.challenges 
SET instance_url = 'http://factordb.com/'
WHERE title = 'RSA Weak Keys';

UPDATE public.challenges 
SET instance_url = 'https://github.com/iagox86/hash_extender'
WHERE title = 'Hash Length Extension';

-- Leave other crypto challenges WITHOUT launch buttons (Base64, Caesar, ROT13, etc.)

-- FORENSICS CHALLENGES - All need file downloads
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-')) || 
    CASE 
        WHEN title ILIKE '%image%' OR title ILIKE '%photo%' OR title ILIKE '%qr%' THEN '.png'
        WHEN title ILIKE '%audio%' OR title ILIKE '%sound%' THEN '.wav'
        WHEN title ILIKE '%pcap%' OR title ILIKE '%wireshark%' OR title ILIKE '%network%' THEN '.pcap'
        WHEN title ILIKE '%zip%' OR title ILIKE '%archive%' THEN '.zip'
        WHEN title ILIKE '%pdf%' THEN '.pdf'
        WHEN title ILIKE '%memory%' OR title ILIKE '%dump%' THEN '.raw'
        WHEN title ILIKE '%disk%' THEN '.dd'
        WHEN title ILIKE '%email%' THEN '.eml'
        WHEN title ILIKE '%database%' THEN '.db'
        WHEN title ILIKE '%registry%' THEN '.reg'
        WHEN title ILIKE '%mobile%' THEN '.tar'
        WHEN title ILIKE '%malware%' OR title ILIKE '%executable%' THEN '.exe'
        ELSE '.bin'
    END
WHERE category = 'Forensics';

-- NETWORK CHALLENGES - All need PCAP downloads
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/network/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-')) || 
    CASE 
        WHEN title ILIKE '%wifi%' THEN '.cap'
        ELSE '.pcap'
    END
WHERE category = 'Network';

-- REVERSE ENGINEERING - Most need binary downloads
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/reverse/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-')) ||
    CASE 
        WHEN title ILIKE '%assembly%' THEN '.asm'
        WHEN title ILIKE '%windows%' OR title ILIKE '%exe%' THEN '.exe'
        ELSE ''
    END
WHERE category = 'Reverse' 
AND title NOT ILIKE '%assembly analysis%'; -- Skip if assembly code is in description

-- PWN CHALLENGES - All need vulnerable binaries
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/pwn/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-'))
WHERE category = 'Pwn';

-- OSINT CHALLENGES - Mixed approach
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%social%' OR title ILIKE '%username%' THEN 'https://osintframework.com/'
    WHEN title ILIKE '%geolocation%' OR title ILIKE '%photo%' THEN 'https://github.com/seenaf-ctf/osint/raw/main/location-photo.jpg'
    ELSE NULL
END
WHERE category = 'OSINT';

-- STEGANOGRAPHY - All need files with hidden data
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/stego/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-')) ||
    CASE 
        WHEN title ILIKE '%image%' OR title ILIKE '%lsb%' OR title ILIKE '%polyglot%' THEN '.png'
        WHEN title ILIKE '%audio%' OR title ILIKE '%frequency%' THEN '.wav'
        WHEN title ILIKE '%text%' THEN '.txt'
        ELSE '.bin'
    END
WHERE category = 'Stego';

-- MISCELLANEOUS - Only some need launch buttons
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%programming%' THEN 'https://replit.com/@seenaf-ctf/programming-logic'
    WHEN title ILIKE '%esoteric%' THEN 'https://github.com/seenaf-ctf/misc/raw/main/esoteric-code.bf'
    WHEN title ILIKE '%game%' THEN 'https://github.com/seenaf-ctf/misc/raw/main/hackable-game.zip'
    WHEN title ILIKE '%qr%' AND title NOT ILIKE '%puzzle%' THEN 'https://github.com/seenaf-ctf/misc/raw/main/qr-codes.zip'
    ELSE NULL
END
WHERE category = 'Misc';

-- ========================================
-- VERIFICATION: Show which challenges have launch buttons
-- ========================================

SELECT 
    category,
    title,
    CASE 
        WHEN instance_url IS NOT NULL THEN '🚀 HAS LAUNCH BUTTON'
        ELSE '📝 NO LAUNCH NEEDED'
    END as launch_status,
    CASE 
        WHEN instance_url IS NOT NULL THEN LEFT(instance_url, 40) || '...'
        ELSE 'All info provided in description'
    END as reason
FROM public.challenges 
ORDER BY category, 
         CASE WHEN instance_url IS NOT NULL THEN 0 ELSE 1 END,
         title;

-- Summary by category
SELECT 
    category,
    COUNT(*) as total_challenges,
    COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) as with_launch_buttons,
    COUNT(CASE WHEN instance_url IS NULL THEN 1 END) as no_launch_needed,
    ROUND(COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) * 100.0 / COUNT(*), 1) as launch_percentage
FROM public.challenges 
GROUP BY category
ORDER BY category;

-- Show challenges that DON'T need launch buttons
SELECT 
    '📝 CHALLENGES WITHOUT LAUNCH BUTTONS (Info in description):' as info;
    
SELECT 
    category,
    title,
    'All information provided in challenge description' as reason
FROM public.challenges 
WHERE instance_url IS NULL
ORDER BY category, title;

SELECT 
    '🚀 SMART LAUNCH SYSTEM COMPLETE!' as status,
    'Only challenges that actually need external resources have launch buttons!' as result;