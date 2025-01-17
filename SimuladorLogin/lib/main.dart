import 'package:flutter/material.dart';
import 'package:teste/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2196F3),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF212121)),
          bodyMedium: TextStyle(color: Color(0xFF757575)),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
