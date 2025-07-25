# Task Manager - Flutter App with Authentication

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A modern, feature-rich task management application built with Flutter. Manage your daily tasks with a beautiful UI, user authentication, and cross-platform compatibility.

## ✨ Features

### 🔐 **Authentication System**
- **Email/Password Authentication** - Secure login and registration
- **Social Media Login** - Google, Facebook, Twitter, and GitHub integration
- **User Profiles** - Personalized avatars and user information
- **Session Management** - Persistent login across app restarts
- **Password Reset** - Forgot password functionality

### 📝 **Task Management**
- **Add Tasks** - Create tasks with titles, dates, and priority levels
- **Task Completion** - Mark tasks as completed with confirmation dialogs
- **Task History** - View and manage completed tasks
- **Task Editing** - Update existing tasks
- **User-Specific Storage** - Each user's tasks are stored separately
- **Priority Levels** - Organize tasks by importance

### 🎨 **Modern UI/UX**
- **Beautiful Design** - Clean, modern interface
- **Smooth Animations** - Engaging user experience
- **Responsive Layout** - Works perfectly on all screen sizes
- **Dark/Light Themes** - Adaptive color schemes
- **Toast Notifications** - Instant feedback for user actions

### 🌐 **Cross-Platform**
- **Android** - Native Android experience
- **iOS** - Native iOS experience  
- **Web** - Progressive Web App support
- **Desktop** - Windows, macOS, Linux support

## 📱 Screenshots

### Authentication Screens
- Modern login screen with social media options
- Registration form with validation
- User profile management

### Task Management
- Clean task list with completion status
- Task creation with date picker and priority selection
- History view with restore and delete options

## 🚀 Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) 3.0 or higher
- [Dart](https://dart.dev/get-dart) 3.0 or higher
- Android Studio or VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/praveenkumar76/Task-Manager.git
   cd Task-Manager/todo-list
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android/iOS
   flutter run
   
   # For Web
   flutter run -d chrome
   
   # For Desktop
   flutter run -d windows  # or macos/linux
   ```

## 🔑 Demo Accounts

For quick testing, use these pre-configured accounts:

**Account 1:**
- Email: `demo@example.com`
- Password: `password123`

**Account 2:**
- Email: `test@example.com`
- Password: `test123`

Alternatively, click any social media button for instant login with mock accounts.

## 📁 Project Structure

```
todo-list/
├── lib/
│   ├── helpers/
│   │   └── database_helper.dart      # Task storage and user-specific data
│   ├── models/
│   │   └── task_model.dart           # Task data model
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart     # Login with social options
│   │   │   └── register_screen.dart  # User registration
│   │   ├── add_task_screen.dart      # Task creation/editing
│   │   ├── history_screen.dart       # Completed tasks management
│   │   ├── home_screen.dart          # Main dashboard
│   │   ├── settings_screen.dart      # App settings
│   │   └── splash_screen.dart        # App initialization
│   ├── services/
│   │   └── auth_service.dart         # Authentication service
│   └── main.dart                     # App entry point
├── android/                          # Android-specific code
├── ios/                             # iOS-specific code
├── web/                             # Web-specific code
├── windows/                         # Windows-specific code
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

## 🛠️ Technologies Used

### Flutter Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.0
  fluttertoast: ^8.0.0          # User notifications
  intl: ^0.20.2                 # Date formatting
  shared_preferences: ^2.2.2    # Local storage
  url_launcher: ^6.0.2          # External links
  crypto: ^3.0.3                # Password hashing
  uuid: ^4.0.0                  # Unique ID generation
  font_awesome_flutter: ^10.6.0  # Social media icons
  animate_do: ^3.1.2            # Smooth animations
```

### Key Features Implementation
- **Local Storage**: SharedPreferences for cross-platform data persistence
- **Authentication**: Custom mock service with real-world simulation
- **State Management**: StatefulWidget with proper lifecycle management
- **Navigation**: MaterialPageRoute for smooth transitions
- **Responsive Design**: MediaQuery for adaptive layouts

## 🔧 Configuration

### Authentication Setup
The app uses a mock authentication system that doesn't require external API keys. For production use:

1. **Firebase Integration** (Optional)
   - Set up Firebase project
   - Configure authentication providers
   - Update authentication service

2. **Social Media Setup** (Optional)
   - Google: Configure OAuth 2.0
   - Facebook: Set up Facebook App
   - Twitter: Register Twitter API
   - GitHub: Configure GitHub OAuth

### Database Configuration
- Uses SharedPreferences for local storage
- Tasks are stored per user with unique keys
- Automatic data persistence across sessions

## 📋 Usage Guide

### First Time Setup
1. Launch the app
2. Choose to login with demo account or create new account
3. Start adding tasks immediately

### Adding Tasks
1. Tap the "+" floating action button
2. Enter task title and select date
3. Choose priority level (Low, Medium, High)
4. Save the task

### Managing Tasks
- **Complete**: Tap checkbox and confirm
- **Edit**: Tap on task to modify
- **View History**: Use history icon in app bar
- **Restore**: Use restore button in history
- **Delete**: Permanently remove from history

### User Management
- **Profile**: Tap avatar in top-right corner
- **Logout**: Select logout from profile menu
- **Switch Users**: Logout and login with different account

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Run widget tests
flutter test test/widget_test.dart
```

## 🏗️ Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Desktop
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Praveen Kumar**
- GitHub: [@praveenkumar76](https://github.com/praveenkumar76)
- Project: [Task-Manager](https://github.com/praveenkumar76/Task-Manager)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Font Awesome for beautiful icons
- Animate.css for smooth animations
- Flutter community for inspiration and support

## 📞 Support

If you have any questions or need help getting started:

1. Check the [Issues](https://github.com/praveenkumar76/Task-Manager/issues) section
2. Create a new issue with detailed description
3. Star the repository if you find it helpful!

---

**Made with ❤️ using Flutter**

---

## 🔄 Changelog

### Version 3.0.0
- ✅ Added complete authentication system
- ✅ Social media login integration
- ✅ User-specific task storage
- ✅ Improved UI/UX with animations
- ✅ Web platform support
- ✅ Enhanced task management features

### Version 2.0.0
- ✅ Task completion functionality
- ✅ History management
- ✅ Settings screen
- ✅ Improved database operations

### Version 1.0.0
- ✅ Basic task management
- ✅ Add, edit, delete tasks
- ✅ Priority levels
- ✅ Cross-platform support
