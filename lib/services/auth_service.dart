import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime createdAt;
  final bool emailVerified;

  User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.createdAt,
    this.emailVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt.toIso8601String(),
      'emailVerified': emailVerified,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      createdAt: DateTime.parse(json['createdAt']),
      emailVerified: json['emailVerified'] ?? false,
    );
  }
}

class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => message;
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _userKey = 'current_user';
  static const String _usersKey = 'all_users';
  User? _currentUser;
  final Uuid _uuid = Uuid();

  // Get current user
  User? get currentUser => _currentUser;

  // Initialize and load user from storage
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      final userData = json.decode(userJson);
      _currentUser = User.fromJson(userData);
    }
  }

  // Hash password for secure storage
  String _hashPassword(String password) {
    var bytes = utf8.encode(password + 'salt_key_secure');
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Get all users from storage
  Future<List<Map<String, dynamic>>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    return usersJson.map((userStr) => json.decode(userStr) as Map<String, dynamic>).toList();
  }

  // Save user to storage
  Future<void> _saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getAllUsers();
    
    // Update existing user or add new one
    final existingIndex = users.indexWhere((u) => u['email'] == userData['email']);
    if (existingIndex != -1) {
      users[existingIndex] = userData;
    } else {
      users.add(userData);
    }
    
    final usersJson = users.map((user) => json.encode(user)).toList();
    await prefs.setStringList(_usersKey, usersJson);
  }

  // Sign in with email and password
  Future<User> signInWithEmailPassword(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
    
    final users = await _getAllUsers();
    final hashedPassword = _hashPassword(password);
    
    final user = users.firstWhere(
      (user) => user['email'] == email && user['hashedPassword'] == hashedPassword,
      orElse: () => {},
    );

    if (user.isEmpty) {
      throw AuthException('invalid-credential', 'Invalid email or password.');
    }

    _currentUser = User.fromJson(user);
    await _saveCurrentUser();
    return _currentUser!;
  }

  // Register with email and password
  Future<User> registerWithEmailPassword(String email, String password, String displayName) async {
    await Future.delayed(Duration(milliseconds: 800)); // Simulate network delay
    
    final users = await _getAllUsers();
    
    // Check if user already exists
    final existingUser = users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );

    if (existingUser.isNotEmpty) {
      throw AuthException('email-already-in-use', 'An account already exists with this email address.');
    }

    // Validate password strength
    if (password.length < 6) {
      throw AuthException('weak-password', 'Password should be at least 6 characters.');
    }

    // Create new user
    final userId = _uuid.v4();
    final now = DateTime.now();
    
    final userData = {
      'uid': userId,
      'email': email,
      'displayName': displayName,
      'photoURL': null,
      'createdAt': now.toIso8601String(),
      'emailVerified': false,
      'hashedPassword': _hashPassword(password),
    };

    await _saveUser(userData);
    _currentUser = User.fromJson(userData);
    await _saveCurrentUser();
    return _currentUser!;
  }

  // Social sign-ins (mock implementations)
  Future<User> signInWithGoogle() async {
    await Future.delayed(Duration(milliseconds: 1000));
    
    final userId = _uuid.v4();
    final email = 'user.google@gmail.com';
    final now = DateTime.now();
    
    final userData = {
      'uid': userId,
      'email': email,
      'displayName': 'Google User',
      'photoURL': 'https://lh3.googleusercontent.com/a/default-user=s96-c',
      'createdAt': now.toIso8601String(),
      'emailVerified': true,
      'provider': 'google',
    };

    await _saveUser(userData);
    _currentUser = User.fromJson(userData);
    await _saveCurrentUser();
    return _currentUser!;
  }

  Future<User> signInWithFacebook() async {
    await Future.delayed(Duration(milliseconds: 1000));
    
    final userId = _uuid.v4();
    final email = 'user.facebook@example.com';
    final now = DateTime.now();
    
    final userData = {
      'uid': userId,
      'email': email,
      'displayName': 'Facebook User',
      'photoURL': 'https://via.placeholder.com/150?text=FB',
      'createdAt': now.toIso8601String(),
      'emailVerified': true,
      'provider': 'facebook',
    };

    await _saveUser(userData);
    _currentUser = User.fromJson(userData);
    await _saveCurrentUser();
    return _currentUser!;
  }

  Future<User> signInWithTwitter() async {
    await Future.delayed(Duration(milliseconds: 1000));
    
    final userId = _uuid.v4();
    final email = 'user.twitter@example.com';
    final now = DateTime.now();
    
    final userData = {
      'uid': userId,
      'email': email,
      'displayName': 'Twitter User',
      'photoURL': 'https://via.placeholder.com/150?text=TW',
      'createdAt': now.toIso8601String(),
      'emailVerified': true,
      'provider': 'twitter',
    };

    await _saveUser(userData);
    _currentUser = User.fromJson(userData);
    await _saveCurrentUser();
    return _currentUser!;
  }

  Future<User> signInWithGitHub() async {
    await Future.delayed(Duration(milliseconds: 1000));
    
    final userId = _uuid.v4();
    final email = 'user.github@example.com';
    final now = DateTime.now();
    
    final userData = {
      'uid': userId,
      'email': email,
      'displayName': 'GitHub User',
      'photoURL': 'https://via.placeholder.com/150?text=GH',
      'createdAt': now.toIso8601String(),
      'emailVerified': true,
      'provider': 'github',
    };

    await _saveUser(userData);
    _currentUser = User.fromJson(userData);
    await _saveCurrentUser();
    return _currentUser!;
  }

  // Send password reset email (mock)
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final users = await _getAllUsers();
    final user = users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );

    if (user.isEmpty) {
      throw AuthException('user-not-found', 'No user found with this email address.');
    }

    // In a real app, this would send an actual email
    if (kDebugMode) {
      print('Password reset email sent to $email');
    }
  }

  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Delete account
  Future<void> deleteAccount() async {
    if (_currentUser != null) {
      final users = await _getAllUsers();
      users.removeWhere((user) => user['uid'] == _currentUser!.uid);
      
      final prefs = await SharedPreferences.getInstance();
      final usersJson = users.map((user) => json.encode(user)).toList();
      await prefs.setStringList(_usersKey, usersJson);
      
      await signOut();
    }
  }

  // Save current user to local storage
  Future<void> _saveCurrentUser() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(_currentUser!.toJson()));
    }
  }

  // Get user-friendly error message
  String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }
    
    String message = error.toString();
    if (message.contains('invalid-credential')) {
      return 'Invalid email or password.';
    } else if (message.contains('email-already-in-use')) {
      return 'An account already exists with this email address.';
    } else if (message.contains('weak-password')) {
      return 'Password should be at least 6 characters.';
    } else if (message.contains('user-not-found')) {
      return 'No user found with this email address.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }

  // Create some demo accounts for testing
  Future<void> _createDemoAccounts() async {
    final users = await _getAllUsers();
    if (users.isEmpty) {
      // Create demo accounts
      final demoAccounts = [
        {
          'uid': _uuid.v4(),
          'email': 'demo@example.com',
          'displayName': 'Demo User',
          'photoURL': null,
          'createdAt': DateTime.now().toIso8601String(),
          'emailVerified': true,
          'hashedPassword': _hashPassword('password123'),
        },
        {
          'uid': _uuid.v4(),
          'email': 'test@example.com',
          'displayName': 'Test User',
          'photoURL': null,
          'createdAt': DateTime.now().toIso8601String(),
          'emailVerified': true,
          'hashedPassword': _hashPassword('test123'),
        },
      ];

      for (var account in demoAccounts) {
        await _saveUser(account);
      }
    }
  }

  // Initialize demo accounts
  Future<void> initializeDemoAccounts() async {
    await _createDemoAccounts();
  }
} 