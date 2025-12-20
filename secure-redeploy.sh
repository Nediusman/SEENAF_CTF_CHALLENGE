#!/bin/bash

# Secure Redeployment Script - Post Security Fix
# This script ensures no sensitive data is in the build before deploying

echo "🔒 SEENAF CTF - Secure Redeployment Script"
echo "=========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Security checks
echo "🔍 Running security checks..."
echo ""

# Check 1: No hardcoded credentials in source
echo "1️⃣ Checking for hardcoded credentials..."
if grep -r "158595\|nediusman@gmail.com" src/ 2>/dev/null; then
    echo -e "${RED}❌ CRITICAL: Hardcoded credentials found in source code!${NC}"
    echo "   Please remove all hardcoded credentials before deploying."
    exit 1
else
    echo -e "${GREEN}✅ No hardcoded credentials found in source${NC}"
fi

# Check 2: Environment variables are set
echo ""
echo "2️⃣ Checking environment variables..."
if [ -f .env ]; then
    if grep -q "VITE_SUPABASE_URL" .env && grep -q "VITE_SUPABASE_PUBLISHABLE_KEY" .env; then
        echo -e "${GREEN}✅ Environment variables configured${NC}"
    else
        echo -e "${RED}❌ Missing required environment variables${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  No .env file found (may be using Vercel env vars)${NC}"
fi

# Check 3: No sensitive data in public files
echo ""
echo "3️⃣ Checking public files..."
if grep -r "password\|secret\|api_key" public/ 2>/dev/null | grep -v ".ico\|.png\|.jpg"; then
    echo -e "${YELLOW}⚠️  Potential sensitive data in public files${NC}"
else
    echo -e "${GREEN}✅ Public files clean${NC}"
fi

# Check 4: Verify AuthController is secure
echo ""
echo "4️⃣ Verifying AuthController security..."
if grep -q "ADMIN_EMAIL\|ADMIN_PASSWORD" src/controllers/AuthController.ts 2>/dev/null; then
    echo -e "${RED}❌ CRITICAL: Admin credentials still in AuthController!${NC}"
    exit 1
else
    echo -e "${GREEN}✅ AuthController is secure${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}✅ All security checks passed!${NC}"
echo "=========================================="
echo ""

# Build the application
echo "🏗️  Building application..."
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful${NC}"
echo ""

# Check build output for sensitive data
echo "🔍 Scanning build output for sensitive data..."
if grep -r "158595\|nediusman@gmail.com" dist/ 2>/dev/null; then
    echo -e "${RED}❌ CRITICAL: Sensitive data found in build output!${NC}"
    echo "   DO NOT DEPLOY - Fix the issue first"
    exit 1
else
    echo -e "${GREEN}✅ Build output is clean${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}🚀 Ready to deploy!${NC}"
echo "=========================================="
echo ""
echo "Deployment options:"
echo "  1. Vercel: vercel --prod"
echo "  2. Manual: Upload dist/ folder to your hosting"
echo ""
echo "⚠️  IMPORTANT POST-DEPLOYMENT STEPS:"
echo "  1. Change admin password immediately"
echo "  2. Set up proper database admin role"
echo "  3. Monitor authentication logs"
echo "  4. Verify admin access works correctly"
echo ""
echo "See CRITICAL_SECURITY_FIX.md for complete instructions."
echo ""

# Ask for confirmation
read -p "Deploy to Vercel now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Deploying to Vercel..."
    vercel --prod
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Deployment successful!${NC}"
        echo ""
        echo "🔒 CRITICAL NEXT STEPS:"
        echo "  1. Change admin password NOW"
        echo "  2. Test admin login"
        echo "  3. Monitor security logs"
        echo ""
    else
        echo -e "${RED}❌ Deployment failed${NC}"
        exit 1
    fi
else
    echo "Deployment cancelled. Run 'vercel --prod' when ready."
fi
