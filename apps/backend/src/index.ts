import express from "express";

const app = express();

app.get("/health", (req, res) => res.send("OK"));

app.get("/", (req, res) => {
  res.send("Hello from backend 🚀");
});

app.listen(5000, () => {
  console.log("Server running on http://localhost:5000");
});