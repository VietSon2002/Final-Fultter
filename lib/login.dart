import 'package:flutter/material.dart';
import 'db_helper.dart'; // Import your DB helper file

class LoginScreen extends StatefulWidget {
  final void Function(String, String) onLogin;
  LoginScreen({required this.onLogin});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Tên đăng nhập'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _login(),
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      // Handle invalid login details
      return;
    }

    final bool isValidLogin = await _dbHelper.validateLogin(username, password);

    if (isValidLogin) {
      // Successful login
      // Trả về tên người dùng cho màn hình gọi đến
      widget.onLogin(
          username, 'admin'); // Thay 'admin' bằng role từ database nếu có
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Handle unsuccessful login
      print('Login failed. Please check your credentials.');
    }
  }
}
