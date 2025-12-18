# 🚀 VS Code Setup Guide for SEENAF_CTF

Complete guide to run your SEENAF_CTF project in VS Code or any other code editor.

## 📋 **Prerequisites**

### 1. **Install Required Software**
```bash
# Node.js (v18 or higher)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Or using nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18

# Git
sudo apt-get install git

# VS Code (optional)
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
```

### 2. **Verify Installation**
```bash
node --version    # Should show v18+
npm --version     # Should show 9+
git --version     # Should show git version
```

---

## 📁 **Project Setup**

### **Method 1: Copy from Current Location**

1. **Copy your project folder**
   ```bash
   # Copy the entire project to your desired location
   cp -r /home/kali/Downloads/SEENAF_CTF_CHALLENGE ~/seenaf-ctf
   cd ~/seenaf-ctf
   ```

2. **Open in VS Code**
   ```bash
   code .
   ```

### **Method 2: Clone from Git (if you have a repository)**

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/seenaf-ctf.git
   cd seenaf-ctf
   ```

2. **Open in VS Code**
   ```bash
   code .
   ```

### **Method 3: Create New Project from Scratch**

1. **Create new directory**
   ```bash
   mkdir seenaf-ctf
   cd seenaf-ctf
   ```

2. **Initialize project**
   ```bash
   npm init -y
   ```

3. **Copy files from your current project**
   - Copy all files from your current project directory
   - Or recreate using the guide below

---

## 🛠️ **VS Code Extensions (Recommended)**

Install these extensions for better development experience:

```bash
# Install via command line
code --install-extension bradlc.vscode-tailwindcss
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension formulahendry.auto-rename-tag
code --install-extension christian-kohler.path-intellisense
code --install-extension ms-vscode.vscode-json
code --install-extension ms-vscode-remote.remote-containers
```

**Or install via VS Code:**
- **Tailwind CSS IntelliSense** - Autocomplete for Tailwind classes
- **Prettier** - Code formatter
- **TypeScript and JavaScript Language Features** - Enhanced TS support
- **Auto Rename Tag** - Automatically rename paired HTML/JSX tags
- **Path Intellisense** - Autocomplete filenames
- **JSON** - JSON language support

---

## 📦 **Install Dependencies**

1. **Navigate to project directory**
   ```bash
   cd ~/seenaf-ctf
   ```

2. **Install all dependencies**
   ```bash
   npm install
   ```

3. **If you get errors, try:**
   ```bash
   # Clear npm cache
   npm cache clean --force
   
   # Delete node_modules and reinstall
   rm -rf node_modules package-lock.json
   npm install
   ```

---

## ⚙️ **Environment Configuration**

1. **Create environment file**
   ```bash
   cp .env.example .env
   ```

2. **Edit .env file with your Supabase credentials**
   ```bash
   # Open in VS Code
   code .env
   
   # Or use nano
   nano .env
   ```

3. **Add your Supabase credentials:**
   ```env
   VITE_SUPABASE_PROJECT_ID=your_project_id
   VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key
   VITE_SUPABASE_URL=https://your-project.supabase.co
   ```

---

## 🚀 **Running the Project**

### **Development Mode**
```bash
# Start development server
npm run dev

# Or using yarn
yarn dev

# Or using pnpm
pnpm dev
```

The project will be available at: `http://localhost:5173`

### **Production Build**
```bash
# Build for production
npm run build

# Preview production build
npm run preview
```

### **Other Commands**
```bash
# Type checking
npm run type-check

# Linting
npm run lint

# Format code
npm run format
```

---

## 🗂️ **Project Structure**

```
seenaf-ctf/
├── public/                 # Static assets
│   ├── favicon.svg
│   ├── seenaf-ctf-icon.svg
│   └── manifest.json
├── src/
│   ├── components/         # React components
│   │   ├── challenges/     # Challenge-related components
│   │   ├── layout/         # Layout components
│   │   └── ui/            # Reusable UI components
│   ├── controllers/        # Business logic controllers
│   ├── hooks/             # Custom React hooks
│   ├── integrations/      # External service integrations
│   ├── models/            # Data models
│   ├── pages/             # Page components
│   ├── types/             # TypeScript type definitions
│   └── utils/             # Utility functions
├── supabase/              # Database migrations
├── *.sql                  # Database setup scripts
├── package.json           # Dependencies and scripts
├── vite.config.ts         # Vite configuration
├── tailwind.config.ts     # Tailwind CSS configuration
└── tsconfig.json          # TypeScript configuration
```

---

## 🔧 **VS Code Configuration**

### **Create .vscode/settings.json**
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
  },
  "files.associations": {
    "*.css": "tailwindcss"
  }
}
```

### **Create .vscode/launch.json** (for debugging)
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch Chrome",
      "request": "launch",
      "type": "chrome",
      "url": "http://localhost:5173",
      "webRoot": "${workspaceFolder}/src"
    }
  ]
}
```

---

## 🐛 **Troubleshooting**

### **Common Issues & Solutions**

#### **1. Port Already in Use**
```bash
# Kill process on port 5173
sudo lsof -t -i tcp:5173 | xargs kill -9

# Or use different port
npm run dev -- --port 3000
```

#### **2. Permission Errors**
```bash
# Fix npm permissions
sudo chown -R $(whoami) ~/.npm
sudo chown -R $(whoami) /usr/local/lib/node_modules
```

#### **3. Module Not Found Errors**
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

#### **4. TypeScript Errors**
```bash
# Restart TypeScript server in VS Code
Ctrl+Shift+P → "TypeScript: Restart TS Server"
```

#### **5. Tailwind CSS Not Working**
```bash
# Restart development server
Ctrl+C
npm run dev
```

---

## 📱 **Development Workflow**

### **Recommended Workflow**

1. **Open VS Code**
   ```bash
   code ~/seenaf-ctf
   ```

2. **Start development server**
   ```bash
   npm run dev
   ```

3. **Open browser**
   - Go to `http://localhost:5173`

4. **Make changes**
   - Edit files in VS Code
   - Changes auto-reload in browser

5. **Test your changes**
   - Check functionality
   - Test on different screen sizes

6. **Commit changes** (if using Git)
   ```bash
   git add .
   git commit -m "Your commit message"
   git push
   ```

### **Hot Reload**
- Changes to React components reload instantly
- Changes to CSS/Tailwind update immediately
- Changes to config files require server restart

---

## 🌐 **Database Management**

### **Supabase Integration**
1. **Access Supabase Dashboard**
   - Go to [supabase.com](https://supabase.com)
   - Login to your project

2. **Run SQL Scripts**
   - Use SQL Editor in Supabase Dashboard
   - Copy content from `.sql` files in your project
   - Run scripts to set up database

3. **Environment Variables**
   - Get credentials from Supabase Dashboard
   - Update `.env` file in your project

---

## 🚀 **Deployment Options**

### **1. Vercel (Recommended)**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Follow prompts to connect to Git and deploy
```

### **2. Netlify**
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Build and deploy
npm run build
netlify deploy --prod --dir=dist
```

### **3. GitHub Pages**
```bash
# Install gh-pages
npm install --save-dev gh-pages

# Add to package.json scripts:
"deploy": "gh-pages -d dist"

# Deploy
npm run build
npm run deploy
```

---

## 📝 **Additional Tips**

### **VS Code Shortcuts**
- `Ctrl+Shift+P` - Command Palette
- `Ctrl+`` - Toggle Terminal
- `Ctrl+Shift+E` - Explorer
- `Ctrl+Shift+F` - Search in Files
- `F5` - Start Debugging
- `Ctrl+Shift+I` - Developer Tools

### **Development Tips**
- Use the integrated terminal in VS Code
- Install React Developer Tools browser extension
- Use browser dev tools for debugging
- Keep the development server running while coding
- Use Git for version control

### **Performance Tips**
- Close unused browser tabs
- Restart development server if it becomes slow
- Clear browser cache if styles don't update
- Use `npm run build` to test production performance

---

## ✅ **Quick Start Checklist**

- [ ] Install Node.js (v18+)
- [ ] Install VS Code
- [ ] Copy/clone project files
- [ ] Install dependencies (`npm install`)
- [ ] Configure environment variables (`.env`)
- [ ] Install recommended VS Code extensions
- [ ] Start development server (`npm run dev`)
- [ ] Open browser to `http://localhost:5173`
- [ ] Set up Supabase database
- [ ] Test the application

Your SEENAF_CTF project is now ready to run in VS Code! 🎉