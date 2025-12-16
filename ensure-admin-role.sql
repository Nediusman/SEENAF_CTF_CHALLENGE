-- Ensure admin role for current user
-- Replace 'your-email@example.com' with your actual email

-- First, find your user ID
SELECT 'Finding user by email' as step;
SELECT id, email FROM auth.users WHERE email = 'nediusman@gmail.com';

-- Get the user ID and insert admin role
-- Replace the UUID below with your actual user ID from the query above
INSERT INTO user_roles (user_id, role) 
SELECT id, 'admin' 
FROM auth.users 
WHERE email = 'nediusman@gmail.com'
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';

-- Verify the role was set
SELECT 'Verifying admin role' as step;
SELECT ur.role, au.email, p.username
FROM user_roles ur
JOIN auth.users au ON ur.user_id = au.id
LEFT JOIN profiles p ON ur.user_id = p.id
WHERE au.email = 'nediusman@gmail.com';

-- Also check if the user has a profile
SELECT 'Checking user profile' as step;
SELECT id, username, total_score, created_at
FROM profiles 
WHERE id IN (
  SELECT id FROM auth.users WHERE email = 'nediusman@gmail.com'
);