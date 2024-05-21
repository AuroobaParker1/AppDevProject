import 'dart:convert';
import 'dart:typed_data';

import 'package:aap_dev_project/models/report.dart';
import 'package:aap_dev_project/models/user.dart';
import 'package:aap_dev_project/models/userSharing.dart';
import 'package:aap_dev_project/API/aesKeyStorage.dart';
import 'package:aap_dev_project/API/medicalRecordService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RecordsSharingRepository {
  // Generates a verification code for a user based on their email
  Future<String> generateVerificationCode() async {
    try {
      Map<String, dynamic> result = await MedicalRecordService.generateVerificationCode();
      // Assuming the result contains a field 'code' with the verification code
      var code = result['code'];

      return code.toString() ;
    } catch (e) {
      print('Failed to generate verification code: $e');
      throw Exception('Failed to generate verification code');
    }
  }

  // Verifies a given code and retrieves records associated with it
  Future<List<MedicalRecord>> verifyCodeAndRetrieveRecords(String code) async {
    try {
      List<dynamic> data = await MedicalRecordService.verifyCodeAndRetrieveRecords(code);
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
    
      // List<dynamic> sharedData = records['currentlySharing'];  // Assuming the API response contains a 'currentlySharing' field with the list of shared records
      // return sharedData.map((record) => UserSharing.fromJson(record as Map<String, dynamic>)).toList();
    

    } catch (e) {
      print('Failed to verify code and retrieve records: $e');
    
      return [];
    }
  }
}
