import 'dart:math';

import 'package:aap_dev_project/nodeBackend/jwtStorage.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:asn1lib/asn1lib.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';


import 'package:aap_dev_project/util/constant.dart'as constants;

import 'aesKeyStorage.dart';
import 'fix_secure.dart';

 const String baseUrl = '${constants.ip}/api/patients'; // Replace with your actual API endpoint
 

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


