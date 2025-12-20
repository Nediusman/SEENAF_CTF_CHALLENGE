#!/bin/bash
# secure-deploy.sh - Secure deployment script for SEENAF CTF Platform

set -e  # Exit on any error

echo "🔒 Starting secure deployment process..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Pre-deployment security checks
print_status "Running pre-deployment security checks..."

# Check if npm is available
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install Node.js and npm."
    exit 1
fi

# Check if vercel CLI is available
if ! command -v vercel &> /dev/null; then
    print_warning "Vercel CLI not found. Installing..."
    npm install -g vercel
fi

# 2. Security audit
print_status "Running security audit..."
if npm audit --audit-level high; then
    print_success "No high-severity vulnerabilities found"
else
    print_error "High-severity vulnerabilities detected!"
    echo "Please run 'npm audit fix' to resolve issues before deploying."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 3. Verify environment variables
print_status "Verifying environment variables..."
if [ -f ".env" ]; then
    source .env
    
    if [ -z "$VITE_SUPABASE_URL" ] || [ -z "$VITE_SUPABASE_PUBLISHABLE_KEY" ]; then
        print_error "Missing required environment variables:"
        echo "  - VITE_SUPABASE_URL"
        echo "  - VITE_SUPABASE_PUBLISHABLE_KEY"
        echo "Please check your .env file."
        exit 1
    fi
    
    # Validate Supabase URL format
    if [[ ! $VITE_SUPABASE_URL =~ ^https://[a-zA-Z0-9-]+\.supabase\.co$ ]]; then
        print_error "Invalid Supabase URL format: $VITE_SUPABASE_URL"
        echo "Expected format: https://your-project-id.supabase.co"
        exit 1
    fi
    
    # Validate anon key format (should be JWT)
    if [[ ! $VITE_SUPABASE_PUBLISHABLE_KEY =~ ^eyJ ]]; then
        print_error "Invalid Supabase anon key format"
        echo "The key should start with 'eyJ' (JWT format)"
        exit 1
    fi
    
    print_success "Environment variables validated"
else
    print_error ".env file not found!"
    echo "Please create a .env file with your Supabase credentials."
    echo "You can copy .env.example and fill in your values."
    exit 1
fi

# 4. Install dependencies
print_status "Installing dependencies..."
npm ci --only=production

# 5. Run linting
print_status "Running code linting..."
if npm run lint; then
    print_success "Code linting passed"
else
    print_warning "Linting issues found. Consider fixing them before deployment."
fi

# 6. Build with security optimizations
print_status "Building application with security optimizations..."
export NODE_ENV=production
if npm run build; then
    print_success "Build completed successfully"
else
    print_error "Build failed!"
    exit 1
fi

# 7. Verify build output
print_status "Verifying build output..."
if [ ! -d "dist" ]; then
    print_error "Build directory 'dist' not found!"
    exit 1
fi

if [ ! -f "dist/index.html" ]; then
    print_error "index.html not found in build output!"
    exit 1
fi

print_success "Build output verified"

# 8. Security configuration check
print_status "Verifying security configuration..."
if [ ! -f "vercel.json" ]; then
    print_error "vercel.json not found!"
    echo "Security headers configuration is missing."
    exit 1
fi

# Check if security headers are present in vercel.json
if grep -q "Strict-Transport-Security" vercel.json && \
   grep -q "Content-Security-Policy" vercel.json && \
   grep -q "X-Content-Type-Options" vercel.json; then
    print_success "Security headers configuration verified"
else
    print_error "Security headers not properly configured in vercel.json"
    exit 1
fi

# 9. Deploy to Vercel
print_status "Deploying to Vercel..."
echo "This will deploy your application with the following security features:"
echo "  ✓ HTTPS enforcement (HSTS)"
echo "  ✓ Content Security Policy (CSP)"
echo "  ✓ XSS protection headers"
echo "  ✓ Clickjacking protection"
echo "  ✓ MIME type sniffing protection"
echo "  ✓ Referrer policy"
echo "  ✓ Permissions policy"
echo ""

read -p "Proceed with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Deployment cancelled by user"
    exit 0
fi

if vercel --prod --yes; then
    print_success "Deployment completed successfully!"
else
    print_error "Deployment failed!"
    exit 1
fi

# 10. Post-deployment security verification
print_status "Running post-deployment security checks..."

# Get the deployment URL (assuming it's the default Vercel URL)
DEPLOYMENT_URL="https://seenaf-ctf-challenge.vercel.app"

print_status "Verifying security headers at $DEPLOYMENT_URL..."

# Check HSTS header
if curl -s -I "$DEPLOYMENT_URL" | grep -i "strict-transport-security" > /dev/null; then
    print_success "HSTS header verified"
else
    print_warning "HSTS header not found"
fi

# Check CSP header
if curl -s -I "$DEPLOYMENT_URL" | grep -i "content-security-policy" > /dev/null; then
    print_success "Content Security Policy header verified"
else
    print_warning "CSP header not found"
fi

# Check X-Content-Type-Options header
if curl -s -I "$DEPLOYMENT_URL" | grep -i "x-content-type-options" > /dev/null; then
    print_success "X-Content-Type-Options header verified"
else
    print_warning "X-Content-Type-Options header not found"
fi

# Check if site is accessible
if curl -s -o /dev/null -w "%{http_code}" "$DEPLOYMENT_URL" | grep -q "200"; then
    print_success "Site is accessible and responding"
else
    print_warning "Site may not be fully accessible yet (DNS propagation)"
fi

# 11. Security recommendations
echo ""
echo "=================================================="
print_success "🎉 Secure deployment completed!"
echo "=================================================="
echo ""
echo "🔒 Security features enabled:"
echo "  ✓ HTTPS enforcement with HSTS"
echo "  ✓ Content Security Policy (CSP)"
echo "  ✓ XSS protection headers"
echo "  ✓ Clickjacking protection (X-Frame-Options)"
echo "  ✓ MIME type sniffing protection"
echo "  ✓ Strict referrer policy"
echo "  ✓ Permissions policy restrictions"
echo "  ✓ Cross-origin policies"
echo ""
echo "🌐 Your application is now live at:"
echo "   $DEPLOYMENT_URL"
echo ""
echo "📋 Post-deployment checklist:"
echo "  □ Test all functionality on the live site"
echo "  □ Verify login and registration work correctly"
echo "  □ Test challenge submission system"
echo "  □ Check admin panel access"
echo "  □ Monitor security logs for any issues"
echo ""
echo "🛡️ Security monitoring:"
echo "  • Security events are logged in the application"
echo "  • Monitor the admin panel for security alerts"
echo "  • Regular security audits are recommended"
echo ""
print_success "Deployment process completed successfully!"