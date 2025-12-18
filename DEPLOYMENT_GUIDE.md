# 🚀 SEENAF_CTF Deployment Guide

Complete guide to deploy your SEENAF_CTF platform on any computer without problems.

## 📦 **Package Your Project**

### **What to Include:**

Your deployment package should contain:
- ✅ All source code (`src/`, `public/`)
- ✅ Configuration files (`package.json`, `vite.config.ts`, etc.)
- ✅ Database scripts (all `.sql` files)
- ✅ Documentation files (all `.md` files)
- ✅ Setup scripts (`setup-vscode.sh`, `deploy.sh`)
- ❌ **DO NOT include**: `node_modules/`, `.env`, `dist/`, build artifacts

### **Create Deployment Package:**

```bash
# Run this on your current computer
./create-deployment-package.sh
```

This creates `seenaf-ctf-deployment.zip` with everything needed.

---

## 🖥️ **Deploy on New Computer**

### **Step 1: Prerequisites**

The new computer needs:
- **Node.js 18+** (will be installed by script)
- **Git** (optional, for version control)
- **Internet connection** (for npm packages)

### **Step 2: Extract and Setup**

```bash
# 1. Extract the deployment package
unzip seenaf-ctf-deployment.zip
cd seenaf-ctf

# 2. Run the automated setup
chmod +x deploy.sh
./deploy.sh
```

The script will:
- ✅ Check and install Node.js if needed
- ✅ Install all dependencies
- ✅ Configure environment
- ✅ Set up database
- ✅ Start the application

### **Step 3: Configure Supabase**

1. **Create Supabase Project** (if new deployment)
   - Go to [supabase.com](https://supabase.com)
   - Create new project
   - Note your credentials

2. **Update Environment Variables**
   ```bash
   nano .env
   ```
   
   Add your Supabase credentials:
   ```env
   VITE_SUPABASE_PROJECT_ID=your_project_id
   VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key
   VITE_SUPABASE_URL=https://your-project.supabase.co
   ```

3. **Setup Database**
   - Go to Supabase SQL Editor
   - Run `database-setup-complete.sql`
   - Run `load-all-68-challenges.sql`

### **Step 4: Start Application**

```bash
npm run dev
```

Open browser to `http://localhost:5173`

---

## 🌐 **Deployment Options**

### **Option 1: Local Development**
- Run on localhost
- Good for: Development, testing
- Command: `npm run dev`

### **Option 2: Production Server**
- Deploy to VPS/Cloud
- Good for: Live platform
- See "Production Deployment" section

### **Option 3: Docker Container**
- Containerized deployment
- Good for: Consistent environments
- See "Docker Deployment" section

---

## 🐳 **Docker Deployment (Recommended)**

### **Why Docker?**
- ✅ Works on any computer
- ✅ Consistent environment
- ✅ Easy to deploy
- ✅ No dependency issues

### **Setup with Docker:**

```bash
# 1. Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 2. Build Docker image
docker build -t seenaf-ctf .

# 3. Run container
docker run -p 5173:5173 --env-file .env seenaf-ctf
```

---

## 📱 **Cross-Platform Compatibility**

### **Windows**
```powershell
# Install Node.js from nodejs.org
# Extract deployment package
# Run: npm install
# Run: npm run dev
```

### **macOS**
```bash
# Install Node.js
brew install node

# Extract and setup
unzip seenaf-ctf-deployment.zip
cd seenaf-ctf
npm install
npm run dev
```

### **Linux**
```bash
# Use the deploy.sh script
chmod +x deploy.sh
./deploy.sh
```

---

## 🔒 **Security Checklist**

Before deploying on new computer:
- [ ] Update `.env` with new credentials
- [ ] Change admin password
- [ ] Update Supabase RLS policies
- [ ] Enable HTTPS in production
- [ ] Set up firewall rules
- [ ] Configure CORS properly

---

## 🆘 **Troubleshooting**

### **Common Issues:**

1. **"Node.js not found"**
   - Install Node.js 18+
   - Restart terminal

2. **"npm install fails"**
   - Clear cache: `npm cache clean --force`
   - Try again: `npm install`

3. **"Port already in use"**
   - Change port: `npm run dev -- --port 3000`

4. **"Database connection failed"**
   - Check `.env` credentials
   - Verify Supabase project is active

---

## ✅ **Deployment Checklist**

- [ ] Node.js 18+ installed
- [ ] Project files extracted
- [ ] Dependencies installed (`npm install`)
- [ ] Environment configured (`.env`)
- [ ] Database setup complete
- [ ] Application starts successfully
- [ ] Can access at localhost:5173
- [ ] Can register/login
- [ ] Challenges load correctly
- [ ] Admin panel works

Your SEENAF_CTF platform is now ready to run on any computer! 🎉