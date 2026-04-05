import express, { Request, Response } from "express";

const app = express();

app.get("/health", (req:Request, res:Response) => res.send("OK"));

app.get("/", (req:Request, res:Response) => {
  res.send("Hello from backend 🚀");
});

app.listen(5000, () => {
  console.log("Server running on http://localhost:5000");
});