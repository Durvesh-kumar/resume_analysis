#!/bin/bash

set -e

echo "🤖 Local AI Deployment Agent Starting..."

PROJECT_DIR=$(pwd)

# 🔹 Step 1: Check prerequisites
echo "🔍 Checking system requirements..."

command -v docker >/dev/null 2>&1 || {
  echo "❌ Docker is not installed"
  exit 1
}

command -v docker-compose >/dev/null 2>&1 || {
  echo "❌ docker-compose is not installed"
  exit 1
}

echo "✅ Docker & docker-compose found"

# 🔹 Step 2: Check port usage
echo "🔍 Checking ports (80, 5000)..."

if lsof -i :80 >/dev/null 2>&1; then
  echo "⚠️ Port 80 is in use"
fi

if lsof -i :5000 >/dev/null 2>&1; then
  echo "⚠️ Port 5000 is in use"
fi

# 🔹 Step 3: Install dependencies (optional safety)
echo "📦 Installing dependencies..."
npm install

# 🔹 Step 4: Stop old containers
echo "🛑 Stopping existing containers..."
docker-compose down

# 🔹 Step 5: Clean Docker
echo "🧹 Cleaning unused Docker resources..."
docker system prune -f

# 🔹 Step 6: Build and run
echo "🔨 Building and starting containers..."
docker-compose up -d --build

# 🔹 Step 7: Wait for startup
echo "⏳ Waiting for services..."
sleep 5

# 🔹 Step 8: AI Health Check
echo "🧠 Running health checks..."

FAILED=$(docker ps -a --filter "status=exited" --format "{{.Names}}")

if [ ! -z "$FAILED" ]; then
  echo "❌ Failed containers detected:"
  echo "$FAILED"

  echo "📜 Logs:"
  docker-compose logs --tail=20

  echo "🤖 AI Suggestions:"
  echo "- Check Dockerfile"
  echo "- Check environment variables (.env)"
  echo "- Ensure ports are free"
  echo "- Run: docker-compose build again"

  exit 1
fi

# 🔹 Step 9: Backend check
echo "🌐 Checking backend..."
curl -f http://localhost:5000 >/dev/null 2>&1 || {
  echo "❌ Backend failed"
  docker-compose logs backend --tail=20
  exit 1
}

# 🔹 Step 10: Frontend check
echo "🌐 Checking frontend..."
curl -f http://localhost >/dev/null 2>&1 || {
  echo "❌ Frontend failed"
  docker-compose logs frontend --tail=20
  exit 1
}

# 🔹 Step 11: Success
echo "✅ Local Deployment Successful 🎉"

echo "📊 Running containers:"
docker ps

echo "🌍 Access your app:"
echo "Frontend: http://localhost"
echo "Backend:  http://localhost:5000"

# Make Executable
# chmod +x local-production.sh

# Run Script
# ./local-production.sh