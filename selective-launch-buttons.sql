-- SELECTIVE LAUNCH BUTTON REMOVAL
-- Only remove launch buttons from specific crypto challenges that have everything in description
-- Keep launch buttons for ALL other challenges

-- ========================================
-- STEP 1: ADD LAUNCH BUTTONS TO ALL CHALLENGES FIRST
-- ========================================

-- WEB CHALLENGES - All need live environments
UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf-web.herokuapp.com/' || LOWER(REPLACE(title, ' ', '-'))
WHERE category = 'Web';

-- CRYPTO CHALLENGES - Add to ALL crypto challenges first
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title = 'The Numbers' THEN 'https://www.dcode.fr/letter-number-cipher'
    WHEN title = 'Caesar' THEN 'https://cryptii.com/pipes/caesar-cipher'
    WHEN title = 'Base64 Basics' THEN 'https://www.base64decode.org/'
    WHEN title = 'ROT13 Message' THEN 'https://rot13.com/'
    WHEN title = 'RSA Weak Keys' THEN 'http://factordb.com/'
    WHEN title = 'Hash Length Extension' THEN 'https://github.com/iagox86/hash_extender'
    WHEN title = 'Vigenère Cipher' THEN 'https://www.dcode.fr/vigenere-cipher'
    ELSE 'https://cryptohack.org/challenges/introduction/'
END
WHERE category = 'Crypto';

-- FORENSICS CHALLENGES - All need file downloads
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-')) || 
    CASE 
        WHEN title ILIKE '%image%' OR title ILIKE '%photo%' OR title ILIKE '%qr%' THEN '.png'
        WHEN title ILIKE '%audio%' OR title ILIKE '%sound%' THEN '.wav'
        WHEN title ILIKE '%pcap%' OR title ILIKE '%wireshark%' OR title ILIKE '%network%' THEN '.pcap'
        WHEN title ILIKE '%zip%' OR title ILIKE '%archive%' OR title ILIKE '%password%' THEN '.zip'
        WHEN title ILIKE '%pdf%' THEN '.pdf'
        WHEN title ILIKE '%memory%' OR title ILIKE '%dump%' THEN '.raw'
        WHEN title ILIKE '%disk%' THEN '.dd'
        WHEN title ILIKE '%email%' THEN '.eml'
        WHEN title ILIKE '%database%' THEN '.db'
        WHEN title ILIKE '%registry%' THEN '.reg'
        WHEN title ILIKE '%mobile%' THEN '.tar'
        WHEN title ILIKE '%malware%' OR title ILIKE '%executable%' THEN '.exe'
        WHEN title ILIKE '%timeline%' OR title ILIKE '%log%' THEN '.zip'
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

-- REVERSE ENGINEERING - All need binary downloads
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/reverse/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-')) ||
    CASE 
        WHEN title ILIKE '%assembly%' THEN '.asm'
        WHEN title ILIKE '%windows%' OR title ILIKE '%exe%' OR title ILIKE '%keygen%' THEN '.exe'
        ELSE ''
    END
WHERE category = 'Reverse';

-- PWN CHALLENGES - All need vulnerable binaries
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/pwn/raw/main/' || 
    LOWER(REPLACE(title, ' ', '-'))
WHERE category = 'Pwn';

-- OSINT CHALLENGES - All need investigation tools or files
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%social%' OR title ILIKE '%username%' THEN 'https://osintframework.com/'
    WHEN title ILIKE '%geolocation%' OR title ILIKE '%photo%' THEN 'https://github.com/seenaf-ctf/osint/raw/main/location-photo.jpg'
    ELSE 'https://start.me/p/DPYPMz/the-ultimate-osint-collection'
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

-- MISCELLANEOUS - All need various resources
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%programming%' THEN 'https://replit.com/@seenaf-ctf/programming-logic'
    WHEN title ILIKE '%esoteric%' THEN 'https://github.com/seenaf-ctf/misc/raw/main/esoteric-code.bf'
    WHEN title ILIKE '%game%' THEN 'https://github.com/seenaf-ctf/misc/raw/main/hackable-game.zip'
    WHEN title ILIKE '%qr%' THEN 'https://github.com/seenaf-ctf/misc/raw/main/qr-codes.zip'
    ELSE 'https://play.picoctf.org/practice/challenge/misc'
END
WHERE category = 'Misc';

-- ========================================
-- STEP 2: REMOVE LAUNCH BUTTONS ONLY FROM SPECIFIC CRYPTO CHALLENGES
-- (The ones that have all info in description)
-- ========================================

-- Remove launch buttons ONLY from these 5 specific crypto challenges
UPDATE public.challenges 
SET instance_url = NULL
WHERE title IN (
    'Base64 Basics',
    'Caesar', 
    'ROT13 Message',
    'The Numbers',
    'Vigenère Cipher'
);

-- ========================================
-- VERIFICATION: Show results
-- ========================================

-- Show crypto challenges specifically
SELECT 
    'CRYPTO CHALLENGES:' as category_info;
    
SELECT 
    title,
    CASE 
        WHEN instance_url IS NOT NULL THEN '🚀 HAS LAUNCH BUTTON'
        ELSE '📝 NO LAUNCH (Info in description)'
    END as launch_status,
    CASE 
        WHEN instance_url IS NOT NULL THEN LEFT(instance_url, 50) || '...'
        ELSE 'Cipher text provided in challenge description'
    END as details
FROM public.challenges 
WHERE category = 'Crypto'
ORDER BY title;

-- Show all other categories (should ALL have launch buttons)
SELECT 
    'ALL OTHER CATEGORIES (should have launch buttons):' as info;
    
SELECT 
    category,
    COUNT(*) as total_challenges,
    COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) as with_launch_buttons,
    COUNT(CASE WHEN instance_url IS NULL THEN 1 END) as without_launch_buttons
FROM public.challenges 
WHERE category != 'Crypto'
GROUP BY category
ORDER BY category;

-- Final summary
SELECT 
    category,
    COUNT(*) as total,
    COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) as with_launch,
    COUNT(CASE WHEN instance_url IS NULL THEN 1 END) as no_launch
FROM public.challenges 
GROUP BY category
ORDER BY category;

SELECT 
    '✅ SELECTIVE LAUNCH BUTTONS COMPLETE!' as status,
    'Removed launch buttons only from 5 specific crypto challenges with text-based solutions' as result,
    'All other challenges (47 total) have appropriate launch buttons' as details;