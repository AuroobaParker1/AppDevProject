import 'package:aap_dev_project/nodeBackend/jwtStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'aesKeyStorage.dart';

 const String baseUrl = 'https://medqr-blockchain.onrender.com/api/patients'; // Replace with your actual API endpoint

Future<http.Response> login({
  required String email,
  required String password,
}) async {
  final Map<String, dynamic> body = {
    'email': email,
    'password': password,
  };

  final Uri url = Uri.parse('$baseUrl/login'); // Replace "/login" with your actual endpoint

  return await http.post(
    url,
    body: jsonEncode(body),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<String?> loginUser({required String email, required String password}) async {
  try {
    final response = await login(email: email, password: password);
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final key = data['aeskey'];
      // Store token in SharedPreferences securely
      await storeJwtToken(token);
     
      // Handle successful login (e.g., navigate to a different screen)
      print('Login successful! Token stored in SharedPreferences.');

      return key;
    } else {
      // Handle login failure gracefully (e.g., display error message)
      print('Login failed: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (error) {
    // Handle errors during login request (e.g., network issues)
    print('Error during login: $error');
    return null;
  }
}
