import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:votingindia/api/secure.dart';
import 'package:votingindia/models/candidate.dart';

class ApiService {
  static const String baseUrl = Secure.apiurl;
  static const storage = FlutterSecureStorage();

  // Signup user
  static Future<void> signup(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl + '/user/signup'), // Updated endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to signup: ${response.body}');
    }
  }

  // Login user - Updated to accept aadhar and password
  static Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final aadhar = data['aadhar'];
    final password = data['password'];

    final response = await http.post(
      Uri.parse('$baseUrl/user/login'), // Updated endpoint
      body: json.encode({'aadhar': aadhar, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      await storage.write(key: 'token', value: responseData['token']);
      return responseData;
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }

  // Get user role
  static Future<String?> getUserRole() async {
    final profile = await getProfile(); // Fetch user profile
    return profile['role']; // Assuming 'role' is part of the profile response
  }

  // Fetch user profile
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'), // Updated endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  // Update password
  static Future<void> updatePassword(Map<String, String> passwordData) async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/user/profile/password'), // Updated endpoint
      body: json.encode(passwordData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to update password');
    }
  }

  // Fetch candidates list
  static Future<List<Candidate>> getCandidates() async {
    final response =
        await http.get(Uri.parse('$baseUrl/candidate')); // No user prefix here

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Candidate.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load candidates');
    }
  }

  // Delete a candidate
  static Future<void> deleteCandidate(String candidateId) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/candidate/$candidateId')); // No user prefix here
    if (response.statusCode != 200) {
      throw Exception('Failed to delete candidate');
    }
  }

  // Vote for a candidate
  static Future<void> voteForCandidate(String candidateId) async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/candidate/vote/$candidateId'), // No user prefix here
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to cast vote');
    }
  }

  // Add a new candidate
  static Future<void> addCandidate(Map<String, String> candidateData) async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/candidate'), // No user prefix here
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(candidateData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add candidate');
    }
  }
}
