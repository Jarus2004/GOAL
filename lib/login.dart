import 'package:flutter/material.dart';
import 'data.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  Future<void> _login() async {
    final user = await DBHelper.getUser(
      _userController.text.trim(),
      _passController.text.trim(),
    );
    if (!mounted) return;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง')),
      );
    }
  }

  Future<void> _register() async {
    try {
      await DBHelper.insertUser({
        'username': _userController.text.trim(),
        'password': _passController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('สมัครสมาชิกสำเร็จ')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ชื่อผู้ใช้นี้มีอยู่แล้ว')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เข้าสู่ระบบ')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
              decoration: InputDecoration(labelText: 'ชื่อผู้ใช้'),
            ),
            TextField(
              controller: _passController,
              decoration: InputDecoration(labelText: 'รหัสผ่าน'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: _login, child: Text('เข้าสู่ระบบ')),
            TextButton(onPressed: _register, child: Text('สมัครสมาชิก')),
          ],
        ),
      ),
    );
  }
}
