# Glasscast Weather App - Development Makefile

.PHONY: help setup clean test build deploy docker-build docker-test

# Default target
help:
	@echo "Glasscast Weather App - Available Commands:"
	@echo ""
	@echo "Setup & Dependencies:"
	@echo "  setup          - Initial project setup"
	@echo "  clean          - Clean build artifacts"
	@echo "  deps           - Get Flutter dependencies"
	@echo ""
	@echo "Development:"
	@echo "  format         - Format Dart code"
	@echo "  analyze        - Run static analysis"
	@echo "  test           - Run all tests"
	@echo "  test-coverage  - Run tests with coverage"
	@echo ""
	@echo "Building:"
	@echo "  build-debug    - Build debug APK"
	@echo "  build-release  - Build release APK and AAB"
	@echo "  build-ios      - Build iOS (macOS only)"
	@echo "  icons          - Generate app icons"
	@echo ""
	@echo "Deployment:"
	@echo "  deploy-dev     - Deploy to development"
	@echo "  deploy-prod    - Deploy to production"
	@echo ""
	@echo "Docker:"
	@echo "  docker-build   - Build with Docker"
	@echo "  docker-test    - Run tests in Docker"
	@echo ""
	@echo "CI/CD:"
	@echo "  ci-test        - Run CI test suite locally"
	@echo "  security-scan  - Run security analysis"

# Setup and Dependencies
setup:
	@echo "🚀 Setting up Glasscast Weather App..."
	flutter doctor
	flutter pub get
	@if [ ! -f ".env" ]; then \
		echo "📝 Creating .env template..."; \
		echo "SUPABASE_URL=your_supabase_url_here" > .env; \
		echo "SUPABASE_ANON_KEY=your_supabase_anon_key_here" >> .env; \
		echo "⚠️  Please update .env with your actual credentials"; \
	fi
	@echo "✅ Setup complete!"

clean:
	@echo "🧹 Cleaning project..."
	flutter clean
	rm -rf build/
	rm -rf .dart_tool/
	@echo "✅ Clean complete!"

deps:
	@echo "📦 Getting dependencies..."
	flutter pub get
	@echo "✅ Dependencies updated!"

# Development
format:
	@echo "🎨 Formatting code..."
	dart format .
	@echo "✅ Code formatted!"

analyze:
	@echo "🔍 Running static analysis..."
	flutter analyze --fatal-infos
	@echo "✅ Analysis complete!"

test:
	@echo "🧪 Running tests..."
	flutter test
	@echo "✅ Tests complete!"

test-coverage:
	@echo "🧪 Running tests with coverage..."
	flutter test --coverage
	@echo "📊 Coverage report generated in coverage/"
	@echo "✅ Tests with coverage complete!"

# Building
icons:
	@echo "🎨 Generating app icons..."
	flutter pub run flutter_launcher_icons:main
	@echo "✅ App icons generated!"

build-debug: clean deps icons
	@echo "🔨 Building debug APK..."
	flutter build apk --debug
	@echo "✅ Debug APK built: build/app/outputs/flutter-apk/app-debug.apk"

build-release: clean deps icons analyze test
	@echo "🔨 Building release APK and AAB..."
	flutter build apk --release
	flutter build appbundle --release
	@echo "✅ Release builds complete:"
	@echo "   APK: build/app/outputs/flutter-apk/app-release.apk"
	@echo "   AAB: build/app/outputs/bundle/release/app-release.aab"

build-ios: clean deps icons
	@echo "🔨 Building iOS..."
	@if [ "$(shell uname)" = "Darwin" ]; then \
		cd ios && pod install && cd ..; \
		flutter build ios --release --no-codesign; \
		echo "✅ iOS build complete: build/ios/iphoneos/"; \
	else \
		echo "❌ iOS build requires macOS"; \
		exit 1; \
	fi

# Deployment
deploy-dev:
	@echo "🚀 Deploying to development..."
	./scripts/deploy.sh development android
	@echo "✅ Development deployment complete!"

deploy-prod:
	@echo "🚀 Deploying to production..."
	./scripts/deploy.sh production both
	@echo "✅ Production deployment complete!"

# Docker
docker-build:
	@echo "🐳 Building with Docker..."
	docker-compose up --build flutter-build
	@echo "✅ Docker build complete!"

docker-test:
	@echo "🐳 Running tests in Docker..."
	docker run --rm -v $(PWD):/app -w /app cirrusci/flutter:3.24.0 \
		sh -c "flutter pub get && flutter test"
	@echo "✅ Docker tests complete!"

# CI/CD
ci-test: format analyze test
	@echo "🤖 Running CI test suite locally..."
	@echo "✅ All CI checks passed!"

security-scan:
	@echo "🔒 Running security scan..."
	@if command -v trivy >/dev/null 2>&1; then \
		trivy fs .; \
	else \
		echo "⚠️  Trivy not installed. Install with: brew install trivy"; \
	fi
	@echo "✅ Security scan complete!"

# Utility targets
check-flutter:
	@if ! command -v flutter >/dev/null 2>&1; then \
		echo "❌ Flutter not found. Please install Flutter SDK"; \
		exit 1; \
	fi

check-env:
	@if [ ! -f ".env" ]; then \
		echo "❌ .env file not found. Run 'make setup' first"; \
		exit 1; \
	fi

# Development server (for web)
serve:
	@echo "🌐 Starting development server..."
	flutter run -d web-server --web-port 8080

# Update dependencies
update-deps:
	@echo "📦 Updating dependencies..."
	flutter pub upgrade --major-versions
	flutter pub get
	@echo "✅ Dependencies updated!"

# Git hooks setup
setup-hooks:
	@echo "🪝 Setting up Git hooks..."
	@if [ -d ".git" ]; then \
		echo "#!/bin/sh" > .git/hooks/pre-commit; \
		echo "make format analyze test" >> .git/hooks/pre-commit; \
		chmod +x .git/hooks/pre-commit; \
		echo "✅ Pre-commit hook installed!"; \
	else \
		echo "❌ Not a Git repository"; \
	fi