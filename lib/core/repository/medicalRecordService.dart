import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aap_dev_project/util/constant.dart'as constants;

import '../../nodeBackend/jwtStorage.dart';

// class MedicalRecordService {
//   static const String baseUrl = '${constants.url}/api/medical-records';

//   static Future<Map<String, dynamic>> generateVerificationCode() async {
//     // Retrieve the JWT token
//       String? token = await retrieveJwtToken();

//       if (token == null) {
//         print('JWT token not found');
//         throw Exception('JWT token not found');
//       }

//      final response = await http.get(
//     Uri.parse('$baseUrl/generate-code'),
//     headers: {'Authorization': 'Bearer $token'}, // Include JWT token in the header
//   );
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to generate verification code');
//     }
//   }

//   static Future<Map<String, dynamic>> verifyCodeAndRetrieveRecords(String code) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/verify-code'),
//       body: {'code': code},
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to verify code and retrieve records');
//     }
//   }
// }






class MedicalRecordService {
  static const String baseUrl = '${constants.url}/api/medical-records';

  static Future<Map<String, dynamic>> generateVerificationCode() async {
    // Retrieve the JWT token
    String? token = await retrieveJwtToken();

    if (token == null) {
      print('JWT token not found');
      throw Exception('JWT token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/generate-code'),
      headers: {'Authorization': 'Bearer $token'}, // Include JWT token in the header
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to generate verification code');
    }
  }

  static Future<Map<String, dynamic>> verifyCodeAndRetrieveRecords(String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-code'),
      body: {'code': code},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to verify code and retrieve records');
    }
  }
}
