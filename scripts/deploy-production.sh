#!/bin/bash

set -e

echo "🤖 Local AI Deployment Agent Starting..."

# ✅ Always run from monorepo root regardless of where script is called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"  # parent of scripts/
cd "$PROJECT_DIR"

echo "📁 Working directory: $PROJECT_DIR"

COMPOSE_FILE="docker-compose.production.yaml"

# Check compose file exists
if [ ! -f "$COMPOSE_FILE" ]; then
  echo "❌ $COMPOSE_FILE not found in $PROJECT_DIR"
  echo "   Expected structure:"
  echo "   Resume_Analysis/"
  echo "   ├── docker-compose.production.yaml"
  echo "   └── scripts/"
  echo "       └── local-production.sh"
  exit 1
fi

echo "🔍 Checking system requirements..."
command -v docker &>/dev/null || { echo "❌ Docker not found"; exit 1; }
command -v docker-compose &>/dev/null || { echo "❌ docker-compose not found"; exit 1; }
echo "✅ Docker & docker-compose found"

echo "🛑 Stopping existing containers..."
docker-compose -f $COMPOSE_FILE down

echo "🧹 Cleaning unused Docker resources..."
docker system prune -f

echo "🔨 Building and starting containers (force recreate all)..."
docker-compose -f $COMPOSE_FILE up -d --build --force-recreate

echo "⏳ Waiting for services to stabilize..."
sleep 10

echo "🔍 Checking running containers..."
docker ps

echo "🧠 Running Health Checks..."

FAILED_CONTAINERS=$(docker ps -a --filter "status=exited" --format "{{.Names}}")

if [ -n "$FAILED_CONTAINERS" ]; then
  echo "❌ Detected failed containers:"
  echo "$FAILED_CONTAINERS"
  docker-compose -f $COMPOSE_FILE logs --tail=20
  echo "🤖 Suggestions:"
  echo "  - Check .env file"
  echo "  - Verify ports 80 and 5000 are free"
  exit 1
fi

echo "🌐 Checking backend..."
if curl -sf http://localhost:5000/health > /dev/null; then
  echo "✅ Backend is up"
else
  echo "❌ Backend not responding"
  docker-compose -f $COMPOSE_FILE logs backend --tail=20
  exit 1
fi

echo "🌐 Checking frontend..."
if curl -sf http://localhost > /dev/null; then
  echo "✅ Frontend is up"
else
  echo "❌ Frontend not responding"
  docker-compose -f $COMPOSE_FILE logs frontend --tail=20
  exit 1
fi

echo ""
echo "✅ Local Production Stack is Running 🎉"
echo ""
echo "  Frontend → http://localhost"
echo "  Backend  → http://localhost:5000"
echo "  API      → http://localhost/api/"
echo ""

echo "📊 Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "📜 Recent Logs:"
docker-compose -f $COMPOSE_FILE logs --tail=5

# Make executable and run from monorepo root:
# chmod +x scripts/local-production.sh
# ./scripts/local-production.sh