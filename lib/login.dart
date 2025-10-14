import 'package:flutter/material.dart';
import 'data.dart';
import 'homepage.dart';
import 'register.dart'; // เพิ่มบรรทัดนี้

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เข้าสู่ระบบ'),
        backgroundColor: Colors.cyan[800],
      ),
      body: Container(
        color: Colors.cyan[700],
        padding: const EdgeInsets.all(28.0),
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(180),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text('สมัครสมาชิก'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
