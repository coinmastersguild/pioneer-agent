const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.use(express.static("client/dist"));

app.get("/api/health", (req, res) => {
  res.json({ status: "ok", version: "0.25.9" });
});

app.listen(port, () => {
  console.log(`Eliza Multi-Agent running on port ${port}`);
}); 