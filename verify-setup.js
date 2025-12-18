#!/usr/bin/env node

/**
 * SEENAF CTF Platform - Setup Verification Script
 * Checks if everything is configured correctly
 */

import { createClient } from '@supabase/supabase-js';
import { readFileSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Colors for terminal output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function checkmark() {
  return `${colors.green}✓${colors.reset}`;
}

function crossmark() {
  return `${colors.red}✗${colors.reset}`;
}

async function verifySetup() {
  log('\n🔍 SEENAF CTF Platform - Setup Verification\n', 'cyan');
  
  let allChecks = true;
  
  // Check 1: .env file exists
  log('Checking configuration files...', 'blue');
  if (existsSync('.env')) {
    log(`${checkmark()} .env file exists`);
  } else {
    log(`${crossmark()} .env file not found`, 'red');
    log('   Run: cp .env.example .env', 'yellow');
    allChecks = false;
  }
  
  // Check 2: Environment variables
  log('\nChecking environment variables...', 'blue');
  const requiredVars = [
    'VITE_SUPABASE_URL',
    'VITE_SUPABASE_PUBLISHABLE_KEY',
    'VITE_SUPABASE_PROJECT_ID'
  ];
  
  // Load .env manually
  if (existsSync('.env')) {
    const envContent = readFileSync('.env', 'utf-8');
    envContent.split('\n').forEach(line => {
      const match = line.match(/^([^=]+)=(.*)$/);
      if (match) {
        process.env[match[1].trim()] = match[2].trim();
      }
    });
  }
  
  for (const varName of requiredVars) {
    if (process.env[varName] && !process.env[varName].includes('your_')) {
      log(`${checkmark()} ${varName} is set`);
    } else {
      log(`${crossmark()} ${varName} is missing or not configured`, 'red');
      allChecks = false;
    }
  }
  
  // Check 3: node_modules
  log('\nChecking dependencies...', 'blue');
  if (existsSync('node_modules')) {
    log(`${checkmark()} Dependencies installed`);
  } else {
    log(`${crossmark()} Dependencies not installed`, 'red');
    log('   Run: npm install', 'yellow');
    allChecks = false;
  }
  
  // Check 4: Supabase connection
  if (process.env.VITE_SUPABASE_URL && process.env.VITE_SUPABASE_PUBLISHABLE_KEY) {
    log('\nTesting Supabase connection...', 'blue');
    
    try {
      const supabase = createClient(
        process.env.VITE_SUPABASE_URL,
        process.env.VITE_SUPABASE_PUBLISHABLE_KEY
      );
      
      // Test connection
      const { data, error } = await supabase
        .from('challenges')
        .select('count', { count: 'exact', head: true });
      
      if (error) {
        log(`${crossmark()} Database connection failed: ${error.message}`, 'red');
        log('   Make sure you ran the setup SQL scripts in Supabase', 'yellow');
        allChecks = false;
      } else {
        log(`${checkmark()} Successfully connected to Supabase`);
        
        // Check challenges count
        const { count } = await supabase
          .from('challenges')
          .select('*', { count: 'exact', head: true });
        
        if (count > 0) {
          log(`${checkmark()} Found ${count} challenges in database`);
        } else {
          log(`${crossmark()} No challenges found in database`, 'yellow');
          log('   Run load-all-68-challenges.sql in Supabase SQL Editor', 'yellow');
        }
        
        // Check tables exist
        const tables = ['profiles', 'user_roles', 'submissions'];
        for (const table of tables) {
          const { error: tableError } = await supabase
            .from(table)
            .select('count', { count: 'exact', head: true });
          
          if (tableError) {
            log(`${crossmark()} Table '${table}' not found`, 'red');
            allChecks = false;
          } else {
            log(`${checkmark()} Table '${table}' exists`);
          }
        }
      }
    } catch (err) {
      log(`${crossmark()} Connection test failed: ${err.message}`, 'red');
      allChecks = false;
    }
  }
  
  // Check 5: Required files
  log('\nChecking required files...', 'blue');
  const requiredFiles = [
    'package.json',
    'vite.config.ts',
    'index.html',
    'src/App.tsx',
    'complete-setup.sql',
    'load-all-68-challenges.sql'
  ];
  
  for (const file of requiredFiles) {
    if (existsSync(file)) {
      log(`${checkmark()} ${file}`);
    } else {
      log(`${crossmark()} ${file} not found`, 'red');
      allChecks = false;
    }
  }
  
  // Final summary
  log('\n' + '='.repeat(50), 'cyan');
  if (allChecks) {
    log('\n🎉 All checks passed! Your setup is complete.', 'green');
    log('\n📋 Next steps:', 'cyan');
    log('   1. Start the dev server: npm run dev');
    log('   2. Open http://localhost:5173 in your browser');
    log('   3. Register an account');
    log('   4. Run emergency-admin-fix-v2.sql to make yourself admin');
    log('   5. Access admin panel at /admin\n');
  } else {
    log('\n⚠️  Some checks failed. Please fix the issues above.', 'yellow');
    log('\n📖 For help, see SETUP_GUIDE.md\n', 'cyan');
    process.exit(1);
  }
}

verifySetup().catch(err => {
  log(`\n❌ Verification failed: ${err.message}`, 'red');
  process.exit(1);
});
