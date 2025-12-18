-- ADMIN CHALLENGE MANAGEMENT GUIDE
-- Complete guide for managing your 68 SEENAF_CTF challenges

-- ========================================
-- 1. VIEW ALL CHALLENGES
-- ========================================

-- View all challenges with basic info
SELECT 'ALL CHALLENGES OVERVIEW:' as info;
SELECT 
    id,
    title,
    category,
    difficulty,
    points,
    flag,
    is_active,
    created_at
FROM challenges 
ORDER BY category, difficulty, points;

-- Count challenges by category
SELECT 'CHALLENGES BY CATEGORY:' as info;
SELECT 
    category,
    COUNT(*) as count,
    SUM(points) as total_points
FROM challenges 
GROUP BY category 
ORDER BY count DESC;

-- Count challenges by difficulty
SELECT 'CHALLENGES BY DIFFICULTY:' as info;
SELECT 
    difficulty,
    COUNT(*) as count,
    AVG(points) as avg_points
FROM challenges 
GROUP BY difficulty 
ORDER BY 
    CASE difficulty 
        WHEN 'easy' THEN 1 
        WHEN 'medium' THEN 2 
        WHEN 'hard' THEN 3 
        WHEN 'insane' THEN 4 
    END;

-- ========================================
-- 2. SEARCH AND FILTER CHALLENGES
-- ========================================

-- Find challenges by title (replace 'XSS' with your search term)
SELECT 'SEARCH BY TITLE:' as info;
SELECT id, title, category, difficulty, points, flag
FROM challenges 
WHERE title ILIKE '%XSS%'
ORDER BY title;

-- Find challenges by category (replace 'Web' with desired category)
SELECT 'WEB CHALLENGES:' as info;
SELECT id, title, difficulty, points, flag, instance_url
FROM challenges 
WHERE category = 'Web'
ORDER BY difficulty, points;

-- Find challenges by difficulty
SELECT 'EASY CHALLENGES:' as info;
SELECT id, title, category, points, flag
FROM challenges 
WHERE difficulty = 'easy'
ORDER BY category, points;

-- Find inactive challenges
SELECT 'INACTIVE CHALLENGES:' as info;
SELECT id, title, category, difficulty, is_active
FROM challenges 
WHERE is_active = false
ORDER BY category;

-- ========================================
-- 3. ADD NEW CHALLENGES
-- ========================================

-- Template for adding a new challenge
/*
INSERT INTO challenges (title, description, category, difficulty, points, flag, hints, author, instance_url, is_active)
VALUES (
    'Your Challenge Title',
    'Detailed description of the challenge...',
    'Web', -- Web, Crypto, Forensics, Network, Reverse, Pwn, OSINT, Stego, Misc
    'medium', -- easy, medium, hard, insane
    200, -- Points (50-600)
    'SEENAF{your_flag_here}',
    ARRAY['Hint 1', 'Hint 2', 'Hint 3'], -- Can be NULL
    'Your Team Name', -- Can be NULL
    'https://your-challenge-url.com', -- Can be NULL for text-based challenges
    true -- is_active
);
*/

-- ========================================
-- 4. EDIT EXISTING CHALLENGES
-- ========================================

-- Update challenge title
/*
UPDATE challenges 
SET title = 'New Title'
WHERE id = 'challenge-uuid-here';
*/

-- Update challenge difficulty and points
/*
UPDATE challenges 
SET difficulty = 'hard', points = 300
WHERE title = 'Challenge Name';
*/

-- Update challenge flag
/*
UPDATE challenges 
SET flag = 'SEENAF{new_flag_here}'
WHERE title = 'Challenge Name';
*/

-- Add or update hints
/*
UPDATE challenges 
SET hints = ARRAY['New hint 1', 'New hint 2', 'New hint 3']
WHERE title = 'Challenge Name';
*/

-- Update instance URL
/*
UPDATE challenges 
SET instance_url = 'https://new-url.com'
WHERE title = 'Challenge Name';
*/

-- Activate/Deactivate challenge
/*
UPDATE challenges 
SET is_active = false -- or true
WHERE title = 'Challenge Name';
*/

-- ========================================
-- 5. DELETE CHALLENGES
-- ========================================

-- Delete a specific challenge (BE CAREFUL!)
/*
DELETE FROM challenges 
WHERE title = 'Challenge Name';
*/

-- Delete all challenges in a category (BE VERY CAREFUL!)
/*
DELETE FROM challenges 
WHERE category = 'CategoryName';
*/

-- ========================================
-- 6. BULK OPERATIONS
-- ========================================

-- Activate all challenges
/*
UPDATE challenges SET is_active = true;
*/

-- Deactivate all challenges in a category
/*
UPDATE challenges 
SET is_active = false 
WHERE category = 'Web';
*/

-- Update all challenge authors
/*
UPDATE challenges 
SET author = 'SEENAF Team' 
WHERE author IS NULL;
*/

-- Add points to all challenges in a category
/*
UPDATE challenges 
SET points = points + 50 
WHERE category = 'Crypto';
*/

-- ========================================
-- 7. BACKUP AND RESTORE
-- ========================================

-- Export all challenges (copy result to create backup)
SELECT 'BACKUP ALL CHALLENGES:' as info;
SELECT 
    'INSERT INTO challenges (title, description, category, difficulty, points, flag, hints, author, instance_url, is_active) VALUES' as sql_start;

SELECT 
    '(' || 
    '''' || REPLACE(title, '''', '''''') || ''', ' ||
    '''' || REPLACE(description, '''', '''''') || ''', ' ||
    '''' || category || ''', ' ||
    '''' || difficulty || ''', ' ||
    points || ', ' ||
    '''' || flag || ''', ' ||
    CASE 
        WHEN hints IS NULL THEN 'NULL'
        ELSE 'ARRAY[' || array_to_string(
            ARRAY(SELECT '''' || REPLACE(unnest(hints), '''', '''''') || ''''), 
            ', '
        ) || ']'
    END || ', ' ||
    CASE WHEN author IS NULL THEN 'NULL' ELSE '''' || REPLACE(author, '''', '''''') || '''' END || ', ' ||
    CASE WHEN instance_url IS NULL THEN 'NULL' ELSE '''' || instance_url || '''' END || ', ' ||
    is_active ||
    ')' ||
    CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY category, difficulty, points) = 
             (SELECT COUNT(*) FROM challenges) 
        THEN ';'
        ELSE ','
    END as sql_values
FROM challenges 
ORDER BY category, difficulty, points;

-- ========================================
-- 8. STATISTICS AND MONITORING
-- ========================================

-- Challenge solve rates
SELECT 'CHALLENGE SOLVE RATES:' as info;
SELECT 
    c.title,
    c.category,
    c.difficulty,
    c.points,
    COUNT(s.id) as total_attempts,
    COUNT(CASE WHEN s.is_correct THEN 1 END) as correct_solves,
    ROUND(
        COALESCE(
            COUNT(CASE WHEN s.is_correct THEN 1 END)::float / 
            NULLIF(COUNT(s.id), 0) * 100, 
            0
        ), 2
    ) as solve_rate_percent
FROM challenges c
LEFT JOIN submissions s ON c.id = s.challenge_id
GROUP BY c.id, c.title, c.category, c.difficulty, c.points
ORDER BY solve_rate_percent DESC;

-- Most popular challenges
SELECT 'MOST ATTEMPTED CHALLENGES:' as info;
SELECT 
    c.title,
    c.category,
    COUNT(s.id) as attempt_count
FROM challenges c
LEFT JOIN submissions s ON c.id = s.challenge_id
GROUP BY c.id, c.title, c.category
ORDER BY attempt_count DESC
LIMIT 10;

-- Hardest challenges (lowest solve rate)
SELECT 'HARDEST CHALLENGES:' as info;
SELECT 
    c.title,
    c.difficulty,
    c.points,
    COUNT(s.id) as attempts,
    COUNT(CASE WHEN s.is_correct THEN 1 END) as solves,
    ROUND(
        COALESCE(
            COUNT(CASE WHEN s.is_correct THEN 1 END)::float / 
            NULLIF(COUNT(s.id), 0) * 100, 
            0
        ), 2
    ) as solve_rate
FROM challenges c
LEFT JOIN submissions s ON c.id = s.challenge_id
GROUP BY c.id, c.title, c.difficulty, c.points
HAVING COUNT(s.id) > 0
ORDER BY solve_rate ASC, attempts DESC
LIMIT 10;

-- ========================================
-- 9. CURRENT STATUS
-- ========================================

SELECT 'CURRENT CHALLENGE STATUS:' as info;
SELECT 
    (SELECT COUNT(*) FROM challenges) as total_challenges,
    (SELECT COUNT(*) FROM challenges WHERE is_active = true) as active_challenges,
    (SELECT COUNT(*) FROM challenges WHERE is_active = false) as inactive_challenges,
    (SELECT SUM(points) FROM challenges WHERE is_active = true) as total_points_available,
    (SELECT COUNT(DISTINCT category) FROM challenges) as categories_count;

SELECT 'READY FOR ADMIN MANAGEMENT!' as status;