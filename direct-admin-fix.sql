-- Direct Admin Fix - Run this in Supabase SQL Editor
-- This will fix the admin role issue and load challenges

-- Step 1: Check if user_roles table exists, create if not
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, role)
);

-- Step 2: Enable RLS on user_roles
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- Step 3: Create policy for user_roles
DROP POLICY IF EXISTS "Users can view their own roles" ON public.user_roles;
CREATE POLICY "Users can view their own roles" ON public.user_roles
    FOR SELECT USING (user_id = auth.uid());

-- Step 4: Force insert admin role (replace with your actual email)
DELETE FROM public.user_roles WHERE user_id IN (
    SELECT id FROM auth.users WHERE email = 'nediusman@gmail.com'
);

INSERT INTO public.user_roles (user_id, role)
SELECT id, 'admin'
FROM auth.users 
WHERE email = 'nediusman@gmail.com';

-- Step 5: Verify admin role was created
SELECT 
    'Admin Role Check' as test,
    u.email,
    ur.role,
    u.created_at
FROM auth.users u
JOIN public.user_roles ur ON u.id = ur.user_id
WHERE u.email = 'nediusman@gmail.com';

-- Step 6: Disable RLS temporarily for challenges
ALTER TABLE public.challenges DISABLE ROW LEVEL SECURITY;

-- Step 7: Clear and reload challenges
DELETE FROM public.challenges;

-- Step 8: Insert the 16 CTF challenges
INSERT INTO public.challenges (
    title, description, category, difficulty, points, flag, hints, is_active
) VALUES 
('Inspect HTML', 'Can you find the flag that''s hiding in this webpage? This is a basic web challenge where you need to examine the HTML source code of a webpage to find a hidden flag.', 'Web', 'easy', 100, 'SEENAF{1nsp3ct_th3_html_s0urc3}', ARRAY['Try right-clicking and selecting "View Page Source"', 'Look for HTML comments', 'The flag might be in a hidden div or comment'], true),

('Cookies', 'I heard you like cookies. Nom nom nom. This challenge involves manipulating browser cookies to access restricted content.', 'Web', 'easy', 150, 'SEENAF{c00k13_m0nst3r_0mg}', ARRAY['Check your browser''s cookies for this site', 'Try changing cookie values', 'Look for cookies named "admin" or "role"'], true),

('SQL Injection', 'Login as the admin user to get the flag. This login form is vulnerable to SQL injection. The admin username is "admin".', 'Web', 'medium', 250, 'SEENAF{sql_1nj3ct10n_1s_d4ng3r0us}', ARRAY['Try SQL injection in the password field', 'Use OR 1=1 to bypass authentication', 'Comment out the rest of the query with --'], true),

('XSS Playground', 'This comment system doesn''t properly sanitize user input. Can you execute JavaScript code? Find a way to execute JavaScript in the comment system.', 'Web', 'medium', 300, 'SEENAF{xss_4tt4ck_succ3ssful}', ARRAY['Try injecting <script> tags in comments', 'Use alert() to test XSS', 'Look for input fields that reflect user data'], true),

('The Numbers', 'The numbers... what do they mean? 13 9 3 15 3 20 6 { 20 8 5 14 21 13 2 5 18 19 13 1 19 15 14 }', 'Crypto', 'easy', 100, 'SEENAF{THENUMBERSMASON}', ARRAY['These look like numbers representing letters', 'A=1, B=2, C=3, etc.', 'Convert each number to its corresponding letter'], true),

('Caesar', 'Decrypt this message that was encrypted with a Caesar cipher. VHHQDI{FDHVDU_FLSKHU_LV_HDVB_SHDBV}', 'Crypto', 'easy', 150, 'SEENAF{CAESAR_CIPHER_IS_EASY_PEASY}', ARRAY['This is a Caesar cipher', 'Try different shift values', 'The shift is likely 3 (classic Caesar)'], true),

('Base64 Basics', 'Decode this Base64 encoded message to find the flag. U0VFTkFGe2Jhc2U2NF9pc19ub3RfZW5jcnlwdGlvbn0=', 'Crypto', 'easy', 75, 'SEENAF{base64_is_not_encryption}', ARRAY['This looks like Base64 encoding', 'Use an online Base64 decoder', 'Look for the = padding at the end'], true),

('ROT13 Message', 'Decrypt this ROT13 encoded message. FRRANS{ebg13_vf_whfg_n_pnrfne_pvcure}', 'Crypto', 'easy', 120, 'SEENAF{rot13_is_just_a_caesar_cipher}', ARRAY['ROT13 shifts each letter by 13 positions', 'A becomes N, B becomes O, etc.', 'Try an online ROT13 decoder'], true),

('File Extensions', 'This file doesn''t seem to be what it appears to be. Download the file and determine its real type to extract the flag.', 'Forensics', 'easy', 100, 'SEENAF{f1l3_3xt3ns10ns_l13}', ARRAY['Use the "file" command to check the real file type', 'The extension might be misleading', 'Try opening with different programs'], true),

('Hidden Message', 'This image looks innocent, but there''s a hidden message inside. Use steganography tools to find the hidden flag.', 'Forensics', 'medium', 200, 'SEENAF{st3g4n0gr4phy_m4st3r}', ARRAY['Use steganography tools like steghide', 'Try the strings command on the image', 'Check the image metadata with exiftool'], true),

('Wireshark Analysis', 'Can you find the flag in this network capture? Analyze the PCAP file to find suspicious network traffic containing the flag.', 'Forensics', 'medium', 250, 'SEENAF{n3tw0rk_tr4ff1c_4n4lys1s}', ARRAY['Use Wireshark to open the PCAP file', 'Look for HTTP traffic', 'Check POST requests and form data'], true),

('Memory Dump', 'We captured the memory of a compromised system. The attacker left traces. Analyze the memory dump to find the flag.', 'Forensics', 'hard', 350, 'SEENAF{m3m0ry_f0r3ns1cs_3xp3rt}', ARRAY['Use Volatility framework', 'Look for suspicious processes', 'Check for injected code or strings'], true),

('What''s a NET?', 'How about you find the flag in this network capture? Basic network analysis challenge - find the flag in HTTP traffic.', 'Network', 'easy', 100, 'SEENAF{n3tw0rk_b4s1cs_ftw}', ARRAY['Use Wireshark to analyze the PCAP', 'Look for HTTP GET/POST requests', 'The flag might be in plain text'], true),

('Shark on Wire 1', 'We found this packet capture. Recover the flag. Intermediate network forensics - the flag is encoded or hidden in the traffic.', 'Network', 'medium', 200, 'SEENAF{sh4rk_0n_w1r3_1s_c00l}', ARRAY['Use Wireshark''s "Follow TCP Stream" feature', 'Look for base64 encoded data', 'Check different protocols (HTTP, FTP, etc.)'], true),

('DNS Exfiltration', 'Data was exfiltrated through DNS queries. Can you recover it? Analyze DNS traffic to find the hidden data.', 'Network', 'medium', 250, 'SEENAF{dns_3xf1ltr4t10n_d3t3ct3d}', ARRAY['Look for unusual DNS queries', 'Check for data encoded in subdomain names', 'The data might be base64 encoded'], true),

('TFTP Transfer', 'Figure out how they moved the flag using TFTP. This challenge involves analyzing TFTP (Trivial File Transfer Protocol) traffic.', 'Network', 'hard', 300, 'SEENAF{tftp_f1l3_tr4nsf3r_pwn3d}', ARRAY['Look for TFTP traffic in the capture', 'TFTP uses UDP port 69', 'Extract the transferred file'], true);

-- Step 9: Re-enable RLS with working policies
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;

-- Step 10: Create simple, working RLS policies
DROP POLICY IF EXISTS "Anyone can view active challenges" ON public.challenges;
DROP POLICY IF EXISTS "Admins can do everything with challenges" ON public.challenges;

CREATE POLICY "Public can view active challenges" ON public.challenges
    FOR SELECT USING (is_active = true);

CREATE POLICY "Admins manage all challenges" ON public.challenges
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- Step 11: Final verification
SELECT 
    'FINAL RESULTS' as status,
    (SELECT COUNT(*) FROM public.challenges) as total_challenges,
    (SELECT COUNT(*) FROM public.user_roles WHERE role = 'admin') as admin_users,
    (SELECT email FROM auth.users WHERE id IN (SELECT user_id FROM public.user_roles WHERE role = 'admin')) as admin_email;

-- Step 12: Test challenge access
SELECT 
    'Challenge Categories' as info,
    category,
    COUNT(*) as count
FROM public.challenges 
GROUP BY category
ORDER BY category;