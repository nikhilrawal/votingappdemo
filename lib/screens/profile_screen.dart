import 'package:flutter/material.dart';
import 'package:votingindia/api/api_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _userProfile = {};
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final profileData = await ApiService.getProfile();
      setState(() {
        _userProfile = profileData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to load profile: ${e.toString()}');
    }
  }

  Future<void> _updatePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
      _showError("Both fields are required");
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator during update
    });

    try {
      await ApiService.updatePassword({
        'currpass': _currentPasswordController.text,
        'newpass': _newPasswordController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password updated successfully")),
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } catch (e) {
      _showError("Failed to update password: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator after update
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: ${_userProfile['name'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Aadhar: ${_userProfile['aadhar'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Current Password"),
                  ),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "New Password"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updatePassword,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Update Password"),
                  ),
                ],
              ),
            ),
    );
  }
}
