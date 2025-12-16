-- Enable Launch Buttons for ALL Challenges
-- Run this in Supabase SQL Editor

-- Add instance URLs to ALL challenges by category

-- Web Challenges
UPDATE public.challenges 
SET instance_url = 'https://play.picoctf.org/practice/challenge/' || id
WHERE category = 'Web' AND instance_url IS NULL;

-- Crypto Challenges  
UPDATE public.challenges 
SET instance_url = 'https://cryptohack.org/challenges/introduction/'
WHERE category = 'Crypto' AND instance_url IS NULL;

-- Forensics Challenges
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/forensics-files/challenge-' || id
WHERE category = 'Forensics' AND instance_url IS NULL;

-- Network Challenges
UPDATE public.challenges 
SET instance_url = 'https://wireshark.org/download.html'
WHERE category = 'Network' AND instance_url IS NULL;

-- Reverse Engineering Challenges
UPDATE public.challenges 
SET instance_url = 'https://ghidra-sre.org/'
WHERE category = 'Reverse' AND instance_url IS NULL;

-- Binary Exploitation (Pwn) Challenges
UPDATE public.challenges 
SET instance_url = 'https://play.picoctf.org/practice/challenge/' || id
WHERE category = 'Pwn' AND instance_url IS NULL;

-- OSINT Challenges
UPDATE public.challenges 
SET instance_url = 'https://osintframework.com/'
WHERE category = 'OSINT' AND instance_url IS NULL;

-- Steganography Challenges
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/stego-files/challenge-' || id
WHERE category = 'Stego' AND instance_url IS NULL;

-- Miscellaneous Challenges
UPDATE public.challenges 
SET instance_url = 'https://play.picoctf.org/practice/challenge/' || id
WHERE category = 'Misc' AND instance_url IS NULL;

-- For any remaining challenges without URLs, add a generic one
UPDATE public.challenges 
SET instance_url = 'https://seenaf-ctf.com/challenge/' || id
WHERE instance_url IS NULL;

-- Verify ALL challenges now have launch buttons
SELECT 
    'SUMMARY' as type,
    COUNT(*) as total_challenges,
    COUNT(CASE WHEN instance_url IS NOT NULL THEN 1 END) as with_launch_button,
    COUNT(CASE WHEN instance_url IS NULL THEN 1 END) as without_launch_button
FROM public.challenges;

-- Show all challenges with their launch status
SELECT 
    title,
    category,
    difficulty,
    '🚀 Launch Available' as status,
    instance_url
FROM public.challenges 
ORDER BY category, difficulty, title;