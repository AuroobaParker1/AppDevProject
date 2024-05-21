import 'dart:math';

import 'package:aap_dev_project/API/jwtStorage.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';


import 'package:aap_dev_project/util/constant.dart'as constants;

import 'aesKeyStorage.dart';


 const String baseUrl = '${constants.url}/api/patients'; // Replace with your actual API endpoint
 

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

Future<bool?> loginUser({required String email, required String password}) async {
  try {
    final response = await login(email: email, password: password);
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      var key = data['aesKey'];
      var iv = data['iv'];
      // Store token in SharedPreferences securely
      await storeJwtToken(token);
      await storeAESKey(key,iv);
     
      // Handle successful login (e.g., navigate to a different screen)
      print('Login successful! Token stored in SharedPreferences.');

      return true;
    } else {
      // Handle login failure gracefully (e.g., display error message)
      print('Login failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (error) {
    // Handle errors during login request (e.g., network issues)
    print('Error during login: $error');
    return false;
  }
}


