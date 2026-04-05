# ---------- 🏗️ Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy root-level files
COPY package*.json ./
COPY package-lock.json ./
COPY tsconfig.base.json ./

# Copy only frontend package.json for caching
COPY apps/frontend/package.json ./apps/frontend/

# Install only frontend deps
RUN npm ci --workspace=apps/frontend

# Copy frontend source only (NOT entire monorepo)
COPY apps/frontend/ ./apps/frontend/

# Build from frontend folder
WORKDIR /app/apps/frontend
RUN npm run build

# ---------- 🚀 Stage 2: Production ----------
FROM nginx:alpine

RUN rm -rf /etc/nginx/conf.d/default.conf

# nginx.conf is at monorepo root
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/apps/frontend/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]