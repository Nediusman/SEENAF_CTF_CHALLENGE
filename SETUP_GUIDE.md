# 🚀 Complete Setup Guide - SEENAF CTF Platform

This guide will help you set up the SEENAF CTF Platform on **any computer** from scratch.

---

## 📋 Prerequisites

Before starting, ensure you have:

### Required Software
1. **Node.js** (v18 or higher)
   - Download: https://nodejs.org/
   - Verify: `node --version` (should show v18+)
   
2. **npm** (comes with Node.js)
   - Verify: `npm --version`

3. **Git** (for cloning the repository)
   - Download: https://git-scm.com/
   - Verify: `git --version`

### Required Accounts
1. **Supabase Account** (free tier available)
   - Sign up: https://supabase.com/
   - You'll need this for the database

---

## 🎯 Step-by-Step Setup

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/seenaf-ctf-platform.git

# Navigate to the project directory
cd seenaf-ctf-platform
```

### Step 2: Install Dependencies

```bash
# Install all required packages
npm install

# This will take a few minutes...
```

### Step 3: Set Up Supabase

#### 3.1 Create a New Supabase Project

1. Go to https://app.supabase.com/
2. Click "New Project"
3. Fill in:
   - **Name**: SEENAF CTF Platform
   - **Database Password**: Choose a strong password (save it!)
   - **Region**: Choose closest to you
4. Click "Create new project"
5. Wait 2-3 minutes for setup to complete

#### 3.2 Get Your Supabase Credentials

1. In your Supabase project, go to **Settings** (gear icon) → **API**
2. You'll need these values:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **Project ID**: The `xxxxx` part of the URL
   - **anon/public key**: Long string starting with `eyJ...`

#### 3.3 Configure Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Open .env in your text editor
# Replace the placeholder values with your actual Supabase credentials
```

Your `.env` file should look like:
```env
VITE_SUPABASE_PROJECT_ID=fsyspwfjubhxpcuqivne
VITE_SUPABASE_PUBLISHABLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
VITE_SUPABASE_URL=https://fsyspwfjubhxpcuqivne.supabase.co
```

### Step 4: Set Up the Database

#### 4.1 Run the Main Setup Script

1. In Supabase, go to **SQL Editor** (left sidebar)
2. Click "New Query"
3. Open the file `complete-setup.sql` from this project
4. Copy ALL the contents
5. Paste into the Supabase SQL Editor
6. Click "Run" (or press Ctrl+Enter)
7. Wait for "Success" message

#### 4.2 Load Challenge Data

1. Still in SQL Editor, click "New Query"
2. Open the file `load-all-68-challenges.sql`
3. Copy and paste the contents
4. Click "Run"
5. You should see "68 challenges loaded successfully"

#### 4.3 Set Up Your Admin Account

1. **First, register a user account**:
   - Start the dev server (see Step 5)
   - Go to http://localhost:5173
   - Click "Sign Up"
   - Register with your email (remember this email!)

2. **Make yourself an admin**:
   - Go back to Supabase SQL Editor
   - Open `emergency-admin-fix-v2.sql`
   - Find this line:
     ```sql
     WHERE email = 'your-email@example.com'
     ```
   - Replace `your-email@example.com` with YOUR actual email
   - Run the script
   - You should see "Admin role granted successfully"

### Step 5: Start the Development Server

```bash
# Start the development server
npm run dev
```

You should see:
```
  VITE v5.4.19  ready in 500 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

### Step 6: Test Everything

1. **Open your browser** to http://localhost:5173
2. **Log in** with your admin account
3. **Test these features**:
   - ✅ View challenges on the home page
   - ✅ Click "Challenges" to see all 68 challenges
   - ✅ Try submitting a flag
   - ✅ Go to `/admin` to access admin panel
   - ✅ Create a test challenge in admin panel

---

## 🔧 Troubleshooting

### Problem: "Cannot connect to Supabase"

**Solution:**
1. Check your `.env` file has correct credentials
2. Verify your Supabase project is active (not paused)
3. Check internet connection
4. Restart the dev server: `Ctrl+C` then `npm run dev`

### Problem: "Admin panel shows 'Access Denied'"

**Solution:**
1. Make sure you ran `emergency-admin-fix-v2.sql`
2. Verify you used the correct email in the SQL script
3. Log out and log back in
4. Check the admin panel's "Emergency Admin Mode" toggle

### Problem: "No challenges showing"

**Solution:**
1. Make sure you ran `load-all-68-challenges.sql`
2. Check Supabase Table Editor → `challenges` table
3. If empty, re-run the load script
4. Clear browser cache and refresh

### Problem: "npm install fails"

**Solution:**
1. Delete `node_modules` folder and `package-lock.json`
2. Run `npm cache clean --force`
3. Run `npm install` again
4. If still failing, check Node.js version: `node --version` (needs v18+)

### Problem: "Port 5173 already in use"

**Solution:**
1. Kill the process using the port:
   - **Windows**: `netstat -ano | findstr :5173` then `taskkill /PID <PID> /F`
   - **Mac/Linux**: `lsof -ti:5173 | xargs kill -9`
2. Or use a different port: `npm run dev -- --port 3000`

---

## 🌐 Deploying to Production

### Option 1: Vercel (Recommended)

1. **Install Vercel CLI**:
   ```bash
   npm install -g vercel
   ```

2. **Deploy**:
   ```bash
   npm run build
   vercel
   ```

3. **Add environment variables** in Vercel dashboard:
   - Go to your project → Settings → Environment Variables
   - Add all variables from `.env`

### Option 2: Netlify

1. **Install Netlify CLI**:
   ```bash
   npm install -g netlify-cli
   ```

2. **Deploy**:
   ```bash
   npm run build
   netlify deploy --prod
   ```

3. **Add environment variables** in Netlify dashboard

### Option 3: Manual Deployment

1. **Build the project**:
   ```bash
   npm run build
   ```

2. **Upload the `dist/` folder** to your web host

3. **Configure environment variables** on your hosting platform

---

## 📦 What's Included

After setup, you'll have:

- ✅ **68 CTF Challenges** across 9 categories
- ✅ **User Authentication** system
- ✅ **Admin Panel** with full management tools
- ✅ **Leaderboard** system
- ✅ **Real-time scoring**
- ✅ **Challenge instance launcher**
- ✅ **Progress tracking**
- ✅ **Responsive design**

---

## 🔐 Security Notes

### Important Security Practices

1. **Never commit `.env` file** to Git
   - It's already in `.gitignore`
   - Always use `.env.example` as template

2. **Keep your Supabase credentials secret**
   - Don't share your anon key publicly
   - Never expose service role key in frontend

3. **Use Row Level Security (RLS)**
   - Already configured in setup scripts
   - Don't disable RLS in production

4. **Regular backups**
   - Supabase provides automatic backups
   - Export challenge data regularly

---

## 🆘 Getting Help

### Resources
- 📖 **Documentation**: See `COMPLETE_CODE_DOCUMENTATION.md`
- 🐛 **Issues**: https://github.com/yourusername/seenaf-ctf-platform/issues
- 💬 **Discussions**: https://github.com/yourusername/seenaf-ctf-platform/discussions

### Common Questions

**Q: Can I use a different database?**
A: The platform is built specifically for Supabase. Using another database would require significant code changes.

**Q: Is this free to host?**
A: Yes! Supabase free tier + Vercel/Netlify free tier = completely free hosting.

**Q: Can I customize the challenges?**
A: Absolutely! Use the admin panel to add/edit/delete challenges.

**Q: How do I add more users?**
A: Users can self-register. You can promote them to admin via the admin panel.

---

## ✅ Setup Checklist

Use this checklist to track your progress:

- [ ] Node.js installed (v18+)
- [ ] Git installed
- [ ] Repository cloned
- [ ] Dependencies installed (`npm install`)
- [ ] Supabase account created
- [ ] Supabase project created
- [ ] `.env` file configured
- [ ] Database setup script run (`complete-setup.sql`)
- [ ] Challenges loaded (`load-all-68-challenges.sql`)
- [ ] User account registered
- [ ] Admin role granted
- [ ] Dev server started (`npm run dev`)
- [ ] Platform tested in browser
- [ ] Admin panel accessible

---

## 🎉 You're All Set!

Congratulations! Your SEENAF CTF Platform is now ready to use.

**Next Steps:**
1. Customize the platform branding
2. Add your own challenges
3. Invite users to compete
4. Monitor the leaderboard
5. Have fun! 🏴‍☠️

---

**Need help?** Open an issue on GitHub or check the troubleshooting section above.
