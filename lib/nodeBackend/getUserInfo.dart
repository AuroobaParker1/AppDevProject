import 'package:http/http.dart' as http;

const String baseUrl = 'https://medqr-blockchain.onrender.com/api/patients'; // Replace with your actual API endpoint

Future<http.Response> getInfo({
  required String token,
   // These parameters are no longer needed
}) async {

  final Uri url = Uri.parse('$baseUrl/get-user-info'); // Replace "/get-user-info" with your actual endpoint

  // Consider using a GET request if appropriate
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'}, // Include token in Authorization header
  );

  return response;
}

