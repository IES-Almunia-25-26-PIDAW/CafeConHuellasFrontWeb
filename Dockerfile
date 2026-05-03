# ══════════════════════════════════════════════════════════════════
# DOCKERFILE - FRONTEND (Flutter Web)
# Café con Huellas — Aplicación Web
# Construcción multi-stage: compila Flutter y sirve con Nginx
# ══════════════════════════════════════════════════════════════════

# ── Stage 1: BUILD (Flutter) ───────────────────────────────────────
# Imagen oficial de Flutter estable de CirrusLabs para compilar
# la aplicación Flutter para la plataforma web
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copiamos primero los archivos de dependencias para aprovechar
# la caché de Docker: si pubspec no cambia, no reinstala paquetes
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copiamos el resto del código fuente
COPY . .

# ARG permite inyectar la URL del backend en tiempo de build
# mediante --build-arg o la sección args: del docker-compose.
# Si no se especifica, usa localhost:8087 como valor por defecto.
ARG BACKEND_URL=http://localhost:8087

# Compilamos la app Flutter para web en modo release.
# --dart-define inyecta la variable BACKEND_URL en el código Dart
# para que la app sepa a qué API conectarse sin hardcodear la URL.
RUN flutter build web --release \
    --dart-define=BACKEND_URL=$BACKEND_URL


# ── Stage 2: SERVE (Nginx) ─────────────────────────────────────────
# Imagen Alpine de Nginx, muy ligera (~5MB), para servir
# los archivos estáticos generados por Flutter Web
FROM nginx:alpine

# Copiamos los archivos compilados de Flutter al directorio
# por defecto de Nginx para servir contenido estático
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copiamos nuestra configuración personalizada de Nginx.
# Es importante para que el enrutamiento de Flutter Web (SPA)
# funcione correctamente: todas las rutas deben devolver index.html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Puerto 80: Nginx escucha en este puerto por defecto
EXPOSE 80