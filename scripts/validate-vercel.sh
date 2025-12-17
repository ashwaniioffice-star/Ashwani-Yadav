#!/bin/bash
# Vercel Deployment Validation Script
# Validates configuration for Vercel deployment

set -e

echo "🔍 Validating Vercel Configuration..."

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        exit 1
    fi
}

cd "$(dirname "$0")/.."

# Check vercel.json exists
if [ ! -f "vercel.json" ]; then
    print_status 1 "vercel.json not found"
fi
print_status 0 "vercel.json exists"

# Validate vercel.json syntax
if command -v node &> /dev/null; then
    if node -e "JSON.parse(require('fs').readFileSync('vercel.json', 'utf8'))" > /dev/null 2>&1; then
        print_status 0 "vercel.json is valid JSON"
    else
        print_status 1 "vercel.json has invalid JSON syntax"
    fi
fi

# Check build command
if npm run build > /tmp/vercel-build.log 2>&1; then
    print_status 0 "Build command succeeds"
else
    print_status 1 "Build command fails"
    cat /tmp/vercel-build.log
    exit 1
fi

# Check output directory exists
if [ -d "dist" ]; then
    print_status 0 "Output directory (dist) exists"
    
    # Check index.html exists
    if [ -f "dist/index.html" ]; then
        print_status 0 "dist/index.html exists"
    else
        print_status 1 "dist/index.html not found"
    fi
else
    print_status 1 "Output directory (dist) not found"
fi

# Check for Vercel-unsafe patterns
echo ""
echo "🔒 Checking for Vercel compatibility..."

# Check for filesystem writes (should only be in /tmp)
if grep -r "fs.writeFileSync\|fs.appendFileSync" src/ --exclude-dir=node_modules 2>/dev/null | grep -v "/tmp" > /dev/null; then
    echo -e "${YELLOW}⚠️  Warning: Filesystem writes detected outside /tmp${NC}"
else
    print_status 0 "No filesystem writes outside /tmp"
fi

# Check for long-running processes
if grep -r "setInterval\|setTimeout.*[0-9]\{6,\}" src/ --exclude-dir=node_modules 2>/dev/null > /dev/null; then
    echo -e "${YELLOW}⚠️  Warning: Long-running timers detected${NC}"
else
    print_status 0 "No long-running processes"
fi

# Check environment variables
echo ""
echo "📝 Environment Variables:"
if [ -f ".env.example" ]; then
    print_status 0 ".env.example exists"
    echo "   Review .env.example for required variables"
else
    echo -e "${YELLOW}⚠️  .env.example not found${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Vercel validation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Push code to GitHub"
echo "2. Connect repository to Vercel"
echo "3. Set environment variables in Vercel dashboard"
echo "4. Deploy!"
