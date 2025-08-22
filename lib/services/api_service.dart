import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";


  /// REGISTER
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? avatarPath,
  }) async {
    var url = Uri.parse("$baseUrl/register");

    var request = http.MultipartRequest("POST", url);
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = passwordConfirmation;

    if (avatarPath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('avatar', avatarPath));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("🔹 REGISTER Response Code: ${response.statusCode}");
    print("🔹 REGISTER Request Fields: ${request.fields}");

    if (response.statusCode == 201) {
      return {
        "success": true,
        "data": jsonDecode(responseBody),
      };
    } else {
      return {
        "success": false,
        "message": jsonDecode(responseBody),
      };
    }
  }

///LOGIN
  static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  final url = Uri.parse('$baseUrl/login');

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  print("🔹 LOGIN Response Code: ${response.statusCode}");
  print("🔹 LOGIN Response Body: ${response.body}");

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data['status'] == true) {
    // simpan token ke SharedPreferences
    if (data['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
    }
    return {
      'success': true,
      'message': data['message'],
      'user': data['user'],
    };
  } else {
    return {
      'success': false,
      'message': data['message'] ?? 'Login gagal',
    };
  }
}

///LOGOUT
static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token != null) {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("🔹 LOGOUT Response Code: ${response.statusCode}");
      print("🔹 LOGOUT Response Body: ${response.body}");
    } catch (e) {
      print("🔹 LOGOUT Error: $e");
    }
  }

  // hapus token dari local storage
  await prefs.remove('token');
}

}
