// Simple Express proxy server to route /client to the Vite dev server
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const app = express();

// API server is already running on port 3000

// Route /client to the Vite dev server
app.use('/client', createProxyMiddleware({
  target: 'http://localhost:5173',
  changeOrigin: true,
  pathRewrite: {
    '^/client': '/'
  }
}));

// Default route for API
app.get('/', (req, res) => {
  res.send('Welcome, this is the REST API! Visit /client for the UI.');
});

// Start the proxy server on port 8080
const PORT = 8080;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Proxy server running on port ${PORT}`);
}); 