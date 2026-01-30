# Multi-stage Dockerfile for Flutter CI/CD

# Stage 1: Flutter Build Environment
FROM cirrusci/flutter:3.24.0 AS flutter-builder

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Create .env file for build
RUN echo "SUPABASE_URL=\${SUPABASE_URL}" > .env && \
    echo "SUPABASE_ANON_KEY=\${SUPABASE_ANON_KEY}" >> .env

# Generate app icons
RUN flutter pub run flutter_launcher_icons:main

# Build APK
RUN flutter build apk --release

# Stage 2: Android Build Environment (for AAB)
FROM cirrusci/flutter:3.24.0 AS android-builder

WORKDIR /app

# Copy from previous stage
COPY --from=flutter-builder /app .

# Build App Bundle
RUN flutter build appbundle --release

# Stage 3: Final image with build artifacts
FROM alpine:latest AS final

# Install basic tools
RUN apk add --no-cache curl jq

# Create app directory
WORKDIR /artifacts

# Copy build artifacts
COPY --from=flutter-builder /app/build/app/outputs/flutter-apk/app-release.apk ./
COPY --from=android-builder /app/build/app/outputs/bundle/release/app-release.aab ./

# Create build info
RUN echo '{"build_date":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'","artifacts":["app-release.apk","app-release.aab"]}' > build-info.json

# Default command
CMD ["ls", "-la"]