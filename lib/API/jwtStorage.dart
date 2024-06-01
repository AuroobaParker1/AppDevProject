import 'package:shared_preferences/shared_preferences.dart';

const String tokenKey = 'authToken'; // Key for storing the token

Future<void> storeJwtToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(tokenKey, token); // Store the token
  print('JWT token stored successfully!');
}

Future<String?> retrieveJwtToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(tokenKey); // Retrieve the token
}
Future<void> deleteJwtToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(tokenKey); // Remove the token
  print('JWT token deleted successfully!');
}