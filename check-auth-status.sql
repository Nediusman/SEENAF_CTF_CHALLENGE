-- Check your authentication status
-- Run this in Supabase SQL Editor

-- 1. Check if you exist in auth.users
SELECT id, email, created_at, email_confirmed_at 
FROM auth.users 
WHERE email = 'nediusman@gmail.com';

-- 2. Check if you have a profile
SELECT * FROM public.profiles 
WHERE id IN (SELECT id FROM auth.users WHERE email = 'nediusman@gmail.com');

-- 3. Check if you have admin role
SELECT u.email, ur.role 
FROM auth.users u
LEFT JOIN public.user_roles ur ON u.id = ur.user_id
WHERE u.email = 'nediusman@gmail.com';

-- 4. Check challenges table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'challenges' 
ORDER BY ordinal_position;

-- 5. Check if challenges table has any data
SELECT COUNT(*) as total_challenges FROM public.challenges;

-- 6. Try to insert a simple challenge manually
INSERT INTO public.challenges (
  title, description, category, difficulty, points, flag, hints, is_active
) VALUES (
  'Manual Test Challenge',
  'This challenge was inserted manually via SQL to test the system.',
  'Web',
  'easy',
  50,
  'SEENAF{manual_insert_works}',
  ARRAY['This was inserted via SQL', 'Check if you can see this in the frontend'],
  true
);

-- 7. Verify the insert worked
SELECT id, title, category, difficulty, points, is_active 
FROM public.challenges 
WHERE title = 'Manual Test Challenge';