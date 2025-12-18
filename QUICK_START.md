# ⚡ Quick Start - SEENAF CTF Platform

Get up and running in **5 minutes**!

---

## 🚀 Super Fast Setup

### 1️⃣ Install Prerequisites

**Install Node.js** (if not already installed):
- Download from: https://nodejs.org/
- Choose LTS version (v18 or higher)
- Verify: `node --version`

### 2️⃣ Clone & Install

```bash
# Clone the repository
git clone https://github.com/yourusername/seenaf-ctf-platform.git
cd seenaf-ctf-platform

# Install dependencies
npm install
```

### 3️⃣ Set Up Supabase

**Option A: Automated Setup (Recommended)**
```bash
npm run setup
```
Follow the prompts to enter your Supabase credentials.

**Option B: Manual Setup**
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your Supabase credentials
# Get them from: https://app.supabase.com/project/YOUR_PROJECT/settings/api
```

### 4️⃣ Configure Database

1. Go to https://app.supabase.com/
2. Create a new project (or use existing)
3. Open **SQL Editor**
4. Run these scripts in order:
   - `complete-setup.sql` (sets up tables)
   - `load-all-68-challenges.sql` (loads challenges)

### 5️⃣ Start Development Server

```bash
npm run dev
```

Open http://localhost:5173 in your browser! 🎉

### 6️⃣ Create Admin Account

1. Register a new account in the app
2. In Supabase SQL Editor, run `emergency-admin-fix-v2.sql`
3. Update the email in the script to match your account
4. Log out and log back in
5. Access admin panel at `/admin`

---

## ✅ Verify Setup

Run the verification script to check everything:

```bash
npm run verify
```

This will check:
- ✓ Configuration files
- ✓ Environment variables
- ✓ Database connection
- ✓ Required tables
- ✓ Challenge data

---

## 🎯 What You Get

After setup, you'll have:

- **68 CTF Challenges** ready to solve
- **User authentication** system
- **Admin panel** for management
- **Real-time leaderboard**
- **Progress tracking**
- **Challenge launcher**

---

## 🆘 Troubleshooting

### "Cannot connect to Supabase"
- Check `.env` file has correct credentials
- Verify Supabase project is active
- Restart dev server

### "No challenges showing"
- Make sure you ran `load-all-68-challenges.sql`
- Check Supabase Table Editor → `challenges` table

### "Admin access denied"
- Run `emergency-admin-fix-v2.sql` with your email
- Log out and log back in
- Try Emergency Admin Mode toggle

### Need more help?
See the full **SETUP_GUIDE.md** for detailed instructions.

---

## 📚 Next Steps

- 📖 Read `COMPLETE_CODE_DOCUMENTATION.md` for code details
- 🎨 Customize the platform branding
- 🏆 Add your own challenges
- 🚀 Deploy to production (see `DEPLOYMENT_GUIDE.md`)

---

**Ready to hack? Let's go! 🏴‍☠️**
