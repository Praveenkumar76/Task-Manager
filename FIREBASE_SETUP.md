# Firebase Authentication Setup Guide

## Overview

This guide will help you set up real Firebase Authentication for your Task Manager app. Follow these steps to enable email/password and social media authentication.

## Prerequisites

- Google Account
- Flutter development environment
- Task Manager app code

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `task-manager` (or your preferred name)
4. Enable Google Analytics (optional)
5. Choose or create Analytics account
6. Click "Create project"

## Step 2: Enable Authentication

1. In your Firebase project, go to **Authentication** > **Sign-in method**
2. Enable the following providers:

### Email/Password
- Click on "Email/Password"
- Enable "Email/Password"
- Click "Save"

### Google Sign-In
- Click on "Google"
- Enable Google Sign-In
- Add your project support email
- Click "Save"

### Facebook Login (Optional)
- Click on "Facebook"
- Enable Facebook Login
- Add your Facebook App ID and App Secret
- Click "Save"

### Twitter Login (Optional)
- Click on "Twitter"
- Enable Twitter Login
- Add your Twitter API Key and API Secret
- Click "Save"

### GitHub Login (Optional)
- Click on "GitHub"
- Enable GitHub Login
- Add your GitHub Client ID and Client Secret
- Click "Save"

## Step 3: Configure Web App

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to "Your apps" section
3. Click "Add app" > Web icon `</>`
4. Enter app nickname: "Task Manager Web"
5. Check "Set up Firebase Hosting" (optional)
6. Click "Register app"

## Step 4: Get Configuration Keys

After registering your web app, you'll see a configuration object like this:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890"
};
```

## Step 5: Update Flutter App Configuration

### Update main.dart

Replace the placeholder values in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: FirebaseOptions(
    apiKey: "YOUR_API_KEY_HERE",
    authDomain: "your-project-id.firebaseapp.com",
    projectId: "your-project-id",
    storageBucket: "your-project-id.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID",
  ),
);
```

### Update web/index.html

Replace the Firebase configuration in `web/index.html`:

```javascript
const firebaseConfig = {
  apiKey: "YOUR_API_KEY_HERE",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};
```

## Step 6: Configure Authorized Domains

1. In Firebase Console, go to **Authentication** > **Settings** > **Authorized domains**
2. Add your domains:
   - `localhost` (for development)
   - Your production domain (e.g., `yourdomain.com`)

## Step 7: Social Provider Setup (Optional)

### Google Sign-In Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Enable "Google+ API"
4. Go to "Credentials" > "OAuth 2.0 Client IDs"
5. Add authorized JavaScript origins:
   - `http://localhost:3000` (for development)
   - Your production domain

### Facebook Login Setup
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app or use existing
3. Add "Facebook Login" product
4. In Settings > Basic, add your domain
5. Copy App ID and App Secret to Firebase

### Twitter Login Setup
1. Go to [Twitter Developer Portal](https://developer.twitter.com/)
2. Create a new project and app
3. Generate API Key and Secret
4. Add callback URL: `https://your-project-id.firebaseapp.com/__/auth/handler`
5. Copy credentials to Firebase

### GitHub Login Setup
1. Go to GitHub Settings > Developer settings > OAuth Apps
2. Create a new OAuth App
3. Set Authorization callback URL: `https://your-project-id.firebaseapp.com/__/auth/handler`
4. Copy Client ID and Client Secret to Firebase

## Step 8: Test Your Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run -d chrome
   ```

3. Test authentication methods:
   - Create a new account with email/password
   - Sign in with existing account
   - Try social login buttons
   - Test password reset functionality

## Step 9: Security Rules (Optional)

For production apps, consider setting up Firebase Security Rules for additional protection.

## Troubleshooting

### Common Issues:

1. **Firebase not initialized**
   - Ensure Firebase.initializeApp() is called before runApp()

2. **Invalid API Key**
   - Double-check your Firebase configuration values

3. **CORS issues**
   - Add your domain to authorized domains in Firebase Console

4. **Social login not working**
   - Verify OAuth configuration in respective platforms
   - Check authorized domains and callback URLs

### Debug Mode

Enable debug mode to see detailed error messages:

```dart
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  print('Auth error: $error');
}
```

## Production Considerations

1. **Environment Variables**: Store sensitive keys in environment variables
2. **Security Rules**: Implement proper Firestore security rules
3. **Rate Limiting**: Configure authentication rate limiting
4. **Monitoring**: Set up Firebase Performance and Crashlytics

## Support

For additional help:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Community](https://firebase.google.com/community)

---

**Happy Authenticating! 🔐** 