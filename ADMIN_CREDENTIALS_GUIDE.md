# 🔐 Admin Credentials Setup Guide

## 🚨 IMPORTANT: No Default Admin Credentials

For security reasons, there are **NO hardcoded admin credentials** in this platform. You must create your own admin account securely.

## 📋 Step-by-Step Admin Setup

### Step 1: Create Your Account
1. Go to your deployed CTF platform
2. Click **"Sign Up"** 
3. Create an account with your desired admin email
4. Verify your email if required
5. **Remember your password** - you'll use this to log in as admin

### Step 2: Make Yourself Admin
1. Open your **Supabase Dashboard**
2. Go to **SQL Editor**
3. Open the file `create-secure-admin.sql`
4. **REPLACE** `'your-admin-email@example.com'` with your actual email (in 2 places)
5. **Run the SQL script**
6. You should see "✅ SUCCESS! Admin account created"

### Step 3: Access Admin Panel
1. **Log out** of your platform
2. **Log back in** with your email and password
3. Go to `/admin` URL
4. You should now have full admin access! 🎉

## 🔍 Troubleshooting

### Problem: "User not found" error
**Solution**: You need to sign up first through the platform UI

### Problem: Still no admin access
**Solution**: Run this SQL to check your account:
```sql
SELECT 
    u.email,
    p.role,
    u.id
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id
WHERE u.email = 'your-email@example.com';
```

### Problem: Database connection issues
**Solution**: Check your `.env` file has correct Supabase credentials

## 🛡️ Security Features

✅ **No hardcoded credentials** - Secure by design  
✅ **Database-based roles** - Proper permission system  
✅ **Email verification** - Prevents unauthorized access  
✅ **Encrypted passwords** - Handled by Supabase Auth  

## 🎯 What You Get as Admin

Once you're admin, you can:
- 👑 **Create/Edit/Delete challenges**
- 📊 **View user statistics** 
- 🏆 **Manage leaderboards**
- 🔧 **Platform configuration**
- 📥 **Export/Import challenges**
- 👥 **User management**

## 📞 Need Help?

If you're still having issues:
1. Check the `FINAL_ADMIN_SOLUTION.md` for emergency mode
2. Verify your Supabase database is properly set up
3. Make sure your `.env` file has correct credentials
4. Try the emergency SQL scripts in the project

## 🔑 Your Admin Credentials

After following this guide:
- **Email**: The email you signed up with
- **Password**: The password you chose during signup
- **Role**: admin (set by the SQL script)
- **Access**: Full admin panel at `/admin`

**Keep these credentials secure and don't share them!** 🔒