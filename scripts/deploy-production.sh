#!/bin/bash

set -e

echo "🤖 AI Deployment Agent Starting..."

PROJECT_DIR=~/resume_analysis

# Step 1: Go to project
cd $PROJECT_DIR || { echo "❌ Project not found"; exit 1; }

echo "📥 Pulling latest code..."
git pull origin main

echo "🛑 Stopping old containers..."
docker-compose down

echo "🧹 Cleaning unused Docker resources..."
docker system prune -f

echo "🔨 Building and starting containers..."
docker-compose up -d --build

echo "⏳ Waiting for services to stabilize..."
sleep 5

echo "🔍 Checking running containers..."
docker ps

# Step 2: AI-like health check
echo "🧠 Running AI Health Checks..."

FAILED_CONTAINERS=$(docker ps -a --filter "status=exited" --format "{{.Names}}")

if [ ! -z "$FAILED_CONTAINERS" ]; then
  echo "❌ Detected failed containers:"
  echo "$FAILED_CONTAINERS"

  echo "📜 Fetching logs..."
  docker-compose logs --tail=20

  echo "🤖 AI Suggestion:"
  echo "- Check environment variables (.env)"
  echo "- Verify ports are free"
  echo "- Ensure dependencies installed"

  exit 1
fi

# Step 3: Check backend health
echo "🌐 Checking backend API..."
curl -f http://localhost:5000 || {
  echo "❌ Backend not responding"
  echo "📜 Logs:"
  docker-compose logs backend --tail=20
  exit 1
}

# Step 4: Check frontend
echo "🌐 Checking frontend..."
curl -f http://localhost || {
  echo "❌ Frontend not responding"
  docker-compose logs frontend --tail=20
  exit 1
}

echo "✅ Deployment Successful 🎉"

# Step 5: Show logs summary
echo "📊 Final Container Status:"
docker ps

echo "📜 Recent Logs:"
docker-compose logs --tail=10


# chmod +x deploy-production.sh
# docker-compose logs | curl AI_API → get fix suggestions

# I built a deployment script that acts like an AI agent by automatically checking container health, analyzing logs, and suggesting fixes during CI/CD deployment.