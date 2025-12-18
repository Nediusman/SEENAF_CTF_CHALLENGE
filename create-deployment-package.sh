#!/bin/bash

# SEENAF_CTF Deployment Package Creator
# Creates a portable deployment package for any computer

set -e

echo "🚀 Creating SEENAF_CTF Deployment Package..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Package name
PACKAGE_NAME="seenaf-ctf-deployment"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PACKAGE_DIR="${PACKAGE_NAME}_${TIMESTAMP}"

echo -e "${BLUE}📦 Step 1: Creating package directory...${NC}"
mkdir -p "$PACKAGE_DIR"

echo -e "${BLUE}📋 Step 2: Copying source files...${NC}"
# Copy source code
cp -r src "$PACKAGE_DIR/"
cp -r public "$PACKAGE_DIR/"

echo -e "${BLUE}⚙️  Step 3: Copying configuration files...${NC}"
# Copy config files
cp package.json "$PACKAGE_DIR/"
cp package-lock.json "$PACKAGE_DIR/" 2>/dev/null || true
cp vite.config.ts "$PACKAGE_DIR/"
cp tsconfig.json "$PACKAGE_DIR/"
cp tsconfig.app.json "$PACKAGE_DIR/"
cp tsconfig.node.json "$PACKAGE_DIR/"
cp tailwind.config.ts "$PACKAGE_DIR/"
cp postcss.config.js "$PACKAGE_DIR/"
cp components.json "$PACKAGE_DIR/"
cp eslint.config.js "$PACKAGE_DIR/"
cp index.html "$PACKAGE_DIR/"

echo -e "${BLUE}🗄️  Step 4: Copying database scripts...${NC}"
# Copy all SQL files
cp *.sql "$PACKAGE_DIR/" 2>/dev/null || true
mkdir -p "$PACKAGE_DIR/supabase/migrations"
cp -r supabase/migrations/*.sql "$PACKAGE_DIR/supabase/migrations/" 2>/dev/null || true

echo -e "${BLUE}📚 Step 5: Copying documentation...${NC}"
# Copy documentation
cp *.md "$PACKAGE_DIR/" 2>/dev/null || true

echo -e "${BLUE}🔧 Step 6: Copying setup scripts...${NC}"
# Copy setup scripts
cp setup-vscode.sh "$PACKAGE_DIR/"
cp deploy.sh "$PACKAGE_DIR/"
chmod +x "$PACKAGE_DIR/setup-vscode.sh"
chmod +x "$PACKAGE_DIR/deploy.sh"

echo -e "${BLUE}📝 Step 7: Creating environment template...${NC}"
# Create .env.example (without real credentials)
cat > "$PACKAGE_DIR/.env.example" << 'EOF'
# Supabase Configuration
# Replace these with your actual Supabase credentials

VITE_SUPABASE_PROJECT_ID="your_project_id_here"
VITE_SUPABASE_PUBLISHABLE_KEY="your_anon_key_here"
VITE_SUPABASE_URL="https://your-project-id.supabase.co"
EOF

echo -e "${BLUE}📄 Step 8: Creating README for deployment...${NC}"
cat > "$PACKAGE_DIR/DEPLOY_README.md" << 'EOF'
# 🚀 SEENAF_CTF Deployment Package

## Quick Start

### 1. Prerequisites
- Node.js 18+ (will be installed by script if missing)
- Internet connection

### 2. Setup
```bash
# Make deploy script executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

### 3. Configure Supabase
1. Create Supabase project at https://supabase.com
2. Copy `.env.example` to `.env`
3. Add your Supabase credentials to `.env`
4. Run database setup scripts in Supabase SQL Editor:
   - `fix-signup-complete.sql`
   - `fix-submission-system-complete.sql`
   - `load-all-68-challenges.sql`

### 4. Start Application
```bash
npm run dev
```

Open browser to http://localhost:5173

## Admin Access
- Email: nediusman@gmail.com
- Set password during first login

## Documentation
- `DEPLOYMENT_GUIDE.md` - Complete deployment guide
- `VSCODE_SETUP_GUIDE.md` - VS Code setup
- `README.md` - Platform documentation

## Support
For issues, check the troubleshooting section in DEPLOYMENT_GUIDE.md
EOF

echo -e "${BLUE}🗜️  Step 9: Creating deployment package...${NC}"
# Create zip archive
zip -r "${PACKAGE_NAME}_${TIMESTAMP}.zip" "$PACKAGE_DIR" > /dev/null

# Get package size
PACKAGE_SIZE=$(du -h "${PACKAGE_NAME}_${TIMESTAMP}.zip" | cut -f1)

echo ""
echo -e "${GREEN}✅ Deployment package created successfully!${NC}"
echo ""
echo -e "${YELLOW}📦 Package Details:${NC}"
echo "   Name: ${PACKAGE_NAME}_${TIMESTAMP}.zip"
echo "   Size: $PACKAGE_SIZE"
echo "   Location: $(pwd)/${PACKAGE_NAME}_${TIMESTAMP}.zip"
echo ""
echo -e "${YELLOW}📤 Next Steps:${NC}"
echo "   1. Transfer the .zip file to target computer"
echo "   2. Extract: unzip ${PACKAGE_NAME}_${TIMESTAMP}.zip"
echo "   3. Run: cd $PACKAGE_DIR && ./deploy.sh"
echo ""
echo -e "${GREEN}🎉 Ready for deployment!${NC}"

# Clean up temporary directory
rm -rf "$PACKAGE_DIR"
