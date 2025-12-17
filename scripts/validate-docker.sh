#!/bin/bash
# Docker Build Validation Script
# Validates that Docker builds succeed and containers run correctly

set -e

echo "🔍 Validating Docker Configuration..."

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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker is not installed. Skipping Docker validation.${NC}"
    echo "   Install Docker to test container builds."
    exit 0
fi

# Validate Frontend Dockerfile
echo ""
echo "📦 Building Frontend Docker image..."
cd "$(dirname "$0")/.."
if docker build -t ashwani-portfolio-frontend:test -f Dockerfile . > /tmp/frontend-build.log 2>&1; then
    print_status 0 "Frontend Docker build successful"
else
    print_status 1 "Frontend Docker build failed"
    cat /tmp/frontend-build.log
    exit 1
fi

# Validate Backend Dockerfile
echo ""
echo "📦 Building Backend Docker image..."
cd server
if docker build -t ashwani-portfolio-server:test -f Dockerfile . > /tmp/backend-build.log 2>&1; then
    print_status 0 "Backend Docker build successful"
else
    print_status 1 "Backend Docker build failed"
    cat /tmp/backend-build.log
    exit 1
fi

# Test container startup
echo ""
echo "🚀 Testing container startup..."

# Test backend
echo "  Testing backend container..."
if docker run -d --name test-backend -p 4001:4000 ashwani-portfolio-server:test > /dev/null 2>&1; then
    sleep 2
    if curl -f http://localhost:4001/api/health > /dev/null 2>&1; then
        print_status 0 "Backend container health check passed"
        docker rm -f test-backend > /dev/null 2>&1
    else
        print_status 1 "Backend container health check failed"
        docker logs test-backend
        docker rm -f test-backend > /dev/null 2>&1
        exit 1
    fi
else
    print_status 1 "Backend container failed to start"
    exit 1
fi

# Test frontend
echo "  Testing frontend container..."
cd ..
if docker run -d --name test-frontend -p 3001:80 ashwani-portfolio-frontend:test > /dev/null 2>&1; then
    sleep 2
    if curl -f http://localhost:3001/health > /dev/null 2>&1; then
        print_status 0 "Frontend container health check passed"
        docker rm -f test-frontend > /dev/null 2>&1
    else
        print_status 1 "Frontend container health check failed"
        docker logs test-frontend
        docker rm -f test-frontend > /dev/null 2>&1
        exit 1
    fi
else
    print_status 1 "Frontend container failed to start"
    exit 1
fi

# Cleanup test images (optional)
echo ""
read -p "🧹 Remove test images? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker rmi ashwani-portfolio-frontend:test ashwani-portfolio-server:test > /dev/null 2>&1
    echo -e "${GREEN}✅ Test images removed${NC}"
fi

echo ""
echo -e "${GREEN}🎉 All Docker validations passed!${NC}"
