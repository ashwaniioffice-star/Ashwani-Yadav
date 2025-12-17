const http = require('http')

const data = JSON.stringify({ username: 'admin', password: 'password' })

const options = {
  hostname: 'localhost',
  port: 4000,
  path: '/api/auth/login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(data),
  },
}

const req = http.request(options, (res) => {
  let body = ''
  res.setEncoding('utf8')
  res.on('data', (chunk) => { body += chunk })
  res.on('end', () => {
    console.log('Status:', res.statusCode)
    try {
      const json = JSON.parse(body)
      console.log('Body:', JSON.stringify(json, null, 2))
    } catch (e) {
      console.log('Response body:', body)
    }
  })
})

req.on('error', (e) => {
  console.error('Request error:', e.message)
})

req.write(data)
req.end()
