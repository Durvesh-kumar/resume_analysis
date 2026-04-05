# ---------- 🏗️ Build Stage ----------
FROM node:18-alpine AS builder

WORKDIR /app

# Install deps (only needed files for caching)
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Build app
RUN npm run build

# ---------- 🚀 Production Stage ----------
FROM nginx:alpine

# Remove default config
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy custom config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build output
COPY --from=builder /app/dist /usr/share/nginx/html

# ---------- 🤖 Lightweight Health Check ----------
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q --spider http://localhost || exit 1

# ---------- 🌐 Expose ----------
EXPOSE 80

# ---------- 🚀 Start ----------
CMD ["nginx", "-g", "daemon off;"]