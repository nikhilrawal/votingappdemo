import 'package:flutter/material.dart';
import 'package:votingindia/api/api_service.dart';
import 'package:votingindia/widgets/custom_text_field.dart';
import 'package:votingindia/widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'voter';
  bool _isLoading = false;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.signup({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': num.parse(_phoneController.text),
        'age': int.parse(_ageController.text),
        'address': _addressController.text,
        'aadhar': num.parse(_aadharController.text),
        'password': _passwordController.text,
        'role': _role,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup successful")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: _nameController, label: 'Name'),
            CustomTextField(controller: _emailController, label: 'Email'),
            CustomTextField(controller: _phoneController, label: 'Phone'),
            CustomTextField(controller: _ageController, label: 'Age'),
            CustomTextField(controller: _addressController, label: 'Address'),
            CustomTextField(controller: _aadharController, label: 'Aadhar'),
            CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true),
            DropdownButton<String>(
              value: _role,
              onChanged: (String? newValue) {
                setState(() {
                  _role = newValue!;
                });
              },
              items: <String>['voter', 'admin']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            _isLoading
                ? CircularProgressIndicator()
                : CustomButton(
                    onPressed: _signup,
                    text: 'Signup',
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
