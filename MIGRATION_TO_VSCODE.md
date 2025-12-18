# 🔄 Migration Guide: Moving SEENAF_CTF to VS Code

Complete step-by-step guide to migrate your SEENAF_CTF project from any environment to VS Code.

## 🎯 **Quick Start (Automated)**

### **Option 1: Use Setup Script**
```bash
# Make script executable
chmod +x setup-vscode.sh

# Run setup script
./setup-vscode.sh
```

The script will automatically:
- ✅ Check prerequisites
- ✅ Copy project files
- ✅ Install dependencies
- ✅ Configure VS Code
- ✅ Install extensions
- ✅ Open project in VS Code

---

## 📋 **Manual Setup (Step by Step)**

### **Step 1: Prerequisites**

1. **Install Node.js**
   ```bash
   # Using NodeSource repository
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   
   # Verify installation
   node --version  # Should be v18+
   npm --version   # Should be 9+
   ```

2. **Install VS Code**
   ```bash
   # Download and install VS Code
   wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
   sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
   sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
   sudo apt update
   sudo apt install code
   ```

3. **Install Git (if not already installed)**
   ```bash
   sudo apt-get install git
   ```

### **Step 2: Project Migration**

1. **Create new project directory**
   ```bash
   mkdir ~/seenaf-ctf
   cd ~/seenaf-ctf
   ```

2. **Copy project files**
   ```bash
   # Copy from your current location
   cp -r /home/kali/Downloads/SEENAF_CTF_CHALLENGE/* ~/seenaf-ctf/
   
   # Or copy specific files if needed
   cp /path/to/current/project/{package.json,.env.example,src,public} ~/seenaf-ctf/
   ```

3. **Open in VS Code**
   ```bash
   code ~/seenaf-ctf
   ```

### **Step 3: Install Dependencies**

1. **Install project dependencies**
   ```bash
   cd ~/seenaf-ctf
   npm install
   ```

2. **If you get errors:**
   ```bash
   # Clear cache and try again
   npm cache clean --force
   rm -rf node_modules package-lock.json
   npm install
   ```

### **Step 4: Environment Setup**

1. **Create environment file**
   ```bash
   cp .env.example .env
   ```

2. **Edit .env with your credentials**
   ```bash
   # Open in VS Code
   code .env
   ```

3. **Add your Supabase credentials:**
   ```env
   VITE_SUPABASE_PROJECT_ID=fsyspwfjubhxpcuqivne
   VITE_SUPABASE_PUBLISHABLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   VITE_SUPABASE_URL=https://fsyspwfjubhxpcuqivne.supabase.co
   ```

### **Step 5: VS Code Configuration**

1. **Install recommended extensions**
   ```bash
   code --install-extension bradlc.vscode-tailwindcss
   code --install-extension esbenp.prettier-vscode
   code --install-extension ms-vscode.vscode-typescript-next
   code --install-extension formulahendry.auto-rename-tag
   code --install-extension christian-kohler.path-intellisense
   ```

2. **Create VS Code settings**
   ```bash
   mkdir .vscode
   ```

3. **Create .vscode/settings.json:**
   ```json
   {
     "typescript.preferences.importModuleSpecifier": "relative",
     "editor.formatOnSave": true,
     "editor.defaultFormatter": "esbenp.prettier-vscode",
     "editor.codeActionsOnSave": {
       "source.fixAll.eslint": true
     },
     "tailwindCSS.includeLanguages": {
       "typescript": "typescript",
       "typescriptreact": "typescriptreact"
     }
   }
   ```

### **Step 6: Test the Setup**

1. **Start development server**
   ```bash
   npm run dev
   ```

2. **Open browser**
   - Go to `http://localhost:5173`
   - Verify the application loads correctly

3. **Test hot reload**
   - Make a small change to any React component
   - Verify the browser updates automatically

---

## 🔧 **Project Structure Verification**

After migration, your project should have this structure:

```
seenaf-ctf/
├── .vscode/                # VS Code configuration
│   ├── settings.json
│   └── launch.json
├── public/                 # Static assets
│   ├── favicon.svg
│   ├── seenaf-ctf-icon.svg
│   └── manifest.json
├── src/                    # Source code
│   ├── components/
│   ├── controllers/
│   ├── hooks/
│   ├── pages/
│   ├── types/
│   └── utils/
├── supabase/              # Database migrations
├── *.sql                  # Database scripts
├── .env                   # Environment variables
├── .env.example           # Environment template
├── package.json           # Dependencies
├── vite.config.ts         # Vite configuration
├── tailwind.config.ts     # Tailwind configuration
└── tsconfig.json          # TypeScript configuration
```

---

## 🚀 **Development Workflow**

### **Daily Development Process**

1. **Open VS Code**
   ```bash
   code ~/seenaf-ctf
   ```

2. **Start development server**
   ```bash
   npm run dev
   ```

3. **Open browser to localhost:5173**

4. **Make changes and test**
   - Edit files in VS Code
   - Changes auto-reload in browser

5. **Commit changes (if using Git)**
   ```bash
   git add .
   git commit -m "Your changes"
   git push
   ```

### **Available Commands**

```bash
# Development
npm run dev              # Start dev server
npm run build           # Build for production
npm run preview         # Preview production build

# Code Quality
npm run lint            # Run ESLint
npm run type-check      # Check TypeScript

# Database
# Use Supabase dashboard for SQL scripts
```

---

## 🗃️ **Database Migration**

Your database setup remains the same:

1. **Access Supabase Dashboard**
   - Go to [supabase.com](https://supabase.com)
   - Open your project

2. **Run SQL Scripts**
   - Use SQL Editor in Supabase
   - Run your existing SQL files:
     - `fix-signup-complete.sql`
     - `load-all-68-challenges.sql`
     - `fix-submission-system-complete.sql`

3. **Verify Database**
   ```sql
   SELECT COUNT(*) FROM challenges;  -- Should return 68
   SELECT COUNT(*) FROM profiles;    -- Check user profiles
   ```

---

## 🔍 **Troubleshooting**

### **Common Issues**

#### **1. "Module not found" errors**
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

#### **2. Port 5173 already in use**
```bash
# Kill existing process
sudo lsof -t -i tcp:5173 | xargs kill -9

# Or use different port
npm run dev -- --port 3000
```

#### **3. TypeScript errors in VS Code**
- Press `Ctrl+Shift+P`
- Type "TypeScript: Restart TS Server"
- Press Enter

#### **4. Tailwind CSS not working**
```bash
# Restart development server
Ctrl+C
npm run dev
```

#### **5. Environment variables not loading**
- Ensure `.env` file is in project root
- Restart development server after changing `.env`
- Variables must start with `VITE_`

### **Performance Issues**

#### **Slow development server**
```bash
# Clear Vite cache
rm -rf node_modules/.vite
npm run dev
```

#### **High memory usage**
- Close unused browser tabs
- Restart VS Code
- Restart development server

---

## 📦 **Deployment from VS Code**

### **Build for Production**
```bash
npm run build
```

### **Deploy to Vercel**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

### **Deploy to Netlify**
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Build and deploy
npm run build
netlify deploy --prod --dir=dist
```

---

## 🎨 **VS Code Tips & Tricks**

### **Useful Shortcuts**
- `Ctrl+Shift+P` - Command Palette
- `Ctrl+`` - Toggle Terminal
- `Ctrl+Shift+E` - File Explorer
- `Ctrl+Shift+F` - Search in Files
- `Ctrl+D` - Select next occurrence
- `Alt+Shift+F` - Format document

### **Recommended Settings**
- Enable auto-save: `File > Auto Save`
- Enable word wrap: `View > Toggle Word Wrap`
- Show whitespace: `View > Render Whitespace`

### **Debugging**
- Set breakpoints by clicking line numbers
- Press `F5` to start debugging
- Use browser dev tools for React debugging

---

## ✅ **Migration Checklist**

- [ ] Node.js 18+ installed
- [ ] VS Code installed
- [ ] Project files copied to new location
- [ ] Dependencies installed (`npm install`)
- [ ] Environment variables configured (`.env`)
- [ ] VS Code extensions installed
- [ ] Development server starts (`npm run dev`)
- [ ] Application loads in browser
- [ ] Hot reload working
- [ ] Database connection working
- [ ] All 68 challenges loaded
- [ ] User registration/login working
- [ ] Admin panel accessible

---

## 🎉 **Success!**

Your SEENAF_CTF project is now successfully running in VS Code! You can:

- ✅ Edit code with full TypeScript support
- ✅ Use hot reload for instant feedback
- ✅ Debug with VS Code's powerful tools
- ✅ Manage your database through Supabase
- ✅ Deploy to production when ready

**Happy coding! 🚀**