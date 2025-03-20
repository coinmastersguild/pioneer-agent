// Simple Express API server with health endpoint
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Enable CORS
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'ok', message: 'API server is running' });
});

// Root endpoint
app.get('/', (req, res) => {
  res.status(200).json({ 
    name: 'Pioneer Agent API',
    version: '1.0.0',
    endpoints: [
      { path: '/api/health', method: 'GET', description: 'Health check endpoint' }
    ]
  });
});

// Start the server
app.listen(port, '0.0.0.0', () => {
  console.log(`API server running on port ${port}`);
}); 