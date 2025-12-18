-- VIEW YOUR CURRENT CHALLENGES
-- Run this in Supabase SQL Editor to see what's currently in your database

-- 1. Quick overview
SELECT 'CURRENT CHALLENGE COUNT:' as info;
SELECT COUNT(*) as total_challenges FROM challenges;

-- 2. Breakdown by category
SELECT 'CHALLENGES BY CATEGORY:' as info;
SELECT 
    category,
    COUNT(*) as count,
    MIN(points) as min_points,
    MAX(points) as max_points,
    SUM(points) as total_points
FROM challenges 
GROUP BY category 
ORDER BY count DESC;

-- 3. Active vs Inactive
SELECT 'ACTIVE STATUS:' as info;
SELECT 
    is_active,
    COUNT(*) as count
FROM challenges 
GROUP BY is_active;

-- 4. Sample of your challenges
SELECT 'SAMPLE CHALLENGES:' as info;
SELECT 
    title,
    category,
    difficulty,
    points,
    LEFT(flag, 20) || '...' as flag_preview,
    is_active
FROM challenges 
ORDER BY category, difficulty, points
LIMIT 20;

-- 5. Check if you have the 68 challenges loaded
SELECT 'VERIFICATION:' as info;
SELECT 
    CASE 
        WHEN COUNT(*) = 68 THEN '✅ You have all 68 challenges loaded!'
        WHEN COUNT(*) > 68 THEN '⚠️ You have MORE than 68 challenges (' || COUNT(*) || ')'
        WHEN COUNT(*) < 68 THEN '❌ You have FEWER than 68 challenges (' || COUNT(*) || ') - Run load-all-68-challenges.sql'
        ELSE 'Unknown status'
    END as status
FROM challenges;

-- 6. If you need to load the 68 challenges, uncomment this:
/*
-- First backup existing challenges
CREATE TABLE challenges_backup AS SELECT * FROM challenges;

-- Then load the 68 challenges
-- Copy and paste the content from load-all-68-challenges.sql here
*/