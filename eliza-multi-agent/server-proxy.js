const express = require("express");
const { createProxyMiddleware } = require("http-proxy-middleware");
const app = express();
const port = process.env.PORT || 8080;

// Forward API requests to the API server
app.use(
  "/api",
  createProxyMiddleware({
    target: "http://localhost:3000",
    changeOrigin: true,
  })
);

// Forward all other requests to the Vite dev server
app.use(
  "/",
  createProxyMiddleware({
    target: "http://localhost:5173",
    changeOrigin: true,
    ws: true, // support websocket
  })
);

// Start the server on all interfaces
app.listen(port, "0.0.0.0", () => {
  console.log(`Proxy server running on all interfaces at port ${port}`);
}); 