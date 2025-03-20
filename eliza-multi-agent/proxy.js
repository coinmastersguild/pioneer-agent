// Simple Express proxy server to route /client to the Vite dev server
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const app = express();

// Route /client to the Vite dev server on localhost:5173
app.use('/client', createProxyMiddleware({
  target: 'http://localhost:5173',
  changeOrigin: true,
  pathRewrite: {
    '^/client': '/'
  }
}));

// Default route for API
app.use('/', createProxyMiddleware({
  target: 'http://localhost:3000',
  changeOrigin: true
}));

// Start the proxy server on port 8080
const PORT = 8080;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Proxy server running on port ${PORT}`);
  console.log(`API available at /`);
  console.log(`Client UI available at /client`);
}); 