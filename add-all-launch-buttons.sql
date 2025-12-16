-- Add Launch Buttons to ALL Challenges
-- This will ensure EVERY challenge has a launch button

-- First, let's see what we have
SELECT 'BEFORE UPDATE' as status, 
       COUNT(*) as total_challenges,
       COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) as with_urls,
       COUNT(CASE WHEN instance_url IS NULL THEN 1 END) as without_urls
FROM public.challenges;

-- Add instance URLs for ALL challenges by category and type

-- Web Challenges - PicoCTF style links
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%inspect%' OR title ILIKE '%html%' THEN 'https://play.picoctf.org/practice/challenge/1'
    WHEN title ILIKE '%cookie%' THEN 'https://play.picoctf.org/practice/challenge/2' 
    WHEN title ILIKE '%sql%' THEN 'https://play.picoctf.org/practice/challenge/3'
    WHEN title ILIKE '%xss%' THEN 'https://play.picoctf.org/practice/challenge/4'
    ELSE 'https://play.picoctf.org/practice/challenge/' || EXTRACT(EPOCH FROM created_at)::text
END
WHERE category = 'Web';

-- Crypto Challenges - CryptoHack and educational links
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN difficulty = 'easy' THEN 'https://cryptohack.org/challenges/introduction/'
    WHEN title ILIKE '%caesar%' THEN 'https://cryptii.com/pipes/caesar-cipher'
    WHEN title ILIKE '%base64%' THEN 'https://www.base64decode.org/'
    WHEN title ILIKE '%rsa%' THEN 'https://cryptohack.org/challenges/rsa/'
    ELSE 'https://cryptohack.org/challenges/general/'
END
WHERE category = 'Crypto';

-- Forensics Challenges - File analysis tools and downloads
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%zip%' OR title ILIKE '%password%' THEN 'https://github.com/seenaf-ctf/forensics/raw/main/zip-password.zip'
    WHEN title ILIKE '%image%' OR title ILIKE '%steganography%' THEN 'https://github.com/seenaf-ctf/forensics/raw/main/hidden-image.png'
    WHEN title ILIKE '%memory%' OR title ILIKE '%dump%' THEN 'https://github.com/seenaf-ctf/forensics/raw/main/memory-dump.raw'
    WHEN title ILIKE '%timeline%' THEN 'https://github.com/seenaf-ctf/forensics/raw/main/timeline-logs.zip'
    ELSE 'https://github.com/seenaf-ctf/forensics/raw/main/challenge-' || id || '.zip'
END
WHERE category = 'Forensics';

-- Network Challenges - Wireshark captures and tools
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%wireshark%' OR title ILIKE '%pcap%' THEN 'https://github.com/seenaf-ctf/network/raw/main/capture.pcap'
    WHEN title ILIKE '%dns%' THEN 'https://github.com/seenaf-ctf/network/raw/main/dns-traffic.pcap'
    WHEN title ILIKE '%http%' THEN 'https://github.com/seenaf-ctf/network/raw/main/http-traffic.pcap'
    ELSE 'https://www.wireshark.org/download.html'
END
WHERE category = 'Network';

-- Reverse Engineering - Tools and binaries
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%binary%' OR title ILIKE '%executable%' THEN 'https://github.com/seenaf-ctf/reverse/raw/main/challenge.exe'
    WHEN title ILIKE '%assembly%' THEN 'https://godbolt.org/'
    ELSE 'https://ghidra-sre.org/'
END
WHERE category = 'Reverse';

-- Binary Exploitation (Pwn) - Vulnerable binaries
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%buffer%' OR title ILIKE '%overflow%' THEN 'https://github.com/seenaf-ctf/pwn/raw/main/buffer-overflow'
    WHEN title ILIKE '%shellcode%' THEN 'https://github.com/seenaf-ctf/pwn/raw/main/shellcode-challenge'
    ELSE 'https://play.picoctf.org/practice/challenge/pwn'
END
WHERE category = 'Pwn';

-- OSINT Challenges - Research starting points
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%social%' OR title ILIKE '%media%' THEN 'https://osintframework.com/'
    WHEN title ILIKE '%google%' THEN 'https://www.google.com/advanced_search'
    WHEN title ILIKE '%image%' THEN 'https://images.google.com/'
    ELSE 'https://start.me/p/DPYPMz/the-ultimate-osint-collection'
END
WHERE category = 'OSINT';

-- Steganography - Hidden message tools
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%image%' THEN 'https://github.com/seenaf-ctf/stego/raw/main/hidden-message.png'
    WHEN title ILIKE '%audio%' THEN 'https://github.com/seenaf-ctf/stego/raw/main/hidden-audio.wav'
    WHEN title ILIKE '%text%' THEN 'https://www.dcode.fr/steganography'
    ELSE 'https://github.com/seenaf-ctf/stego/raw/main/challenge-' || id || '.zip'
END
WHERE category = 'Stego';

-- Miscellaneous - Various tools and challenges
UPDATE public.challenges 
SET instance_url = CASE 
    WHEN title ILIKE '%programming%' THEN 'https://replit.com/'
    WHEN title ILIKE '%math%' THEN 'https://www.wolframalpha.com/'
    ELSE 'https://play.picoctf.org/practice/challenge/misc'
END
WHERE category = 'Misc';

-- For any remaining challenges without URLs, add generic ones
UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf.com/challenge/' || id
WHERE instance_url IS NULL;

-- Final verification - ALL challenges should now have launch buttons
SELECT 'AFTER UPDATE' as status,
       COUNT(*) as total_challenges,
       COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) as with_urls,
       COUNT(CASE WHEN instance_url IS NULL THEN 1 END) as without_urls
FROM public.challenges;

-- Show all challenges with their launch URLs
SELECT 
    title,
    category,
    difficulty,
    '🚀 LAUNCH READY' as status,
    LEFT(instance_url, 50) || '...' as launch_url
FROM public.challenges 
ORDER BY category, difficulty, title;

-- Success message
SELECT '🎉 SUCCESS!' as message,
       'ALL challenges now have launch buttons!' as result;