import 'package:flutter/material.dart';
import 'data.dart'; // เพิ่ม import สำหรับ DBHelper
import 'login.dart'; // สำหรับกลับไปหน้า Login หลังสมัครเสร็จ

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  // ลบ _confirmPassword ออก เพราะไม่ได้ใช้งาน

  Future<void> _register() async {
    try {
      await DBHelper.insertUser({
        'username': _username.trim(),
        'password': _password.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('สมัครสมาชิกสำเร็จ')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
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
      appBar: AppBar(title: Text('สมัครสมาชิก'), backgroundColor: Colors.cyan),
      body: Container(
        color: Colors.cyan[200],
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360),
          ),
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ชื่อผู้ใช้'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อผู้ใช้';
                      }
                      return null;
                    },
                    onSaved: (value) => _username = value ?? '',
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'รหัสผ่าน'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value ?? '',
                  ),

                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      overlayColor: Colors.lightBlue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _register();
                      }
                    },
                    child: Text(
                      'สมัครสมาชิก',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
