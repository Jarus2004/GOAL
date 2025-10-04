import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: LoginPage(), // ใช้ LoginPage เป็นหน้าแรก
    );
  }
}
