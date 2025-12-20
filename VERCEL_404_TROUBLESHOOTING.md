# 🔧 Vercel 404 Troubleshooting Guide

If you're still getting 404 errors after the fixes, follow this step-by-step troubleshooting guide.

---

## 🔍 Step 1: Test Static Files

First, let's verify that Vercel is serving files correctly:

1. **Test the static test file**: https://seenaf-ctf-challenge.vercel.app/test.html
   - ✅ If this loads: Static files work, issue is with routing
   - ❌ If this fails: Build/deployment issue

2. **Test the main index**: https://seenaf-ctf-challenge.vercel.app/
   - ✅ If this loads: App builds correctly
   - ❌ If this fails: Build issue

---

## 🔍 Step 2: Check Vercel Dashboard

1. Go to [Vercel Dashboard](https://vercel.com/dashboard)
2. Find your project: `seenaf-ctf-challenge`
3. Click on the latest deployment
4. Check these tabs:

### Build Logs
Look for errors like:
```
❌ Build failed
❌ Command "npm run build" exited with 1
❌ Module not found
```

### Function Logs
Look for runtime errors:
```
❌ 404: NOT_FOUND
❌ Internal Server Error
❌ Timeout
```

### Source
Verify these files exist:
- ✅ `index.html` in root
- ✅ `vercel.json` in root
- ✅ `dist/` folder with built files

---

## 🔍 Step 3: Manual Vercel Configuration

If the automatic configuration isn't working, try manual setup:

### Option A: Vercel CLI Deployment

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Deploy manually
vercel --prod

# Follow prompts:
# - Framework: Vite
# - Build Command: npm run build
# - Output Directory: dist
```

### Option B: Manual Project Settings

1. Go to Vercel Dashboard → Your Project → Settings
2. **General**:
   - Framework Preset: `Vite`
   - Build Command: `npm run build`
   - Output Directory: `dist`
   - Install Command: `npm install`

3. **Functions**:
   - Ensure no serverless functions are configured (unless needed)

4. **Environment Variables**:
   - Add your Supabase credentials:
     ```
     VITE_SUPABASE_URL=https://your-project.supabase.co
     VITE_SUPABASE_PUBLISHABLE_KEY=your-anon-key
     VITE_SUPABASE_PROJECT_ID=your-project-id
     ```

---

## 🔍 Step 4: Alternative Vercel Configurations

Try these different `vercel.json` configurations:

### Configuration 1: Simple Rewrites
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

### Configuration 2: Explicit Routes
```json
{
  "routes": [
    { "handle": "filesystem" },
    { "src": "/(.*)", "dest": "/index.html" }
  ]
}
```

### Configuration 3: Static Build (Current)
```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": { "distDir": "dist" }
    }
  ],
  "routes": [
    { "handle": "filesystem" },
    { "src": "/(.*)", "dest": "/index.html" }
  ]
}
```

### Configuration 4: Framework Detection
```json
{
  "framework": "vite",
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

---

## 🔍 Step 5: Local Testing

Test the build locally to ensure it works:

```bash
# Build the project
npm run build

# Serve the built files
npx serve dist

# Test these URLs:
# http://localhost:3000/
# http://localhost:3000/leaderboard
# http://localhost:3000/challenges
```

If local testing fails, the issue is with the build, not Vercel.

---

## 🔍 Step 6: Check React Router

Ensure React Router is configured correctly:

```typescript
// src/App.tsx should have:
import { BrowserRouter } from "react-router-dom";

// NOT HashRouter or MemoryRouter
<BrowserRouter>
  <Routes>
    <Route path="/" element={<Index />} />
    <Route path="/leaderboard" element={<Leaderboard />} />
    {/* other routes */}
  </Routes>
</BrowserRouter>
```

---

## 🔍 Step 7: Alternative Deployment Methods

If Vercel continues to have issues, try these alternatives:

### Netlify
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Build and deploy
npm run build
netlify deploy --prod --dir=dist
```

### GitHub Pages
```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '18'
      - run: npm install
      - run: npm run build
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dist
```

### Railway
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway init
railway up
```

---

## 🔍 Step 8: Debug Information

Collect this information for further troubleshooting:

### Build Information
```bash
# Check Node version
node --version

# Check npm version
npm --version

# Check build output
npm run build
ls -la dist/
```

### Vercel Information
- Deployment URL
- Build logs (copy full logs)
- Function logs (if any)
- Environment variables (names only, not values)

### Browser Information
- Browser and version
- Console errors (F12 → Console)
- Network tab errors (F12 → Network)

---

## 🔍 Step 9: Contact Support

If all else fails:

### Vercel Support
1. Go to Vercel Dashboard
2. Click "Help" → "Contact Support"
3. Include:
   - Project name: `seenaf-ctf-challenge`
   - Deployment URL
   - Build logs
   - This troubleshooting checklist

### GitHub Issues
1. Open an issue in your repository
2. Include all debug information from Step 8
3. Tag it as `deployment` and `vercel`

---

## ✅ Success Checklist

Your deployment is working when:

- [ ] https://seenaf-ctf-challenge.vercel.app/ loads
- [ ] https://seenaf-ctf-challenge.vercel.app/leaderboard loads
- [ ] https://seenaf-ctf-challenge.vercel.app/challenges loads
- [ ] https://seenaf-ctf-challenge.vercel.app/admin loads
- [ ] Refreshing any page works (no 404)
- [ ] Direct URL access works
- [ ] Navigation between pages works
- [ ] No console errors

---

## 🚨 Emergency Workaround

If you need the site working immediately:

### Use HashRouter (Temporary Fix)
```typescript
// src/App.tsx - Change BrowserRouter to HashRouter
import { HashRouter } from "react-router-dom";

<HashRouter>
  <Routes>
    {/* your routes */}
  </Routes>
</HashRouter>
```

This will make URLs look like:
- `https://seenaf-ctf-challenge.vercel.app/#/leaderboard`
- `https://seenaf-ctf-challenge.vercel.app/#/challenges`

**Note**: This is not ideal for SEO but will work immediately.

---

## 📞 Need Immediate Help?

If you're running a CTF event and need immediate assistance:

1. **Try the HashRouter workaround** above
2. **Use a different deployment platform** (Netlify, Railway)
3. **Contact me** with the debug information from Step 8

Remember: The issue is likely a simple configuration problem that can be resolved quickly once we identify the root cause.