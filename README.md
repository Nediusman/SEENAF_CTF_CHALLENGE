# 🏴‍☠️ SEENAF CTF Platform

<div align="center">

![SEENAF CTF](https://img.shields.io/badge/SEENAF-CTF%20Platform-00ff00?style=for-the-badge&logo=hackthebox&logoColor=white)
![React](https://img.shields.io/badge/React-18.3.1-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![TypeScript](https://img.shields.io/badge/TypeScript-5.8.3-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-Database-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind%20CSS-3.4.17-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white)

**A modern, feature-rich Capture The Flag (CTF) platform built for cybersecurity education and competitions.**

**✨ Works on ANY computer - Windows, Mac, Linux, Docker ✨**

[🚀 Start Here](START_HERE.md) • [⚡ Quick Start](QUICK_START.md) • [📖 All Docs](DOCUMENTATION_INDEX.md) • [🤝 Contributing](CONTRIBUTING.md)

</div>

---

## 🎯 Overview

SEENAF CTF Platform is a comprehensive cybersecurity training platform designed for hosting Capture The Flag competitions. Built with modern web technologies, it provides an authentic hacking experience with a terminal-inspired interface and professional-grade challenge management system.

### ✨ Key Highlights

- 🔐 **68 Pre-built Challenges** across 9 CTF categories
- 🎨 **Authentic Hacker Aesthetic** with terminal animations
- 👑 **Advanced Admin Panel** with comprehensive management tools
- 🏆 **Real-time Leaderboards** and scoring system
- 🚀 **Challenge Instance Launcher** for interactive challenges
- 📊 **Detailed Analytics** and progress tracking
- 🌐 **Cross-Platform Setup** - Works on Windows, Mac, Linux, Docker
- 📚 **Comprehensive Documentation** - 8+ setup guides included

---

## 🚀 New to This Project?

**👉 Start here:** [START_HERE.md](START_HERE.md) - Choose your setup path and get running in 5-20 minutes!

We've created comprehensive documentation to help you get started on **any computer**:

- ⚡ **Fast Setup (5 min)**: [QUICK_START.md](QUICK_START.md)
- 🎨 **Visual Guide (15 min)**: [VISUAL_SETUP_GUIDE.md](VISUAL_SETUP_GUIDE.md)
- 📖 **Complete Guide (20 min)**: [SETUP_GUIDE.md](SETUP_GUIDE.md)
- 🖥️ **Platform-Specific**: [PLATFORM_SPECIFIC_SETUP.md](PLATFORM_SPECIFIC_SETUP.md)
- 📚 **All Documentation**: [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)

---

## 🌟 Features

### 🎮 Player Experience
- **User Authentication** - Secure registration and login system
- **Challenge Browser** - Filter by category, difficulty, and completion status
- **Interactive Challenges** - Launch live instances for hands-on practice
- **Progress Tracking** - Visual progress bars and achievement system
- **Leaderboards** - Real-time rankings and competitive scoring
- **Hint System** - Progressive hints to guide learning

### 👨‍💼 Admin Features
- **Challenge Management** - Create, edit, delete, and organize challenges
- **User Management** - Promote users, reset scores, and monitor activity
- **Bulk Operations** - Mass challenge operations and data export
- **Analytics Dashboard** - Comprehensive platform statistics
- **Emergency Admin Mode** - Bypass role checks for troubleshooting
- **Database Tools** - Built-in debugging and testing utilities

### 🎨 Design & UX
- **Terminal Aesthetic** - Authentic hacker-inspired interface
- **Matrix Animations** - Falling code background effects
- **Responsive Design** - Works perfectly on all devices
- **Dark Theme** - Easy on the eyes for long sessions
- **Smooth Animations** - Framer Motion powered transitions

---

## 🏗️ Tech Stack

### Frontend
- **React 18.3.1** - Modern UI library with hooks
- **TypeScript 5.8.3** - Type-safe development
- **Vite 5.4.19** - Lightning-fast build tool
- **Tailwind CSS 3.4.17** - Utility-first styling
- **Framer Motion 12.23.26** - Smooth animations
- **React Router 6.30.1** - Client-side routing

### Backend & Database
- **Supabase** - Backend-as-a-Service with PostgreSQL
- **Row Level Security** - Fine-grained access control
- **Real-time Subscriptions** - Live updates and notifications
- **Authentication** - Built-in user management

### UI Components
- **Radix UI** - Accessible component primitives
- **shadcn/ui** - Beautiful, customizable components
- **Lucide React** - Consistent icon library
- **Recharts** - Data visualization charts

---

## 🚀 Installation

### Prerequisites
- **Node.js** 18+ and npm ([Download here](https://nodejs.org/))
- **Supabase Account** ([Sign up free](https://supabase.com/))
- **Git** for version control

### ⚡ Quick Start (5 minutes)

```bash
# 1. Clone and install
git clone https://github.com/yourusername/seenaf-ctf-platform.git
cd seenaf-ctf-platform
npm install

# 2. Configure Supabase (automated)
npm run setup

# 3. Verify setup
npm run verify

# 4. Start development
npm run dev
```

**Then:**
1. Create a Supabase project at https://supabase.com/
2. Run `complete-setup.sql` in Supabase SQL Editor
3. Run `load-all-68-challenges.sql` to load challenges
4. Register an account in the app
5. Run `emergency-admin-fix-v2.sql` with your email to become admin

### 📖 Comprehensive Documentation

We've created extensive documentation to help you get started on **any computer**:

- 📚 **[DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)** - Complete guide to all docs
- ⚡ **[QUICK_START.md](QUICK_START.md)** - 5-minute setup guide
- 🎨 **[VISUAL_SETUP_GUIDE.md](VISUAL_SETUP_GUIDE.md)** - Step-by-step with visuals
- 📖 **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed instructions with troubleshooting
- 🖥️ **[PLATFORM_SPECIFIC_SETUP.md](PLATFORM_SPECIFIC_SETUP.md)** - Windows/Mac/Linux guides
- 📦 **[INSTALLATION_SUMMARY.md](INSTALLATION_SUMMARY.md)** - Quick reference
- 🚀 **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Production deployment
- 🤝 **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines

### Environment Variables

Your `.env` file should contain:

```env
VITE_SUPABASE_PROJECT_ID=your_project_id
VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key
VITE_SUPABASE_URL=https://your-project.supabase.co
```

Get these from: Supabase Dashboard → Settings → API

**Need help?** See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed instructions or run `npm run verify` to check your setup.

---

## 🎯 Challenge Categories

The platform includes **68 professionally crafted challenges** across these categories:

| Category | Count | Description |
|----------|-------|-------------|
| 🌐 **Web** | 7 | SQL injection, XSS, authentication bypasses |
| 🔐 **Crypto** | 7 | Classical ciphers, modern cryptography |
| 🔍 **Forensics** | 12 | File analysis, memory dumps, network captures |
| 🌐 **Network** | 6 | Packet analysis, protocol exploitation |
| ⚙️ **Reverse** | 6 | Binary analysis, code decompilation |
| 💥 **Pwn** | 3 | Buffer overflows, binary exploitation |
| 🕵️ **OSINT** | 3 | Open source intelligence gathering |
| 🖼️ **Stego** | 4 | Hidden data in images and files |
| 🎲 **Misc** | 4 | Logic puzzles, unconventional challenges |

---

## 📊 Database Schema

### Core Tables
- **`challenges`** - Challenge data and metadata
- **`profiles`** - User profiles and scores
- **`submissions`** - Flag submission history
- **`user_roles`** - Role-based access control

### Key Features
- **Row Level Security (RLS)** for data protection
- **Real-time subscriptions** for live updates
- **Automatic scoring** and leaderboard updates
- **Challenge visibility control** for admins

---

## 🛠️ Development

### Available Scripts

```bash
# Setup Supabase configuration (interactive)
npm run setup

# Verify your setup is correct
npm run verify

# Development server with hot reload
npm run dev

# Build for production
npm run build

# Build for development (with source maps)
npm run build:dev

# Lint code
npm run lint

# Preview production build
npm run preview
```

### Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── challenges/      # Challenge-specific components
│   ├── layout/          # Layout components
│   └── ui/              # shadcn/ui components
├── pages/               # Route components
├── hooks/               # Custom React hooks
├── utils/               # Utility functions
├── types/               # TypeScript type definitions
└── integrations/        # External service integrations
```

### Code Style
- **TypeScript** for type safety
- **ESLint** for code quality
- **Prettier** for consistent formatting
- **Conventional Commits** for clear history

---

## 🔧 Admin Setup

### Initial Admin Configuration

1. **Run the admin setup SQL**:
   ```sql
   -- Copy and paste emergency-admin-fix-v2.sql into Supabase SQL Editor
   ```

2. **Update admin email**:
   ```sql
   -- Replace 'your-email@example.com' with your actual email
   INSERT INTO user_roles (user_id, role)
   SELECT id, 'admin' FROM auth.users WHERE email = 'your-email@example.com';
   ```

3. **Test admin access**:
   - Log in with your admin email
   - Navigate to `/admin`
   - Use debug tools to verify permissions

### Admin Features
- ✅ Create, edit, and delete challenges
- ✅ Manage user accounts and permissions
- ✅ View platform analytics and statistics
- ✅ Export/import challenge data
- ✅ Emergency admin mode for troubleshooting

---

## 🚀 Deployment

### Build for Production

```bash
# Create optimized production build
npm run build

# The dist/ folder contains your deployable files
```

### Deployment Options

**Recommended Platforms:**
- **Vercel** - Zero-config deployment with GitHub integration
- **Netlify** - Continuous deployment with form handling
- **Railway** - Full-stack deployment with database
- **DigitalOcean App Platform** - Managed container deployment

### Environment Setup
1. Set environment variables in your hosting platform
2. Configure Supabase for production use
3. Update CORS settings in Supabase dashboard
4. Test all functionality in production environment

---

## 🤝 Contributing

We welcome contributions! Here's how to get started:

### Development Workflow

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Test thoroughly**
5. **Commit with conventional commits**
   ```bash
   git commit -m "feat: add amazing feature"
   ```
6. **Push and create a Pull Request**

### Contribution Guidelines
- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass
- Keep commits atomic and well-described

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Supabase** for the excellent backend platform
- **shadcn/ui** for beautiful, accessible components
- **Radix UI** for primitive components
- **Tailwind CSS** for utility-first styling
- **React** ecosystem for powerful development tools

---

## 📞 Support

### Getting Help
- 📖 **Quick Start**: See `QUICK_START.md` for 5-minute setup
- 📚 **Complete Guide**: See `SETUP_GUIDE.md` for detailed instructions
- 🖥️ **Platform-Specific**: See `PLATFORM_SPECIFIC_SETUP.md` for OS-specific help
- 🚀 **Deployment**: See `DEPLOYMENT_CHECKLIST.md` for production deployment
- 🐛 **Report bugs**: [GitHub Issues](https://github.com/yourusername/seenaf-ctf-platform/issues)
- 🤝 **Contributing**: See `CONTRIBUTING.md` for contribution guidelines

### Troubleshooting
- **Admin access issues**: Run `emergency-admin-fix-v2.sql`
- **Database connection**: Check Supabase credentials in `.env`
- **Build errors**: Clear `node_modules` and reinstall dependencies
- **Setup verification**: Run `npm run verify` to check your setup
- **Permission errors**: Use emergency admin mode in admin panel

### Quick Fixes
```bash
# Verify your setup
npm run verify

# Reset and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install

# Test Supabase connection
npm run dev
# Check browser console for connection status
```

---

<div align="center">

**Built with ❤️ for the cybersecurity community**

[⭐ Star this repo](https://github.com/Nediusman/seenaf-ctf-platform) • [🍴 Fork it](https://github.com/Nediusman/seenaf-ctf-platform/fork) • [📝 Report Issues](https://github.com/Nediusman/seenaf-ctf-platform/issues)

</div>
