# Ashwani Portfolio (Monorepo)

A production-grade portfolio site built with Vite + React (frontend) and Express (backend). Deployed on Vercel.

## Quick Start (Local Development)

### Frontend
```bash
# from repo root
npm install
npm run dev      # starts on http://localhost:5173
```

### Backend (Optional)
```bash
cd server
npm install
npm run dev      # starts on http://localhost:4000
```

## Vercel Deployment

### Automatic Deployment (Recommended)
1. Push your code to GitHub
2. Go to [vercel.com](https://vercel.com) and connect your GitHub repository
3. Vercel will auto-detect the Vite configuration
4. Set environment variables (see below)
5. Click "Deploy" — done!

### Environment Variables (Frontend)
In your Vercel project settings, add:
- **VITE_API_URL** (optional): API base URL for portfolio data
  - Leave empty to use default (localhost:4000 in dev, same-origin in prod)
  - Production example: `https://api.yourdomain.com`

### CLI Deployment
```bash
npm install -g vercel
vercel              # deploy current branch
vercel --prod       # deploy to production
```

### Verify Deployment
- Check build logs in Vercel dashboard for errors
- Frontend will be served at `https://your-project.vercel.app`
- API requests default to same origin (no CORS needed for Vercel deployment)

## Build & Production

### Local Production Build
```bash
npm run build       # creates optimized dist/ folder
npm run preview     # serves dist/ locally (simulates production)
```

### Build Output
- `dist/index.html` — SPA entry point
- `dist/assets/` — CSS and JS bundles (minified & hashed)
- All static assets optimized for production

## Project Structure
```
/
├── src/                    # Frontend (Vite + React)
│   ├── components/         # React components
│   ├── pages/             # Page components
│   ├── hooks/             # Custom hooks (usePortfolio)
│   ├── data/              # Portfolio data
│   ├── styles/            # Global styles (Tailwind)
│   └── App.jsx            # Main app component
├── server/                 # Backend (Express)
│   ├── src/index.js       # Express server
│   ├── data/              # Static data (portfolio.json)
│   └── package.json       # Backend deps
├── vercel.json            # Vercel build config
├── docker-compose.yml     # Local Docker compose
├── vite.config.js         # Vite config
└── package.json           # Root deps & scripts
```

## Docker Deployment

### Quick Start
```bash
docker compose up --build   # spins up frontend + backend
```

### Services
- **Frontend**: http://localhost:3000 (Nginx)
- **Backend API**: http://localhost:4000 (Express)

### Individual Builds
```bash
# Frontend only
docker build -t ashwani-portfolio-frontend .
docker run -p 3000:80 ashwani-portfolio-frontend

# Backend only
cd server
docker build -t ashwani-portfolio-server .
docker run -p 4000:4000 ashwani-portfolio-server
```

### Validation Scripts
```bash
# Validate Docker configuration
bash scripts/validate-docker.sh

# Validate Vercel configuration
bash scripts/validate-vercel.sh
```

## Production Deployment

📖 **See [DEPLOYMENT.md](./DEPLOYMENT.md) for comprehensive deployment guide**

### Quick Reference

**Vercel (Frontend):**
- Auto-deploys on GitHub push
- Configure `VITE_API_URL` in Vercel dashboard if using external API

**Docker (Full-Stack):**
- Multi-stage builds optimized for production
- Health checks configured
- Non-root user execution for security

**Backend API:**
- Deploy separately to Railway, Render, Fly.io, etc.
- Set `VITE_API_URL` in frontend to point to backend

## Notes
- Frontend auto-deploys via Vercel on every GitHub push
- Backend API is optional (portfolio data is bundled in frontend)
- For production API integration, deploy backend separately and set `VITE_API_URL` in Vercel dashboard
- All Docker images use multi-stage builds for optimal size
- Health checks are configured for both frontend and backend
