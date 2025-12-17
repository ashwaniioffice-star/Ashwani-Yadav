const express = require('express')
const cors = require('cors')
const dotenv = require('dotenv')
const fs = require('fs')
const path = require('path')

dotenv.config()

const app = express()
app.use(cors())
app.use(express.json())

// Serve a simple health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() })
})

// Load portfolio data from local JSON file
const portfolioPath = path.join(__dirname, '../data/portfolio.json')
let portfolio = {}

try {
  const portfolioFile = fs.readFileSync(portfolioPath, 'utf8')
  portfolio = JSON.parse(portfolioFile)
} catch (err) {
  console.error('Error loading portfolio data:', err.message)
  portfolio = {
    personal: {
      name: "Ashwani Yadav",
      title: "Senior Product Manager & Technical Leader",
      email: "ashwani@example.com",
    },
    social: [],
    experience: [],
    projects: [],
    skills: [],
    testimonials: [],
  }
}

app.get('/api/portfolio', (req, res) => {
  res.json(portfolio)
})

// Note: auth endpoints removed — this backend serves portfolio data only.

const PORT = process.env.PORT || 4000
app.listen(PORT, () => {
  console.log(`API server listening on http://localhost:${PORT}`)
  console.log(`Health check: http://localhost:${PORT}/api/health`)
  console.log(`Portfolio API: http://localhost:${PORT}/api/portfolio`)
})
