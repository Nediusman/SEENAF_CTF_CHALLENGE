-- Add Instance URLs to Challenges
-- Run this in Supabase SQL Editor to enable "Launch Instance" buttons

-- Update Web challenges with working instance URLs
UPDATE public.challenges 
SET instance_url = 'https://play.picoctf.org/practice/challenge/1'
WHERE title = 'Inspect HTML';

UPDATE public.challenges 
SET instance_url = 'https://play.picoctf.org/practice/challenge/2'
WHERE title = 'Cookies';

UPDATE public.challenges 
SET instance_url = 'https://play.picoctf.org/practice/challenge/3'
WHERE title = 'SQL Injection';

-- Update some Crypto challenges
UPDATE public.challenges 
SET instance_url = 'https://cryptohack.org/challenges/introduction/'
WHERE category = 'Crypto' AND difficulty = 'easy';

-- Update Forensics challenges with file download links
UPDATE public.challenges 
SET instance_url = 'https://github.com/seenaf-ctf/challenges/raw/main/forensics/'
WHERE category = 'Forensics';

-- Check which challenges now have instances
SELECT title, category, 
       CASE 
         WHEN instance_url IS NOT NULL THEN '✅ Has Instance'
         ELSE '❌ No Instance'
       END as status,
       instance_url
FROM public.challenges 
ORDER BY category, title;