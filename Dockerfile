# LobeChat Dockerfile
# Based on official lobehub/lobe-chat Dockerfile (simplified for learning)

ARG NODEJS_VERSION="20"

## Base image
FROM node:${NODEJS_VERSION}-alpine AS base
RUN apk add --no-cache libc6-compat git

## Builder stage
FROM base AS builder

WORKDIR /app

# Clone LobeChat repository
RUN git clone --depth 1 https://github.com/lobehub/lobe-chat.git .

# Build environment variables (required for Next.js build)
ENV APP_URL="http://localhost:3210" \
    DATABASE_DRIVER="node" \
    DATABASE_URL="postgres://postgres:password@localhost:5432/postgres" \
    KEY_VAULTS_SECRET="build-placeholder" \
    AUTH_SECRET="build-placeholder" \
    NODE_OPTIONS="--max-old-space-size=8192" \
    NEXT_TELEMETRY_DISABLED=1

# Install pnpm via corepack
RUN npm i -g corepack@latest && \
    corepack enable && \
    corepack use pnpm@9

# Install dependencies
RUN pnpm install

# Build standalone version for Docker
RUN pnpm run build:docker

# Install pg and drizzle-orm for database migrations
RUN mkdir -p /deps && \
    cd /deps && \
    pnpm init && \
    pnpm add pg drizzle-orm

## Runner stage
FROM node:${NODEJS_VERSION}-alpine AS runner

WORKDIR /app

ENV NODE_ENV="production" \
    NEXT_TELEMETRY_DISABLED=1 \
    HOSTNAME="0.0.0.0" \
    PORT="3210"

# Create non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# Copy standalone build
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

# Copy database migrations
COPY --from=builder /app/packages/database/migrations ./migrations
COPY --from=builder /app/scripts/migrateServerDB/docker.cjs ./docker.cjs
COPY --from=builder /app/scripts/migrateServerDB/errorHint.js ./errorHint.js

# Copy database dependencies
COPY --from=builder /deps/node_modules/.pnpm ./node_modules/.pnpm
COPY --from=builder /deps/node_modules/pg ./node_modules/pg
COPY --from=builder /deps/node_modules/drizzle-orm ./node_modules/drizzle-orm

# Copy server launcher
COPY --from=builder /app/scripts/serverLauncher/startServer.js ./startServer.js
COPY --from=builder /app/scripts/_shared ./scripts/_shared

RUN chown -R nextjs:nodejs /app

USER nextjs

EXPOSE 3210

CMD ["node", "startServer.js"]
