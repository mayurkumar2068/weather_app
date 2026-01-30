#!/bin/bash

# Glasscast Deployment Script
# Usage: ./scripts/deploy.sh [environment] [platform]
# Example: ./scripts/deploy.sh staging android

set -e

ENVIRONMENT=${1:-development}
PLATFORM=${2:-both}

echo "🚀 Starting deployment for Glasscast Weather App"
echo "Environment: $ENVIRONMENT"
echo "Platform: $PLATFORM"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter found: $(flutter --version | head -n 1)"

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the project root."
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    print_warning ".env file not found. Creating template..."
    cat > .env << EOF
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here
EOF
    print_warning "Please update .env file with your actual Supabase credentials"
fi

# Clean and get dependencies
print_status "Cleaning project..."
flutter clean

print_status "Getting dependencies..."
flutter pub get

# Generate app icons
print_status "Generating app icons..."
flutter pub run flutter_launcher_icons:main

# Run code analysis
print_status "Running code analysis..."
if ! flutter analyze --fatal-infos; then
    print_error "Code analysis failed. Please fix the issues before deploying."
    exit 1
fi

# Run tests
print_status "Running tests..."
if ! flutter test; then
    print_error "Tests failed. Please fix the failing tests before deploying."
    exit 1
fi

# Build based on environment and platform
case $ENVIRONMENT in
    "development"|"dev")
        BUILD_MODE="debug"
        ;;
    "staging"|"stage")
        BUILD_MODE="profile"
        ;;
    "production"|"prod")
        BUILD_MODE="release"
        ;;
    *)
        print_error "Unknown environment: $ENVIRONMENT"
        print_error "Supported environments: development, staging, production"
        exit 1
        ;;
esac

# Android build
if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "both" ]; then
    print_status "Building Android ($BUILD_MODE)..."
    
    case $BUILD_MODE in
        "debug")
            flutter build apk --debug
            print_status "Android APK (debug) built successfully"
            echo "Location: build/app/outputs/flutter-apk/app-debug.apk"
            ;;
        "profile")
            flutter build apk --profile
            print_status "Android APK (profile) built successfully"
            echo "Location: build/app/outputs/flutter-apk/app-profile.apk"
            ;;
        "release")
            flutter build apk --release
            flutter build appbundle --release
            print_status "Android APK and App Bundle (release) built successfully"
            echo "APK Location: build/app/outputs/flutter-apk/app-release.apk"
            echo "AAB Location: build/app/outputs/bundle/release/app-release.aab"
            ;;
    esac
fi

# iOS build
if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "both" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_status "Building iOS ($BUILD_MODE)..."
        
        # Install CocoaPods dependencies
        cd ios
        pod install
        cd ..
        
        case $BUILD_MODE in
            "debug")
                flutter build ios --debug --no-codesign
                ;;
            "profile")
                flutter build ios --profile --no-codesign
                ;;
            "release")
                flutter build ios --release --no-codesign
                ;;
        esac
        
        print_status "iOS build ($BUILD_MODE) completed successfully"
        echo "Location: build/ios/iphoneos/"
    else
        print_warning "iOS build skipped (not running on macOS)"
    fi
fi

# Generate build info
BUILD_INFO_FILE="build_info.json"
cat > $BUILD_INFO_FILE << EOF
{
  "app_name": "Glasscast",
  "version": "1.0.0",
  "build_number": "$(date +%Y%m%d%H%M%S)",
  "environment": "$ENVIRONMENT",
  "platform": "$PLATFORM",
  "build_mode": "$BUILD_MODE",
  "build_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "git_commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
  "git_branch": "$(git branch --show-current 2>/dev/null || echo 'unknown')"
}
EOF

print_status "Build information saved to $BUILD_INFO_FILE"

# Deployment instructions
echo ""
echo "🎉 Build completed successfully!"
echo ""
echo "Next steps for $ENVIRONMENT deployment:"

case $ENVIRONMENT in
    "development")
        echo "• Upload APK to Firebase App Distribution for testing"
        echo "• Share with internal testers"
        ;;
    "staging")
        echo "• Upload to internal testing tracks (Play Console Internal Testing / TestFlight)"
        echo "• Perform UAT testing"
        ;;
    "production")
        echo "• Upload AAB to Google Play Console for production release"
        echo "• Upload IPA to App Store Connect for production release"
        echo "• Create release notes and changelog"
        ;;
esac

echo ""
print_status "Deployment script completed!"