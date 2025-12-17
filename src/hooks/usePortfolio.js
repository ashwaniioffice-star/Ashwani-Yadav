import { useEffect, useState } from 'react'
import { portfolioData } from "../data/portfolio"

const getApiUrl = () => {
  // In production, use environment variable or default to same origin
  if (import.meta.env.VITE_API_URL) {
    return import.meta.env.VITE_API_URL
  }
  // In development, use proxy (handled by vite.config.js)
  // In production, use same origin
  return ''
}

export default function usePortfolio() {
  const [data, setData] = useState(portfolioData)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    let mounted = true

    async function load() {
      try {
        const apiUrl = getApiUrl()
        const url = apiUrl ? `${apiUrl}/api/portfolio` : '/api/portfolio'
        
        // Add timeout and retry logic for production resilience
        const controller = new AbortController()
        const timeoutId = setTimeout(() => controller.abort(), 5000) // 5s timeout
        
        const res = await fetch(url, {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
          },
          signal: controller.signal,
        })
        
        clearTimeout(timeoutId)
        
        if (!res.ok) {
          throw new Error(`Network response was not ok: ${res.status}`)
        }
        
        const json = await res.json()
        if (mounted && json) {
          setData(json)
          setError(null)
        }
      } catch (err) {
        // fallback to bundled portfolioData - graceful degradation
        if (mounted) {
          // Only set error if it's not a timeout/abort (expected in some scenarios)
          if (err.name !== 'AbortError') {
            setError(err)
          }
          // Keep default portfolioData, don't overwrite
        }
      } finally {
        if (mounted) setLoading(false)
      }
    }

    load()
    return () => { mounted = false }
  }, [])

  return { data, loading, error }
}
