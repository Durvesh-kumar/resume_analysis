# 🚀 AI-Powered Monorepo Deployment (React + Node.js + Docker + AWS)

A **production-ready full-stack monorepo** that demonstrates modern DevOps practices using:

- ⚛️ React (Frontend)
- 🚀 Node.js + Express (Backend)
- 🐳 Docker (Containerization)
- 🌐 Nginx (Reverse Proxy)
- ☁️ AWS EC2 (Deployment)
- 🔄 CI/CD (GitHub Actions)
- 🤖 AI Agent (Automated Debugging & Health Checks)

---

# 📌 Project Overview

This project is designed to simulate a **real-world production system** where:

- Frontend and backend are managed in a **monorepo**
- Services are containerized using **Docker**
- Traffic is routed using **Nginx**
- Deployment is automated using **CI/CD pipeline**
- Failures are detected and analyzed using an **AI-based agent**

---

# 🧠 Key Features

## 🤖 AI Agent (DevOps Automation)
- Automatically checks container health
- Detects failed services
- Reads logs and suggests fixes
- Helps in faster debugging during deployment

## 🐳 Dockerized Architecture
- Multi-stage builds (optimized images)
- Lightweight containers using Alpine images
- Isolated services (frontend, backend, nginx)

## 🌐 Reverse Proxy (Nginx)
- Serves React frontend
- Routes `/api` requests to backend
- Handles SPA routing
- Adds security headers

## 🔄 CI/CD Pipeline
- Builds Docker images
- Runs automated tests
- Executes AI validation scripts
- Deploys to AWS EC2 automatically

---

# 📁 Project Structure

my-monorepo/
│
├── apps/
│ ├── frontend/ # React (TypeScript)
│ │ ├── Dockerfile
│ │ └── nginx.conf
│ │
│ └── backend/ # Express (TypeScript)
│ ├── Dockerfile
│ └── src/
│
├── nginx/
│ └── nginx.conf # Reverse proxy config
│
├── script/
│ ├── local-production.sh # AI agent for local testing
│ └── deploy-production.sh # AI agent for AWS deployment
│
├── docker-compose.production.yaml
├── .github/workflows/docker-build.yml
└── README.md



---

# ⚙️ Tech Stack

| Layer        | Technology |
|-------------|-----------|
| Frontend     | React + TypeScript |
| Backend      | Node.js + Express |
| DevOps       | Docker, Docker Compose |
| Web Server   | Nginx |
| Cloud        | AWS EC2 |
| CI/CD        | GitHub Actions |

---

# 🐳 Docker Setup

## 🔨 Build & Run (Production)

```bash
docker-compose -f docker-compose.production.yaml up -d --build

```
## Stop Services
```bash
docker-compose -f docker-compose.production.yaml down
```

## Local AI Deployment
```bash
./script/local-production.sh
```