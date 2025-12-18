# 🖥️ Platform-Specific Setup Instructions

This guide provides setup instructions for different operating systems.

---

## 🪟 Windows Setup

### Prerequisites Installation

1. **Install Node.js**
   - Download from: https://nodejs.org/
   - Choose "LTS" version (v18 or higher)
   - Run the installer
   - Check "Automatically install necessary tools" option
   - Verify installation:
     ```cmd
     node --version
     npm --version
     ```

2. **Install Git**
   - Download from: https://git-scm.com/download/win
   - Run the installer with default options
   - Verify: `git --version`

### Setup Steps

1. **Clone the repository**
   ```cmd
   git clone https://github.com/yourusername/seenaf-ctf-platform.git
   cd seenaf-ctf-platform
   ```

2. **Run automated setup**
   ```cmd
   setup-supabase.bat
   ```
   
   Or manually:
   ```cmd
   copy .env.example .env
   notepad .env
   ```

3. **Install dependencies**
   ```cmd
   npm install
   ```

4. **Start development server**
   ```cmd
   npm run dev
   ```

### Troubleshooting Windows

**Problem: "npm is not recognized"**
- Restart your terminal/command prompt
- Restart your computer
- Reinstall Node.js

**Problem: "Permission denied"**
- Run Command Prompt as Administrator
- Or use PowerShell with admin rights

**Problem: "Port already in use"**
```cmd
netstat -ano | findstr :5173
taskkill /PID <PID> /F
```

---

## 🍎 macOS Setup

### Prerequisites Installation

1. **Install Homebrew** (if not installed)
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Node.js**
   ```bash
   brew install node@18
   ```
   
   Or download from: https://nodejs.org/

3. **Install Git** (usually pre-installed)
   ```bash
   brew install git
   ```

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/seenaf-ctf-platform.git
   cd seenaf-ctf-platform
   ```

2. **Run automated setup**
   ```bash
   chmod +x setup-supabase.sh
   ./setup-supabase.sh
   ```
   
   Or use npm:
   ```bash
   npm run setup
   ```

3. **Install dependencies**
   ```bash
   npm install
   ```

4. **Start development server**
   ```bash
   npm run dev
   ```

### Troubleshooting macOS

**Problem: "Permission denied" when running scripts**
```bash
chmod +x setup-supabase.sh
chmod +x verify-setup.js
```

**Problem: "command not found: node"**
- Make sure Node.js is in your PATH
- Restart your terminal
- Try: `brew link node@18`

**Problem: "Port already in use"**
```bash
lsof -ti:5173 | xargs kill -9
```

---

## 🐧 Linux Setup

### Prerequisites Installation

#### Ubuntu/Debian
```bash
# Update package list
sudo apt update

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install Git
sudo apt install -y git

# Verify installations
node --version
npm --version
git --version
```

#### Fedora/RHEL/CentOS
```bash
# Install Node.js 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo dnf install -y nodejs

# Install Git
sudo dnf install -y git

# Verify installations
node --version
npm --version
git --version
```

#### Arch Linux
```bash
# Install Node.js and npm
sudo pacman -S nodejs npm git

# Verify installations
node --version
npm --version
git --version
```

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/seenaf-ctf-platform.git
   cd seenaf-ctf-platform
   ```

2. **Run automated setup**
   ```bash
   chmod +x setup-supabase.sh
   ./setup-supabase.sh
   ```
   
   Or use npm:
   ```bash
   npm run setup
   ```

3. **Install dependencies**
   ```bash
   npm install
   ```

4. **Start development server**
   ```bash
   npm run dev
   ```

### Troubleshooting Linux

**Problem: "EACCES: permission denied"**
```bash
# Fix npm permissions
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

**Problem: "Port already in use"**
```bash
# Find and kill process
lsof -ti:5173 | xargs kill -9

# Or use a different port
npm run dev -- --port 3000
```

**Problem: "Cannot find module"**
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

---

## 🐳 Docker Setup (All Platforms)

If you prefer using Docker:

### Create Dockerfile

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host"]
```

### Create docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "5173:5173"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - VITE_SUPABASE_URL=${VITE_SUPABASE_URL}
      - VITE_SUPABASE_PUBLISHABLE_KEY=${VITE_SUPABASE_PUBLISHABLE_KEY}
      - VITE_SUPABASE_PROJECT_ID=${VITE_SUPABASE_PROJECT_ID}
    env_file:
      - .env
```

### Run with Docker

```bash
# Build and start
docker-compose up

# Or with Docker only
docker build -t seenaf-ctf .
docker run -p 5173:5173 --env-file .env seenaf-ctf
```

---

## 🌐 Browser Requirements

### Supported Browsers
- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Opera 76+

### Required Browser Features
- JavaScript enabled
- LocalStorage enabled
- Cookies enabled
- WebSocket support

---

## 🔧 IDE Setup

### VS Code (Recommended)

**Install Extensions:**
```json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-typescript-next"
  ]
}
```

**Settings:**
```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

### WebStorm/IntelliJ IDEA

1. Enable ESLint: Settings → Languages & Frameworks → JavaScript → Code Quality Tools → ESLint
2. Enable Prettier: Settings → Languages & Frameworks → JavaScript → Prettier
3. Enable Tailwind CSS: Settings → Languages & Frameworks → Style Sheets → Tailwind CSS

---

## 📱 Mobile Development

### iOS (Safari)
- Use Safari Developer Tools
- Enable Web Inspector: Settings → Safari → Advanced → Web Inspector

### Android (Chrome)
- Use Chrome DevTools
- Enable USB Debugging: Settings → Developer Options → USB Debugging
- Access via: chrome://inspect

---

## 🆘 Common Issues Across All Platforms

### Issue: "Module not found"
```bash
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

### Issue: "Port already in use"
Use a different port:
```bash
npm run dev -- --port 3000
```

### Issue: "Out of memory"
Increase Node.js memory:
```bash
export NODE_OPTIONS="--max-old-space-size=4096"
npm run dev
```

### Issue: "Supabase connection failed"
1. Check `.env` file exists and has correct values
2. Verify Supabase project is active
3. Check internet connection
4. Run: `npm run verify`

---

## ✅ Verification

After setup on any platform, run:

```bash
npm run verify
```

This will check:
- ✓ Node.js version
- ✓ Dependencies installed
- ✓ Environment variables
- ✓ Supabase connection
- ✓ Database tables

---

## 📚 Additional Resources

- **Node.js**: https://nodejs.org/
- **npm**: https://www.npmjs.com/
- **Git**: https://git-scm.com/
- **Supabase**: https://supabase.com/docs
- **Vite**: https://vitejs.dev/

---

**Need help?** See `SETUP_GUIDE.md` or open an issue on GitHub.
