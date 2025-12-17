# Production Deployment Guide

## Overview

This portfolio application is configured for deployment on:
- **Vercel** (Frontend - Recommended)
- **Docker** (Full-stack - Frontend + Backend)
- **Any Node.js hosting** (Backend API)

---

## 🚀 Vercel Deployment (Frontend)

### Prerequisites
- Vercel account
- GitHub repository connected to Vercel

### Automatic Deployment

1. **Connect Repository**
   - Go to [vercel.com](https://vercel.com)
   - Import your GitHub repository
   - Vercel will auto-detect Vite configuration

2. **Environment Variables** (Optional)
   - Go to Project Settings → Environment Variables
   - Add `VITE_API_URL` if using external API:
     - Example: `https://api.yourdomain.com`
     - Leave empty to use same-origin (recommended for Vercel)

3. **Deploy**
   - Push to main branch → Auto-deploys
   - Or use Vercel CLI: `vercel --prod`

### Manual CLI Deployment

```bash
npm install -g vercel
vercel              # Deploy to preview
vercel --prod       # Deploy to production
```

### Vercel Configuration

The `vercel.json` includes:
- ✅ SPA routing (all routes → `/index.html`)
- ✅ Security headers (XSS, Frame, Content-Type protection)
- ✅ Asset caching (1 year for static assets)
- ✅ Optimized build settings

---

## 🐳 Docker Deployment (Full-Stack)

### Prerequisites
- Docker & Docker Compose installed
- Ports 3000 (frontend) and 4000 (backend) available

### Quick Start

```bash
# Build and start all services
docker-compose up --build

# Or run in detached mode
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Services

1. **Frontend** (Port 3000)
   - React + Vite application
   - Served via Nginx
   - Health check: `http://localhost:3000/health`

2. **Backend** (Port 4000)
   - Express API server
   - Health check: `http://localhost:4000/api/health`
   - Portfolio API: `http://localhost:4000/api/portfolio`

### Environment Variables (Docker)

Create `.env` file in project root:

```env
# Frontend
VITE_API_URL=http://server:4000

# Backend
PORT=4000
NODE_ENV=production
```

### Individual Container Builds

**Frontend:**
```bash
docker build -t ashwani-portfolio-frontend .
docker run -p 3000:80 ashwani-portfolio-frontend
```

**Backend:**
```bash
cd server
docker build -t ashwani-portfolio-server .
docker run -p 4000:4000 -e PORT=4000 ashwani-portfolio-server
```

### Production Docker Optimizations

✅ Multi-stage builds (minimal image size)
✅ Non-root user execution (security)
✅ Health checks configured
✅ Proper caching layers
✅ Alpine Linux base (small footprint)

---

## 🔧 Backend API Deployment

### Standalone Node.js Server

The backend can be deployed separately:

**Options:**
- Railway
- Render
- Fly.io
- DigitalOcean App Platform
- AWS Elastic Beanstalk
- Google Cloud Run

### Environment Variables

```env
PORT=4000
NODE_ENV=production
```

### Deployment Steps

1. **Install Dependencies**
   ```bash
   cd server
   npm ci --only=production
   ```

2. **Start Server**
   ```bash
   npm start
   # or
   node src/index.js
   ```

3. **Update Frontend**
   - Set `VITE_API_URL` to your backend URL
   - Example: `VITE_API_URL=https://api.yourdomain.com`

---

## 📋 Health Checks

### Frontend
```bash
curl http://localhost:3000/health
# Expected: "healthy"
```

### Backend
```bash
curl http://localhost:4000/api/health
# Expected: {"status":"ok","timestamp":"..."}
```

### Portfolio API
```bash
curl http://localhost:4000/api/portfolio
# Expected: JSON portfolio data
```

---

## 🔒 Security Checklist

- ✅ Security headers configured (Vercel)
- ✅ Non-root Docker user
- ✅ Environment variables (no hardcoded secrets)
- ✅ CORS properly configured
- ✅ Input validation
- ✅ Error handling (no sensitive data leaks)

---

## 🚨 Troubleshooting

### Build Failures

**Vercel:**
- Check build logs in Vercel dashboard
- Verify Node.js version (20.x recommended)
- Ensure all dependencies are in `package.json`

**Docker:**
- Check Dockerfile syntax
- Verify file paths in COPY commands
- Ensure `.dockerignore` excludes unnecessary files

### API Connection Issues

**Frontend can't reach backend:**
- Verify `VITE_API_URL` is set correctly
- Check CORS settings on backend
- Ensure backend is running and accessible
- Check network/firewall rules

**Docker networking:**
- Use service names in `docker-compose.yml` (e.g., `http://server:4000`)
- Verify `depends_on` is configured
- Check container logs: `docker-compose logs`

### Port Conflicts

**Change ports in docker-compose.yml:**
```yaml
ports:
  - "8080:80"    # Frontend
  - "5000:4000"  # Backend
```

---

## 📊 Performance Optimization

### Frontend
- ✅ Code splitting (React vendor chunk)
- ✅ Asset minification
- ✅ Gzip compression (Nginx)
- ✅ Long-term caching for static assets

### Backend
- ✅ Minimal dependencies
- ✅ Efficient JSON parsing
- ✅ Graceful error handling
- ✅ Health check endpoints

---

## 🔄 CI/CD Integration

### GitHub Actions Example

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
```

---

## 📝 Environment Variables Reference

| Variable | Platform | Required | Description |
|----------|----------|----------|-------------|
| `VITE_API_URL` | Frontend | No | Backend API URL (default: same-origin) |
| `PORT` | Backend | No | Server port (default: 4000) |
| `NODE_ENV` | Backend | No | Environment (production/development) |

---

## ✅ Deployment Verification

After deployment, verify:

1. ✅ Frontend loads without errors
2. ✅ API endpoints respond correctly
3. ✅ Health checks return 200 OK
4. ✅ No console errors in browser
5. ✅ Portfolio data displays correctly
6. ✅ All routes work (SPA routing)
7. ✅ Security headers present
8. ✅ Assets load with proper caching

---

## 🆘 Support

For issues:
1. Check logs (Vercel dashboard / Docker logs)
2. Verify environment variables
3. Test health check endpoints
4. Review this deployment guide

---

**Last Updated:** 2025-12-17
**Version:** 1.0.0
