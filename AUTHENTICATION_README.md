# Task Manager - Authentication System

## Overview

This Task Manager app now includes a complete authentication system with social media login options. The authentication is implemented using a mock service that simulates real authentication without requiring external services.

## Features

### 🔐 Authentication Methods
- **Email/Password Login**: Traditional email and password authentication
- **Social Media Login**: Mock implementations for:
  - Google Sign-In
  - Facebook Login
  - Twitter Login
  - GitHub Login

### 🎨 Beautiful UI
- Modern, animated login and registration screens
- Smooth transitions and fade-in animations
- User-friendly form validation
- Social media login buttons with brand colors

### 👤 User Management
- User profile display with avatar
- Secure logout functionality
- Password reset (mock implementation)
- User-specific task storage

### 🗄️ Data Storage
- **User-Specific Tasks**: Each user's tasks are stored separately
- **Persistent Sessions**: Users stay logged in across app restarts
- **Local Storage**: Uses SharedPreferences for web compatibility

## How to Use

### Demo Accounts
For email/password login, use these pre-configured accounts:

**Account 1:**
- Email: `demo@example.com`
- Password: `password123`

**Account 2:**
- Email: `test@example.com`
- Password: `test123`

### Social Login
Click any of the social media buttons to instantly log in with a mock account. Each social provider creates a unique user profile.

### Creating New Accounts
1. Click "Sign Up" on the login screen
2. Fill in your details (name, email, password)
3. Confirm your password
4. Click "Create Account"

### App Navigation
Once logged in:
- **Add Tasks**: Use the floating action button
- **View History**: Click the history icon
- **Settings**: Access via the settings icon
- **Profile**: Click your avatar in the top-right
- **Logout**: Select "Logout" from the profile menu

## Technical Implementation

### Architecture
```
lib/
├── services/
│   └── auth_service.dart          # Mock authentication service
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart      # Login UI with social buttons
│   │   └── register_screen.dart   # Registration form
│   └── home_screen.dart           # Main app with user menu
├── helpers/
│   └── database_helper.dart       # User-specific task storage
└── models/
    └── task_model.dart            # Task data model
```

### Key Features
- **Mock Authentication**: No external dependencies required
- **User Sessions**: Persistent login state
- **Data Isolation**: Each user's tasks are completely separate
- **Web Compatible**: Works perfectly in Flutter Web
- **Beautiful Animations**: Professional UI/UX design

### Dependencies
```yaml
dependencies:
  shared_preferences: ^2.2.2      # Local data storage
  font_awesome_flutter: ^10.6.0   # Social media icons
  animate_do: ^3.1.2              # Smooth animations
  fluttertoast: ^8.0.0            # User feedback
```

## Security Features

### Mock Implementation Benefits
- **No API Keys Required**: Works without external services
- **Instant Setup**: No configuration needed
- **Demo Ready**: Perfect for showcasing functionality
- **Privacy Friendly**: No data sent to external servers

### User Data Protection
- Tasks are isolated per user
- Session data is stored locally
- No sensitive information transmitted

## Future Enhancements

To upgrade to real authentication:

1. **Firebase Integration**:
   ```yaml
   firebase_core: ^latest
   firebase_auth: ^latest
   ```

2. **Social Provider Setup**:
   - Configure Google Sign-In
   - Set up Facebook Developer App
   - Register Twitter API credentials
   - Configure GitHub OAuth App

3. **Backend Integration**:
   - Replace mock service with real API calls
   - Implement server-side user management
   - Add cloud data synchronization

## Usage Examples

### Email Login
```dart
await AuthService().signInWithEmailPassword(
  'demo@example.com', 
  'password123'
);
```

### Social Login
```dart
await AuthService().signInWithGoogle();
await AuthService().signInWithFacebook();
await AuthService().signInWithTwitter();
await AuthService().signInWithGitHub();
```

### Get Current User
```dart
final user = AuthService().currentUser;
print('User: ${user?.displayName} (${user?.email})');
```

### Logout
```dart
await AuthService().signOut();
```

## Demo Instructions

1. **First Run**: App opens to login screen
2. **Quick Login**: Use `demo@example.com` / `password123`
3. **Try Social**: Click any social media button
4. **Add Tasks**: Create tasks (they're saved per user)
5. **Switch Users**: Logout and login as different user
6. **View Isolation**: Notice tasks are user-specific

## Support

This authentication system is designed for demonstration and development purposes. For production use, implement proper security measures and use established authentication providers.

---

**Happy Task Managing! 🚀** 