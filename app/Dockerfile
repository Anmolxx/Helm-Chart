FROM node:18-alpine AS builder

WORKDIR /app

ENV NODE_OPTIONS=--openssl-legacy-provider

COPY package*.json ./

RUN npm install --no-audit --no-fund

COPY . .

RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]