-- First, let's see what users exist
SELECT id, email, created_at FROM auth.users;

-- Replace 'your-email@example.com' with your actual email address
-- Run this to make yourself admin (replace the email!)
INSERT INTO user_roles (user_id, role)
SELECT id, 'admin'
FROM auth.users 
WHERE email = 'nediusman@gmail.com'  -- CHANGE THIS TO YOUR EMAIL
ON CONFLICT (user_id, role) DO NOTHING;

-- Verify you're now admin
SELECT u.email, ur.role 
FROM auth.users u
JOIN user_roles ur ON u.id = ur.user_id
WHERE u.email = 'nediusman@gmail.com';  -- CHANGE THIS TO YOUR EMAIL