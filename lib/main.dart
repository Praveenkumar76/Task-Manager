import 'package:flutter/material.dart';
import 'package:task_manager/services/auth_service.dart';
import 'package:task_manager/screens/auth/login_screen.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize authentication service
  await AuthService().init();
  await AuthService().initializeDemoAccounts();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return authService.currentUser != null 
        ? HomeScreen() 
        : LoginScreen();
  }
}
