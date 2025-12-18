# 🎯 START HERE - SEENAF CTF Platform

**Welcome!** This guide will help you get the SEENAF CTF Platform running on **any computer** in just a few minutes.

---

## 🚀 Three Ways to Get Started

Choose the path that works best for you:

### 1️⃣ Super Quick (5 minutes) ⚡

**Best for:** Experienced developers who want to get running fast

```bash
git clone <repo-url>
cd seenaf-ctf-platform
npm install
npm run setup
npm run verify
npm run dev
```

Then follow the prompts and run the SQL scripts in Supabase.

**Full guide:** [QUICK_START.md](QUICK_START.md)

---

### 2️⃣ Visual Guide (15 minutes) 🎨

**Best for:** First-time users who want step-by-step instructions with visuals

Follow the visual guide with screenshots and diagrams for each step.

**Full guide:** [VISUAL_SETUP_GUIDE.md](VISUAL_SETUP_GUIDE.md)

---

### 3️⃣ Complete Guide (20 minutes) 📖

**Best for:** Users who want detailed explanations and troubleshooting

Comprehensive guide with explanations for every step, plus troubleshooting for common issues.

**Full guide:** [SETUP_GUIDE.md](SETUP_GUIDE.md)

---

## 🖥️ Platform-Specific Instructions

Need OS-specific help?

- **Windows** → [PLATFORM_SPECIFIC_SETUP.md](PLATFORM_SPECIFIC_SETUP.md#-windows-setup)
- **macOS** → [PLATFORM_SPECIFIC_SETUP.md](PLATFORM_SPECIFIC_SETUP.md#-macos-setup)
- **Linux** → [PLATFORM_SPECIFIC_SETUP.md](PLATFORM_SPECIFIC_SETUP.md#-linux-setup)
- **Docker** → [PLATFORM_SPECIFIC_SETUP.md](PLATFORM_SPECIFIC_SETUP.md#-docker-setup-all-platforms)

---

## ✅ Prerequisites

Before you start, make sure you have:

- ✅ **Node.js 18+** ([Download](https://nodejs.org/))
- ✅ **Git** ([Download](https://git-scm.com/))
- ✅ **Supabase Account** ([Sign up free](https://supabase.com/))

**Check your installation:**
```bash
node --version  # Should show v18 or higher
npm --version   # Should show 9 or higher
git --version   # Any recent version
```

---

## 🎯 What You'll Get

After setup, you'll have:

```
✅ 68 CTF Challenges across 9 categories
✅ User authentication system
✅ Admin panel for management
✅ Real-time leaderboard
✅ Progress tracking
✅ Challenge instance launcher
✅ Responsive design
✅ Dark hacker theme
```

---

## 📚 All Documentation

Can't find what you need? Check the complete documentation index:

**[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete guide to all documentation

### Quick Links

- 📖 [README.md](README.md) - Project overview
- ⚡ [QUICK_START.md](QUICK_START.md) - Fast setup
- 🎨 [VISUAL_SETUP_GUIDE.md](VISUAL_SETUP_GUIDE.md) - Visual guide
- 📖 [SETUP_GUIDE.md](SETUP_GUIDE.md) - Detailed setup
- 🖥️ [PLATFORM_SPECIFIC_SETUP.md](PLATFORM_SPECIFIC_SETUP.md) - OS-specific
- 📦 [INSTALLATION_SUMMARY.md](INSTALLATION_SUMMARY.md) - Quick reference
- 🚀 [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Production deployment
- 👨‍💼 [ADMIN_CHALLENGE_MANAGEMENT_GUIDE.md](ADMIN_CHALLENGE_MANAGEMENT_GUIDE.md) - Admin guide
- 🤝 [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- 💻 [COMPLETE_CODE_DOCUMENTATION.md](COMPLETE_CODE_DOCUMENTATION.md) - Code docs

---

## 🆘 Need Help?

### Quick Troubleshooting

**Problem: "Cannot connect to Supabase"**
```bash
# Check your .env file
cat .env

# Verify setup
npm run verify

# Restart dev server
npm run dev
```

**Problem: "No challenges showing"**
- Make sure you ran `load-all-68-challenges.sql` in Supabase SQL Editor

**Problem: "Admin access denied"**
- Run `emergency-admin-fix-v2.sql` with your email
- Log out and log back in

### More Help

- 📖 Check [SETUP_GUIDE.md](SETUP_GUIDE.md) troubleshooting section
- 🐛 [Open an issue](https://github.com/yourusername/seenaf-ctf-platform/issues)
- 💬 Check existing issues for solutions

---

## 🎉 Ready to Start?

Pick your path above and let's get started!

**Recommended for most users:** Start with [VISUAL_SETUP_GUIDE.md](VISUAL_SETUP_GUIDE.md)

---

## 📊 Setup Overview

Here's what the setup process looks like:

```
1. Install Prerequisites (Node.js, Git)
   ↓
2. Clone Repository
   ↓
3. Install Dependencies (npm install)
   ↓
4. Create Supabase Project
   ↓
5. Configure Environment (.env file)
   ↓
6. Run Database Scripts (SQL)
   ↓
7. Verify Setup (npm run verify)
   ↓
8. Start Dev Server (npm run dev)
   ↓
9. Create Admin Account
   ↓
10. Test Everything
   ↓
🎉 Success! Platform is ready!
```

**Total time:** 15-20 minutes

---

## 🔧 Automated Setup

We provide automated setup scripts for all platforms:

**Windows:**
```cmd
setup-supabase.bat
```

**macOS/Linux:**
```bash
chmod +x setup-supabase.sh
./setup-supabase.sh
```

**Or use npm:**
```bash
npm run setup
```

These scripts will:
- ✅ Create your `.env` file
- ✅ Prompt for Supabase credentials
- ✅ Install dependencies
- ✅ Test connection

---

## 🎓 Learning Path

**New to CTF platforms?**

1. Start with [README.md](README.md) to understand what this is
2. Follow [VISUAL_SETUP_GUIDE.md](VISUAL_SETUP_GUIDE.md) to set it up
3. Read [ADMIN_CHALLENGE_MANAGEMENT_GUIDE.md](ADMIN_CHALLENGE_MANAGEMENT_GUIDE.md) to learn admin features
4. Check [COMPLETE_CODE_DOCUMENTATION.md](COMPLETE_CODE_DOCUMENTATION.md) to understand the code

**Want to contribute?**

1. Set up the platform (any guide above)
2. Read [CONTRIBUTING.md](CONTRIBUTING.md)
3. Check [COMPLETE_CODE_DOCUMENTATION.md](COMPLETE_CODE_DOCUMENTATION.md)
4. Pick an issue or create a feature

**Ready to deploy?**

1. Complete local setup first
2. Follow [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
3. Use [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
4. Monitor and maintain

---

## 💡 Pro Tips

- ✅ Run `npm run verify` after setup to check everything
- ✅ Use `npm run setup` for automated configuration
- ✅ Keep your `.env` file secret (it's in `.gitignore`)
- ✅ Bookmark [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) for quick reference
- ✅ Check browser console for helpful connection messages
- ✅ Use Emergency Admin Mode if you have permission issues

---

## 🌟 What Makes This Special?

- **Complete Documentation** - 8+ comprehensive guides
- **Cross-Platform** - Works on Windows, Mac, Linux
- **Automated Setup** - Scripts for easy configuration
- **Verification Tools** - Check your setup automatically
- **Visual Guides** - Step-by-step with screenshots
- **Troubleshooting** - Solutions for common issues
- **Production Ready** - Deployment guides included

---

## 📞 Support

- 📖 **Documentation**: See [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)
- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/seenaf-ctf-platform/issues)
- 🤝 **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)

---

<div align="center">

**🎉 Let's build something awesome! 🎉**

Choose your setup path above and get started in minutes!

[⚡ Quick Start](QUICK_START.md) • [🎨 Visual Guide](VISUAL_SETUP_GUIDE.md) • [📖 Complete Guide](SETUP_GUIDE.md)

</div>
