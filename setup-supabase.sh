#!/bin/bash

# SEENAF CTF Platform - Automated Supabase Setup Script
# This script helps you set up Supabase configuration quickly

set -e  # Exit on error

echo "🚀 SEENAF CTF Platform - Supabase Setup"
echo "========================================"
echo ""

# Check if .env already exists
if [ -f .env ]; then
    echo "⚠️  .env file already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Setup cancelled. Keeping existing .env file."
        exit 0
    fi
fi

# Create .env from template if it doesn't exist
if [ ! -f .env.example ]; then
    echo "📝 Creating .env.example template..."
    cat > .env.example << 'EOF'
# Supabase Configuration
VITE_SUPABASE_PROJECT_ID=your_project_id_here
VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key_here
VITE_SUPABASE_URL=https://your-project-id.supabase.co
EOF
fi

echo ""
echo "📋 Please provide your Supabase credentials"
echo "   (Find these in your Supabase project: Settings → API)"
echo ""

# Get Supabase URL
read -p "🔗 Supabase URL (e.g., https://xxxxx.supabase.co): " SUPABASE_URL

# Extract project ID from URL
if [[ $SUPABASE_URL =~ https://([^.]+)\.supabase\.co ]]; then
    PROJECT_ID="${BASH_REMATCH[1]}"
    echo "   ✅ Project ID detected: $PROJECT_ID"
else
    read -p "🆔 Project ID (from URL): " PROJECT_ID
fi

# Get anon key
echo ""
read -p "🔑 Anon/Public Key (starts with eyJ...): " ANON_KEY

# Validate inputs
if [ -z "$SUPABASE_URL" ] || [ -z "$PROJECT_ID" ] || [ -z "$ANON_KEY" ]; then
    echo "❌ Error: All fields are required!"
    exit 1
fi

# Create .env file
echo ""
echo "📝 Creating .env file..."
cat > .env << EOF
# Supabase Configuration
# Generated on $(date)

VITE_SUPABASE_PROJECT_ID=$PROJECT_ID
VITE_SUPABASE_PUBLISHABLE_KEY=$ANON_KEY
VITE_SUPABASE_URL=$SUPABASE_URL
EOF

echo "✅ .env file created successfully!"
echo ""

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo "✅ Dependencies installed!"
    echo ""
fi

# Test connection
echo "🔍 Testing Supabase connection..."
cat > test-connection.js << 'EOF'
import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config({ path: join(__dirname, '.env') });

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_PUBLISHABLE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing Supabase credentials in .env file');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function testConnection() {
  try {
    const { data, error } = await supabase.from('challenges').select('count');
    
    if (error) {
      console.error('❌ Connection failed:', error.message);
      console.log('\n💡 Next steps:');
      console.log('   1. Make sure you ran the database setup scripts in Supabase SQL Editor');
      console.log('   2. Check that your credentials are correct');
      console.log('   3. Verify your Supabase project is active');
      process.exit(1);
    }
    
    console.log('✅ Successfully connected to Supabase!');
    console.log(`   Database is ready to use.`);
  } catch (err) {
    console.error('❌ Connection test failed:', err.message);
    process.exit(1);
  }
}

testConnection();
EOF

node test-connection.js 2>/dev/null || {
    echo "⚠️  Connection test skipped (database tables not set up yet)"
    echo ""
}

rm -f test-connection.js

echo ""
echo "🎉 Setup Complete!"
echo ""
echo "📋 Next Steps:"
echo "   1. Go to your Supabase project: https://app.supabase.com/"
echo "   2. Open SQL Editor"
echo "   3. Run 'complete-setup.sql' to set up the database"
echo "   4. Run 'load-all-68-challenges.sql' to load challenges"
echo "   5. Start the dev server: npm run dev"
echo ""
echo "📖 For detailed instructions, see SETUP_GUIDE.md"
echo ""
