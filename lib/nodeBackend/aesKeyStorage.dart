import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart'; // Add this import statement
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' as pc;
import 'dart:math';
// import 'package:pointycastle/pointycastle.dart';
import 'jwtStorage.dart';

Future<void> storeAESKey(String aesKey) async {
  try {
    // Create an instance of FlutterSecureStorage
    const storage =  FlutterSecureStorage();

  Uint8List aesKeyBytes = Uint8List.fromList(hex.decode(aesKey));


// Convert the Uint8List to a base64 string
String aesKeyBase64 = base64.encode(aesKeyBytes);


    // Create an AES encrypter with the key
    final iv = IV.fromSecureRandom(16); // Generate a random IV
    // final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    // Convert the IV to a string
    final ivString = base64.encode(iv.bytes);

    // Store the IV string in secure storage
    await storage.write(key: 'iv', value: ivString);

    // Store the key and salt in secure storage
    await storage.write(key: 'aesKey', value:aesKeyBase64);
     // Store the key and salt in secure storage
    // var t = await storage.read(key: 'aesKey');
    // print(t);
    print("aes key stored");
  } catch (e) {
    print('Error storing AES key: $e');
    // Handle error accordingly
  }
}

Future<encrypt.Key?> retrieveAESKey() async {
  // Create an instance of FlutterSecureStorage
  const storage = FlutterSecureStorage();

  // Retrieve the key string from secure storage
  final keyString = await storage.read(key: 'aesKey');

  // Convert the string back to an AES key
  if( keyString != null){
  final aesKey = encrypt.Key.fromBase64(keyString);
    return aesKey;
  }
  else{
    return null;
  }

}




Future<void> sendEncryptedAESKey() async {

  try {
    print("sendEncryptedAESKey function called");
    // Create an instance of FlutterSecureStorage
    const storage = FlutterSecureStorage();

    
    final aesKeyString = await storage.read(key: 'aesKey');
     final ivString = await storage.read(key: 'iv');

    if (aesKeyString == null) {  
      print('Keys not found in storage');
      return;
    }
     

    // Retrieve the JWT token
    final token = await retrieveJwtToken();

    // Send the encrypted AES key to the Node.js server
    final response = await http.post(
      Uri.parse('http://192.168.100.84:3001/api/patients/storeAESkey'), // Replace with your actual API endpoint
      headers: {
        'Content-Type': 'application/json',
         'Authorization': 'Bearer $token',
        // 'encryptedAesKey': aesKeyString,
        },
      body: jsonEncode({'encryptedAesKey': aesKeyString, 'IV': ivString}),
    );

    if (response.statusCode == 200) {
      print('AES key sent successfully');
    } else {
      print('Failed to send AES key: ${response.statusCode} - ${response.body}');
    }
  } catch (error) {
    print('Error during key transmission: $error');
  }
}
