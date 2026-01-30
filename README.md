# Glasscast - AI-Powered Weather App

A beautiful glassmorphism weather app built with Flutter, featuring AI-powered weather insights and a modern glass-effect UI design.

## 🌟 Features

### Core Features
- **Authentication**: Email/password authentication via Supabase
- **Current Weather**: Real-time weather data for selected cities
- **5-Day Forecast**: Extended weather forecasts with detailed information
- **City Search**: Search and save favorite cities
- **Settings**: Temperature unit toggle (°C/°F), notifications, and account management
- **AI Insights**: Personalized weather recommendations and insights

### UI/UX Features
- **Glassmorphism Design**: Modern glass-effect UI with blur and transparency
- **Smooth Animations**: Fluid transitions and interactions
- **Dark Theme**: Optimized for low-light usage
- **Responsive Design**: Works across different screen sizes
- **Pull-to-Refresh**: Easy weather data updates

## 🛠 Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod 2.5.1
- **Backend**: Supabase (Authentication + Database)
- **Weather API**: OpenWeatherMap API
- **Navigation**: GetX 4.7.3
- **UI Effects**: Custom glassmorphism implementation
- **Storage**: Flutter Secure Storage

## 📱 Screenshots

The app features four main screens matching the Glasscast design:

1. **Sign In Screen**: Clean authentication with glassmorphism effects
2. **Current Weather Dashboard**: Main weather display with AI insights
3. **City Search and Favorites**: Search cities and manage favorites
4. **App Settings**: User preferences and account management

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code
- OpenWeatherMap API key
- Supabase account

### Quick Setup with Make

```bash
# Initial project setup
make setup

# Run tests
make test

# Build debug version
make build-debug

# Deploy to development
make deploy-dev
```

### Manual Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/glasscast.git
   cd glasscast
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Setup**
   
   Create a `.env` file in the root directory:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   WEATHER_API_KEY=your_openweathermap_api_key
   ```

4. **Supabase Setup**
   
   Create a Supabase project and set up the following table:
   
   ```sql
   -- Create favorite_cities table
   CREATE TABLE favorite_cities (
     id SERIAL PRIMARY KEY,
     user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
     city_name TEXT NOT NULL,
     lat DOUBLE PRECISION NOT NULL,
     lon DOUBLE PRECISION NOT NULL,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- Enable Row Level Security
   ALTER TABLE favorite_cities ENABLE ROW LEVEL SECURITY;

   -- Create policy for users to only access their own cities
   CREATE POLICY "Users can only access their own cities" ON favorite_cities
     FOR ALL USING (auth.uid() = user_id);
   ```

5. **API Keys Setup**
   
   - **OpenWeatherMap**: Get your free API key from [OpenWeatherMap](https://openweathermap.org/api)
   - **Supabase**: Get your project URL and anon key from your Supabase dashboard

6. **Run the app**
   ```bash
   flutter run
   ```

## 🔄 CI/CD Pipeline

This project includes a comprehensive CI/CD pipeline with GitHub Actions for automated testing, building, and deployment.

### Pipeline Features

- ✅ **Continuous Integration**: Automated testing and code quality checks
- ✅ **Multi-platform Builds**: Android APK/AAB and iOS builds
- ✅ **Security Scanning**: Vulnerability detection and dependency audits
- ✅ **Automated Deployment**: Development and production deployments
- ✅ **Code Quality**: Formatting, linting, and coverage reporting
- ✅ **Dependency Management**: Automated updates and security monitoring

### Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| **Main CI/CD** | Push to main/develop, PRs, Releases | Full pipeline with testing, building, and deployment |
| **Code Quality** | Push, PRs | Static analysis, coverage, and quality metrics |
| **Matrix Testing** | Push, PRs, Weekly | Cross-platform compatibility testing |
| **Dependency Updates** | Weekly, Manual | Automated dependency updates and security audits |

### Deployment Environments

- **Development**: Auto-deploy on `develop` branch → Firebase App Distribution
- **Staging**: Manual deployment → Internal testing tracks
- **Production**: Auto-deploy on release → App Store & Google Play Store

### Available Commands

```bash
# Development
make setup          # Initial project setup
make test           # Run all tests
make build-debug    # Build debug APK
make build-release  # Build release APK and AAB

# Code Quality
make format         # Format Dart code
make analyze        # Run static analysis
make ci-test        # Run full CI test suite locally

# Deployment
make deploy-dev     # Deploy to development environment
make deploy-prod    # Deploy to production

# Docker
make docker-build   # Build with Docker
make docker-test    # Run tests in Docker
```

For detailed CI/CD documentation, see [docs/CICD.md](docs/CICD.md).

## 🏗 Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── config/
│   │   └── env.dart                   # Environment configuration
│   ├── constants/
│   │   └── api_constants.dart         # API endpoints
│   ├── network/
│   │   └── dio_client.dart           # HTTP client setup
│   └── services/
│       ├── auth_service.dart         # Authentication service
│       └── session_service.dart      # Session management
├── data/
│   ├── models/
│   │   ├── city_model.dart           # City data model
│   │   └── weather_model.dart        # Weather data model
│   └── repositories/
│       ├── auth_repository.dart      # Auth data layer
│       ├── city_repository.dart      # City data layer
│       ├── city_search_repository.dart # City search
│       └── weather_repository.dart   # Weather data layer
├── presentations/
│   ├── auth/
│   │   ├── login_screen.dart         # Login UI
│   │   └── signup_screen.dart        # Signup UI
│   ├── home/
│   │   └── home_screen.dart          # Main weather dashboard
│   ├── search/
│   │   └── city_search_screen.dart   # City search UI
│   ├── settings/
│   │   └── settings_screen.dart      # Settings UI
│   ├── weather_detail/
│   │   └── weather_detail_screen.dart # Detailed weather
│   └── widget/
│       ├── glass_container.dart      # Glassmorphism widget
│       └── faviourate_card.dart     # City card widget
├── viewmodels/                       # Riverpod state management
├── routes/                           # Navigation setup
├── database/                         # Local storage
└── utils/                           # Helper functions
```

## 🎨 Design System

### Glassmorphism Implementation

The app uses a custom `GlassContainer` widget that provides:
- **Backdrop blur**: 15px blur effect
- **Semi-transparent background**: White with 15% opacity
- **Border**: White with 20% opacity
- **Rounded corners**: 16px border radius

### Color Palette

- **Primary**: `#3B82F6` (Blue)
- **Background**: `#0F172A` (Dark Navy)
- **Surface**: `#1E293B` (Slate)
- **Text**: White with varying opacity (100%, 70%, 50%)
- **Success**: `#10B981` (Green)
- **Error**: `#EF4444` (Red)

### Typography

- **Font Family**: Roboto
- **Heading**: 32px, Bold
- **Subheading**: 20px, Semi-bold
- **Body**: 16px, Regular
- **Caption**: 14px, Medium

## 🔧 Configuration

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `SUPABASE_URL` | Your Supabase project URL | Yes |
| `SUPABASE_ANON_KEY` | Your Supabase anonymous key | Yes |
| `WEATHER_API_KEY` | OpenWeatherMap API key | Yes |

### Supabase Configuration

1. Create a new Supabase project
2. Enable email authentication
3. Create the `favorite_cities` table (see SQL above)
4. Set up Row Level Security policies
5. Get your project URL and anon key

### Weather API Configuration

1. Sign up at [OpenWeatherMap](https://openweathermap.org/api)
2. Get your free API key
3. Add it to your `.env` file

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📦 Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for weather data
- [Supabase](https://supabase.com/) for backend services
- [Flutter](https://flutter.dev/) for the amazing framework
- Design inspiration from modern glassmorphism trends

## 📞 Support

For support, email support@glasscast.app or create an issue in this repository.

---

**Built with ❤️ using Flutter and AI-assisted development**