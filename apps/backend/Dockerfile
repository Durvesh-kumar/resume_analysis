# ---------- 🏗️ Stage 1: Build ----------
FROM node:18-alpine AS builder

WORKDIR /app

# Install only package files first (for caching)
COPY package*.json ./

# Clean install (faster + reproducible)
RUN npm install --ignore-scripts

# Copy source code
COPY . .

# Build TypeScript → JavaScript
RUN npm run build

# ---------- 🚀 Stage 2: Production ----------
FROM node:18-alpine

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# ---------- 🤖 AI-style Health Check ----------
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:5000 || exit 1

# ---------- 🌐 Expose ----------
EXPOSE 5000

# ---------- 🚀 Start ----------
CMD ["node", "dist/index.js"]


# docker build -t backend ./apps/backend
# docker run -p 5000:5000 backend