-- Quick Challenge Check
-- Run this in Supabase SQL Editor to see if challenges exist

-- Check if challenges table exists and has data
SELECT 'Challenge Count' as check_type, COUNT(*) as result
FROM public.challenges;

-- Show first 5 challenges
SELECT 'Sample Challenges' as check_type;
SELECT title, category, difficulty, points, is_active
FROM public.challenges 
ORDER BY created_at DESC 
LIMIT 5;

-- Check by category
SELECT 'By Category' as check_type;
SELECT category, COUNT(*) as count
FROM public.challenges 
GROUP BY category 
ORDER BY category;

-- Check if any challenges are active
SELECT 'Active Challenges' as check_type, COUNT(*) as result
FROM public.challenges 
WHERE is_active = true;