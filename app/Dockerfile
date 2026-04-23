FROM node:18-alpine AS builder

WORKDIR /app

ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy the app manifest and repo lockfile from the build context root
COPY package.json ./package.json
COPY package-lock.json ./package-lock.json
COPY . .

# Install dependencies from the lockfile
RUN npm ci --no-audit --no-fund

# Copy application code
COPY app/. .

# Build the React application
RUN npm run build

# Stage 2: Production stage
FROM nginx:alpine

# Copy built files from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
