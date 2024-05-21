import 'package:aap_dev_project/models/user.dart';
import 'package:aap_dev_project/API/login.dart';
import 'package:aap_dev_project/API/register.dart';
import 'package:aap_dev_project/API/getUserInfo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../API/aesKeyStorage.dart';
class UserRepository {
  Future<UserProfile> getUser(String token) async {
  http.Response response = await getInfo(token: token);

  // Check for successful response (200 OK)
  if (response.statusCode == 200) {
    // Parse JSON response into a Dart map
    final Map<String, dynamic> data = jsonDecode(response.body);

    // Extract user data from the response (replace key names with actual API response structure)
    final name = data['name'] as String?;
    final email = data['email'] as String?;
    final image = data['image'] as String?;
    final age = data['age'] as int?; // Assuming age is an integer
    final mobile = data['mobileNumber'] as String?;
    final adress = data['adress'] as String?;
    final cnic = data['cnic'] as String?;
    final medicalHistory = data['medicalHistory'] as String?;

    // Create and return the UserProfile object
    return UserProfile(
      name: name ?? 'null',
      email: email ?? 'null',
      image: image ?? 'null',
      age: age ?? 0,
      mobile: mobile ?? 'null',
      adress: adress ?? 'null',
      cnic: cnic ?? 'null',
      medicalHistory: medicalHistory ?? 'null',
    );
  } else {
    // Handle unsuccessful response (e.g., 404 Not Found, 500 Internal Server Error)
    print('Error fetching user details: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to fetch user profile'); // Or a custom exception type
  }
}


  Future<void> uploadUserRecords(
      {required UserProfile userp, required String pass}) async {
    http.Response response = await signup(
      email: userp.email,
      password: pass,
      mobileNumber: userp.mobile,
      name: userp.name,
    );
     if (response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        var wallet = responseBody['wallet'];
      



const storage = FlutterSecureStorage();



// To write
// await storage.write(key: 'wallet_privateKey', value: '${wallet['privateKey']}');
// await storage.write(key: 'wallet_address', value: '${wallet['address']}');




    

    } 
    else {
        print('Request failed with status: ${response.statusCode}.');
    }


     await loginUser(
      email: userp.email,
      password: pass,
    );
    
   await sendEncryptedAESKey();
  }
Future<bool> LoginUser_repo({
  required String user_email,
  required String user_pass,
}) async {
  try {
    var status = await loginUser(
      email: user_email,
      password: user_pass,
    );

    if (status == true) {
      return true; // Login successful
    } else {
      return false; // Login failed
    }
  } catch (e) {
    // Handle the exception
    print('Error: $e');
    return false; // Login failed due to an error
  }
}



}
