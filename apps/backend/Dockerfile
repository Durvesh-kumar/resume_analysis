# # ---------- 🏗️ Stage 1: Build ----------
# FROM node:20-alpine AS builder

# WORKDIR /app

# # Copy root-level package files
# COPY package*.json ./
# COPY package-lock.json ./

# # ✅ Copy root tsconfig that backend extends
# COPY tsconfig.base.json ./

# # Copy workspace package.json for caching
# COPY apps/backend/package.json ./apps/backend/

# # Install deps
# RUN npm ci --workspace=apps/backend

# # Copy backend source
# COPY apps/backend/ ./apps/backend/

# # Build
# WORKDIR /app/apps/backend
# RUN npm run build

# # ---------- 🚀 Stage 2: Production ----------
# FROM node:20-alpine

# WORKDIR /app

# COPY --from=builder /app/apps/backend/package.json ./package.json
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/apps/backend/dist ./dist

# HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
#   CMD wget -qO- http://localhost:5000 || exit 1

# EXPOSE 5000

# CMD ["node", "dist/index.js"]


# ---------- 🏗️ Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY package-lock.json ./
COPY tsconfig.base.json ./
COPY apps/backend/package.json ./apps/backend/

# Install ALL deps (including devDependencies for build)
RUN npm ci --workspace=apps/backend

COPY apps/backend/ ./apps/backend/

WORKDIR /app/apps/backend
RUN npm run build

# ---------- 🚀 Stage 2: Production ----------
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
COPY package-lock.json ./
COPY apps/backend/package.json ./apps/backend/

# ✅ Only production deps — skips devDependencies (typescript, ts-node, etc.)
RUN npm ci --workspace=apps/backend --omit=dev

# ✅ Clean npm cache after install
RUN npm cache clean --force

COPY --from=builder /app/apps/backend/dist ./dist

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:5000 || exit 1

EXPOSE 5000

CMD ["node", "dist/index.js"]