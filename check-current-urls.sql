-- Check what URLs are currently assigned to challenges
SELECT 
    category,
    title,
    instance_url,
    CASE 
        WHEN instance_url IS NULL THEN '❌ No URL'
        WHEN instance_url ILIKE '%github.com%' THEN '📁 GitHub File (may not exist)'
        WHEN instance_url ILIKE '%herokuapp.com%' THEN '🌐 Heroku App (may not exist)'
        WHEN instance_url ILIKE '%picoctf.org%' THEN '🎯 PicoCTF (external)'
        WHEN instance_url ILIKE '%cryptii.com%' OR instance_url ILIKE '%base64decode%' THEN '🔧 Working Tool'
        ELSE '❓ Other URL'
    END as url_status
FROM public.challenges 
ORDER BY category, title;