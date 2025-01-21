import 'package:flutter/material.dart';
import 'package:votingindia/api/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:votingindia/widgets/custom_button.dart';
import 'package:votingindia/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Secure storage instance
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Login handler
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final aadhar = _aadharController.text;
    final password = _passwordController.text;

    try {
      final response = await ApiService.login({
        'aadhar': aadhar,
        'password': password,
      });

      // ignore: unnecessary_null_comparison
      if (response != null && response.containsKey('token')) {
        final token = response['token'];

        await storage.write(key: 'token', value: token);
        // Fetch profile and cache role after successful login
        final profile = await ApiService.getProfile();
        await storage.write(key: 'role', value: profile['role']);

        Navigator.pushReplacementNamed(context, '/main');
      } else {
        _showError("Invalid login credentials. Please try again.");
      }
    } catch (e) {
      _showError("Signin failed: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Error display helper
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _aadharController,
              label: 'Aadhar Card Number',
              obscureText: false,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 32),
            _isLoading
                ? CircularProgressIndicator()
                : CustomButton(
                    onPressed: _login,
                    text: 'Login',
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: Text("Don't have an account? Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
