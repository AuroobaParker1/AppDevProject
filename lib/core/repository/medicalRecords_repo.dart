import 'dart:convert';
import 'dart:typed_data';

import 'package:aap_dev_project/models/report.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;


import 'package:aap_dev_project/util/constant.dart'as constants;

import '../../API/aesKeyStorage.dart';
import '../../API/jwtStorage.dart';
import '../../API/upload_medical_record.dart';

class MedicalRecordsRepository {

//   Future<List<MedicalRecord>> getUserRecords() async {
//     try {
//       // Retrieve the JWT token
//       String? token = await retrieveJwtToken();

//       if (token == null) {
//         print('JWT token not found');
//         return [];
//       }

//       final response = await http.get(
//         Uri.parse('${constants.url}/api/medical-records/patient'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         final List<MedicalRecord> records = [];
//         // Create an instance of FlutterSecureStorage
//           const storage = FlutterSecureStorage();

//            var aesKey = await retrieveAESKey();
//   final ivString = await storage.read(key: 'iv');

//   // Create an AES Encrypter with your key and IV
  
// // Decode the IV string from base64
// final ivBytes = base64.decode(ivString!);
//  final iv = encrypt.IV(ivBytes);

//           // Use the same AES key and IV to create a decrypter
//           final decrypter = encrypt.Encrypter(encrypt.AES(aesKey!,mode:encrypt.AESMode.cbc));

       
//         for (final item in data) { 
//           var temp = MedicalRecord.fromJson(item);
          

        
//           // Decrypt the image
//           var decryptedImage = decrypter.decryptBytes(encrypt.Encrypted(temp.data), iv: iv);

//           // Now, decryptedImage is a Uint8List containing the original, decrypted image bytes

//             temp.data = Uint8List.fromList(decryptedImage);



//            records.add(temp);
//         }

//         return records;
//       } else {
//         throw Exception('Failed to fetch medical records');
//       }
//     } catch (e) {
//       print('Error: $e');
//       return [];
//     }
//   }
Future<List<MedicalRecord>> getUserRecords() async {
  try {
    // Retrieve the JWT token
    String? token = await retrieveJwtToken();

    if (token == null) {
      print('JWT token not found');
      return [];
    }

    final response = await http.get(
      Uri.parse('${constants.url}/api/medical-records/patient'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<MedicalRecord> records = [];

      // Create an instance of FlutterSecureStorage
      const storage = FlutterSecureStorage();

      var aesKey = await retrieveAESKey();
      if (aesKey == null) {
        print('AES key not found');
        return [];
      }

      final ivString = await storage.read(key: 'iv');
      if (ivString == null) {
        print('IV not found');
        return [];
      }

      // Decode the IV string from base64
      final ivBytes = base64.decode(ivString);
      final iv = encrypt.IV(ivBytes);

      // Use the same AES key and IV to create a decrypter
      final decrypter = encrypt.Encrypter(encrypt.AES(aesKey, mode: encrypt.AESMode.cbc));

      for (final item in data) {
        var temp = MedicalRecord.fromJson(item);

        try {
          // Decrypt the data
          var decryptedImage = decrypter.decryptBytes(encrypt.Encrypted(temp.data), iv: iv);
          temp.data = Uint8List.fromList(decryptedImage);
          records.add(temp);
        } catch (e) {
          print('Decryption error for record: $e');
          continue;  // Skip this record or handle error appropriately
        }
      }

      return records;
    } else {
      throw Exception('Failed to fetch medical records');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

  Future<void> uploadUserRecords(UserReport uploadedReport) async {
    await uploadMedicalRecord(uploadedReport);
    
  }
}

class UtilMedicalRecord {
  final List<dynamic> records;

  UtilMedicalRecord({required this.records});

  factory UtilMedicalRecord.fromJson(Map<String, dynamic> json) {
    return UtilMedicalRecord(records: json['records']);
  }
}
