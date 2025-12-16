# 🏴‍☠️ SEENAF CTF Platform

<div align="center">

![SEENAF CTF](https://img.shields.io/badge/SEENAF-CTF%20Platform-00ff00?style=for-the-badge&logo=hackthebox&logoColor=white)
![React](https://img.shields.io/badge/React-18.3.1-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![TypeScript](https://img.shields.io/badge/TypeScript-5.8.3-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-Database-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind%20CSS-3.4.17-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white)

**A modern, feature-rich Capture The Flag (CTF) platform built for cybersecurity education and competitions.**

[🚀 Live Demo](#) • [📖 Documentation](#features) • [🛠️ Setup Guide](#installation) • [🤝 Contributing](#contributing)

</div>

---

## 🎯 Overview

SEENAF CTF Platform is a comprehensive cybersecurity training platform designed for hosting Capture The Flag competitions. Built with modern web technologies, it provides an authentic hacking experience with a terminal-inspired interface and professional-grade challenge management system.

### ✨ Key Highlights

- 🔐 **52 Pre-built Challenges** across 9 CTF categories
- 🎨 **Authentic Hacker Aesthetic** with terminal animations
- 👑 **Advanced Admin Panel** with comprehensive management tools
- 🏆 **Real-time Leaderboards** and scoring system
- 🚀 **Challenge Instance Launcher** for interactive challenges
- 📊 **Detailed Analytics** and progress tracking

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
- **Node.js** 18+ and npm (install with [nvm](https://github.com/nvm-sh/nvm))
- **Supabase Account** for database hosting
- **Git** for version control

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/seenaf-ctf-platform.git
   cd seenaf-ctf-platform
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your Supabase credentials
   ```

4. **Configure Supabase**
   - Create a new Supabase project
   - Run the SQL scripts in the `supabase/` directory
   - Update `.env` with your project credentials

5. **Start development server**
   ```bash
   npm run dev
   ```

6. **Set up admin access**
   - Run `emergency-admin-fix-v2.sql` in Supabase SQL Editor
   - Update the admin email in the script to your email

### Environment Variables

Create a `.env` file with the following variables:

```env
VITE_SUPABASE_PROJECT_ID=your_project_id
VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key
VITE_SUPABASE_URL=https://your-project.supabase.co
```

---

## 🎯 Challenge Categories

The platform includes **52 professionally crafted challenges** across these categories:

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
- 📖 Check the [documentation](#features)
- 🐛 Report bugs via [GitHub Issues](https://github.com/yourusername/seenaf-ctf-platform/issues)
- 💬 Join our [Discord community](#) (coming soon)
- 📧 Email support: support@seenaf.com

### Troubleshooting
- **Admin access issues**: Run `emergency-admin-fix-v2.sql`
- **Database connection**: Check Supabase credentials in `.env`
- **Build errors**: Clear `node_modules` and reinstall dependencies
- **Permission errors**: Use emergency admin mode in admin panel

---

<div align="center">

**Built with ❤️ for the cybersecurity community**

[⭐ Star this repo](https://github.com/Nediusman/seenaf-ctf-platform) • [🍴 Fork it](https://github.com/Nediusman/seenaf-ctf-platform/fork) • [📝 Report Issues](https://github.com/Nediusman/seenaf-ctf-platform/issues)

</div># SEENAF_CTF_CHALLENGE
