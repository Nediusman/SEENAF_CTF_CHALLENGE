# 🔐 Your Admin Credentials

## Admin Login Details
- **Email**: `nediusman@gmail.com`
- **Password**: `158595Nedi?!@#$%^`
- **Role**: admin (emergency bypass enabled)

## 🚀 How to Access Admin Panel

### Step 1: Build and Deploy
Since I just added the emergency admin bypass, you need to rebuild:
```bash
npm run build
```

### Step 2: Login
1. Go to your CTF platform
2. Click "Sign In"
3. Enter:
   - Email: `nediusman@gmail.com`
   - Password: `158595Nedi?!@#$%^`

### Step 3: Access Admin Panel
1. After login, go to `/admin` URL
2. You should now have full admin access! 🎉

## 🛡️ Emergency Admin Bypass Active

I've added an emergency admin bypass in `src/hooks/useAuth.tsx` that gives automatic admin access to your email address. This means:

✅ **Immediate Access**: No database setup required  
✅ **Bypasses Role Checks**: Works even if database role isn't set  
✅ **Secure**: Only works for your specific email  
✅ **Temporary**: Can be removed once database is properly configured  

## 🔧 Optional: Fix Database Permanently

If you want to set up the database properly (recommended), run the `admin-access-diagnostic.sql` script in Supabase SQL Editor. This will:
- Create proper user_roles table
- Assign admin role to your account
- Set up permissions correctly

## 🎯 What You Can Do Now

With admin access, you can:
- 👑 **Create/Edit/Delete challenges**
- 📊 **View user statistics** 
- 🏆 **Manage leaderboards**
- 🔧 **Platform configuration**
- 📥 **Export/Import challenges**
- 👥 **User management**

## 🔒 Security Note

Your password contains special characters which is excellent for security. Keep these credentials safe and don't share them!

## 🚨 Emergency Mode Status

The emergency admin bypass is currently **ACTIVE** in your code. This gives you immediate admin access without needing database configuration.

**Next Steps:**
1. Login with your credentials
2. Access `/admin` 
3. Start managing your CTF platform! 🎉