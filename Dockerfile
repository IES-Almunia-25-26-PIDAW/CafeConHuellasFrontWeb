# ── Stage 1: Build Flutter Web ──────────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# ARG para inyectar la URL del backend en tiempo de build
ARG BACKEND_URL=http://localhost:8087

RUN flutter build web --release \
    --dart-define=BACKEND_URL=$BACKEND_URL

# ── Stage 2: Serve with Nginx ────────────────────────────────────────
FROM nginx:alpine

COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80