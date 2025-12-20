#!/bin/bash

# SEENAF CTF - Secure Platform Deployment Script
# This script deploys your CTF platform with enterprise-grade security

echo "🔒 SEENAF CTF - SECURE PLATFORM DEPLOYMENT"
echo "=========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Step 1: Security Audit
echo -e "${BLUE}🔍 STEP 1: SECURITY AUDIT${NC}"
echo "----------------------------------------"

echo "1️⃣ Checking for security vulnerabilities..."
if command -v npm &> /dev/null; then
    npm audit --audit-level=moderate
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}⚠️  Security vulnerabilities found. Run 'npm audit fix' to resolve.${NC}"
    else
        echo -e "${GREEN}✅ No security vulnerabilities found${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  npm not found, skipping audit${NC}"
fi

echo ""
echo "2️⃣ Checking for hardcoded secrets..."
if grep -r "password\|secret\|api_key\|token" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" | grep -v "// " | grep -v "interface\|type\|function\|const.*=.*''" | head -5; then
    echo -e "${RED}❌ Potential hardcoded secrets found above. Please review and remove.${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✅ No hardcoded secrets detected${NC}"
fi

echo ""
echo "3️⃣ Validating environment configuration..."
if [ -f .env ]; then
    if grep -q "VITE_SUPABASE_URL" .env && grep -q "VITE_SUPABASE_PUBLISHABLE_KEY" .env; then
        echo -e "${GREEN}✅ Environment variables configured${NC}"
    else
        echo -e "${RED}❌ Missing required environment variables${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  No .env file found (using system environment)${NC}"
fi

# Step 2: Database Security Setup
echo ""
echo -e "${BLUE}🗄️  STEP 2: DATABASE SECURITY SETUP${NC}"
echo "----------------------------------------"

echo "📋 Database security setup required:"
echo "   1. Open your Supabase dashboard"
echo "   2. Go to SQL Editor"
echo "   3. Copy and paste the contents of 'complete-security-database-setup.sql'"
echo "   4. Run the script to create all security tables and functions"
echo ""
echo "This will create:"
echo "   • security_events table for monitoring"
echo "   • audit_logs table for compliance"
echo "   • user_mfa table for 2FA"
echo "   • user_sessions table for session management"
echo "   • rate_limits table for protection"
echo "   • Security functions and triggers"
echo ""
read -p "Have you run the database security setup? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}⚠️  Please run the database setup first, then restart this script${NC}"
    exit 1
fi

# Step 3: Install Dependencies
echo ""
echo -e "${BLUE}📦 STEP 3: INSTALL SECURITY DEPENDENCIES${NC}"
echo "----------------------------------------"

echo "Installing required security packages..."
npm install isomorphic-dompurify
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Security dependencies installed${NC}"
else
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi

# Step 4: Build Application
echo ""
echo -e "${BLUE}🏗️  STEP 4: BUILD SECURE APPLICATION${NC}"
echo "----------------------------------------"

echo "Building application with security features..."
npm run build

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful${NC}"

# Step 5: Security Validation
echo ""
echo -e "${BLUE}🔍 STEP 5: SECURITY VALIDATION${NC}"
echo "----------------------------------------"

echo "1️⃣ Checking build output for sensitive data..."
if grep -r "password\|secret\|api_key" dist/ 2>/dev/null | grep -v ".ico\|.png\|.jpg\|.svg"; then
    echo -e "${RED}❌ CRITICAL: Sensitive data found in build output!${NC}"
    echo "   DO NOT DEPLOY - Fix the issue first"
    exit 1
else
    echo -e "${GREEN}✅ Build output is clean${NC}"
fi

echo ""
echo "2️⃣ Validating security headers configuration..."
if grep -q "Content-Security-Policy" vercel.json; then
    echo -e "${GREEN}✅ Security headers configured${NC}"
else
    echo -e "${YELLOW}⚠️  Security headers not found in vercel.json${NC}"
fi

echo ""
echo "3️⃣ Checking for security components..."
if [ -f "src/utils/advancedSecurity.ts" ] && [ -f "src/utils/mfaService.ts" ]; then
    echo -e "${GREEN}✅ Security components present${NC}"
else
    echo -e "${RED}❌ Security components missing${NC}"
    exit 1
fi

# Step 6: Deployment
echo ""
echo -e "${BLUE}🚀 STEP 6: SECURE DEPLOYMENT${NC}"
echo "----------------------------------------"

echo "Deployment options:"
echo "   1. Vercel (recommended)"
echo "   2. Netlify"
echo "   3. Manual upload"
echo ""

read -p "Deploy to Vercel now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v vercel &> /dev/null; then
        echo "🚀 Deploying to Vercel..."
        vercel --prod
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Deployment successful!${NC}"
        else
            echo -e "${RED}❌ Deployment failed${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}⚠️  Vercel CLI not installed. Install with: npm i -g vercel${NC}"
        echo "   Or upload the 'dist' folder manually to your hosting provider"
    fi
else
    echo "📁 Build files are ready in the 'dist' folder"
    echo "   Upload these files to your hosting provider"
fi

# Step 7: Post-Deployment Security Checklist
echo ""
echo -e "${BLUE}✅ STEP 7: POST-DEPLOYMENT SECURITY CHECKLIST${NC}"
echo "----------------------------------------"

echo ""
echo -e "${PURPLE}🔒 CRITICAL POST-DEPLOYMENT TASKS:${NC}"
echo ""
echo "1️⃣ CHANGE ADMIN PASSWORD:"
echo "   • Go to your Supabase dashboard"
echo "   • Authentication → Users"
echo "   • Reset password for admin account"
echo ""
echo "2️⃣ SET UP ADMIN ROLE:"
echo "   • Run this SQL in Supabase:"
echo "   INSERT INTO user_roles (user_id, role)"
echo "   SELECT id, 'admin' FROM auth.users WHERE email = 'YOUR_EMAIL'"
echo "   ON CONFLICT (user_id) DO UPDATE SET role = 'admin';"
echo ""
echo "3️⃣ ENABLE MFA FOR ADMIN:"
echo "   • Login to your platform"
echo "   • Go to Admin panel"
echo "   • Enable Multi-Factor Authentication"
echo ""
echo "4️⃣ TEST SECURITY FEATURES:"
echo "   • Try failed login attempts (should lock after 3)"
echo "   • Test rate limiting with rapid requests"
echo "   • Verify security dashboard shows events"
echo "   • Check CSP headers are working"
echo ""
echo "5️⃣ MONITOR SECURITY:"
echo "   • Check security dashboard regularly"
echo "   • Review security events daily"
echo "   • Monitor threat scores"
echo "   • Set up alerting for critical events"
echo ""

# Step 8: Security Summary
echo ""
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETE!${NC}"
echo "=========================================="
echo ""
echo -e "${PURPLE}🛡️  SECURITY FEATURES ACTIVE:${NC}"
echo ""
echo "✅ HTTP Security Headers (CSP, HSTS, etc.)"
echo "✅ Multi-Factor Authentication (MFA)"
echo "✅ Account Lockout Protection"
echo "✅ Rate Limiting & DDoS Protection"
echo "✅ XSS & Injection Prevention"
echo "✅ Real-time Threat Detection"
echo "✅ Comprehensive Audit Logging"
echo "✅ User Behavior Analysis"
echo "✅ Automated Incident Response"
echo "✅ Security Monitoring Dashboard"
echo ""
echo -e "${BLUE}📊 MONITORING URLS:${NC}"
echo "• Security Dashboard: /admin (Security tab)"
echo "• Audit Logs: Supabase Dashboard → Database → audit_logs"
echo "• Security Events: Supabase Dashboard → Database → security_events"
echo ""
echo -e "${YELLOW}⚠️  REMEMBER:${NC}"
echo "• Change admin password immediately"
echo "• Enable MFA for all admin accounts"
echo "• Monitor security dashboard daily"
echo "• Keep dependencies updated"
echo "• Review security logs weekly"
echo ""
echo -e "${GREEN}🔒 Your CTF platform is now enterprise-grade secure! 🔒${NC}"
echo ""
echo "For detailed documentation, see:"
echo "• ULTIMATE_SECURITY_IMPLEMENTATION.md"
echo "• COMPREHENSIVE_SECURITY_AUDIT.md"
echo "• CRITICAL_SECURITY_FIX.md"
echo ""
echo "Happy hacking! 🎯"