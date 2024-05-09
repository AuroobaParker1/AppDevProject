// Future<void> uploadMedicalRecord(UserReport report) async {
//   try {
//     final testFile = report.image; // Assume you have the UserReport object
//     print(testFile);
//     // Prepare the request
//     final url = 'http://localhost:3000/api/medical-records/upload';
//     final request = http.MultipartRequest('POST', Uri.parse(url));

//     // Retrieve the JWT token
//     final token = await retrieveJwtToken();

//     // Add the token to the request headers
//     request.headers['Authorization'] = 'Bearer $token';

//     // Read the file as a blob
//     final blob = testFile; // No need to wrap it in html.Blob constructor

//     // Convert Blob to bytes
//     final reader = FileReader();
//     reader.readAsArrayBuffer(blob);
//     await reader.onLoad.first;
//     final byteData = Uint8List.fromList(reader.result as List<int>);

//     // Create a stream from bytes
//     final stream = http.ByteStream.fromBytes(byteData);

//     // Add the stream to the multipart request
//     request.files.add(http.MultipartFile(
//       'file',
//       stream,
//       byteData.length,
//       filename: testFile.name,
//       contentType: MediaType.parse(testFile.type), // Assuming testFile.type gives mime type
//     ));

//     // Send the request
//     final response = await http.Response.fromStream(await request.send());
//     if (response.statusCode == 201) {
//       print('Medical record uploaded successfully');
//     } else {
//       print('Error uploading medical record: ${response.body}');
//     }
//   } catch (e) {
//     print('Error uploading medical record: $e');
//   }
// }

//Future<void> uploadMedicalRecord(UserReport report) async {
//   try {
//     final testFile = report.image; // Assume you have the UserReport object

//     var aesKey = await retrieveAESKey();
  
    
//     final encrypter = encrypt.Encrypter(encrypt.AES(aesKey!));
//     Uint8List testFileBytes;
//     if (testFile is html.File) {
//       final reader = html.FileReader();
//       reader.readAsDataUrl(testFile);
//       await reader.onLoad.first;
//       final dataUrl = reader.result as String;
//       final byteString = html.window.atob(dataUrl.split(',')[1]);
//       testFileBytes = Uint8List(byteString.length);
//       for (var i = 0; i < byteString.length; i++) {
//         testFileBytes[i] = byteString.codeUnitAt(i);
//       }
//     } else {
//       throw Exception('Unsupported file type');
//     }
// // Create an instance of FlutterSecureStorage
// const storage = FlutterSecureStorage();

//     // Retrieve the IV string from secure storage
// final ivString = await storage.read(key: 'iv');

// // Convert the IV string back to an IV
// final iv = encrypt.IV.fromBase64(ivString!);
//     final encryptedData = encrypter.encryptBytes(testFileBytes, iv: iv);

//     // Prepare the request
//     final url = 'http://localhost:3000/api/medical-records/upload';
//     final request = http.MultipartRequest('POST', Uri.parse(url));

//     // Retrieve the JWT token
//     final token = await retrieveJwtToken();

//     // Add the token to the request headers
//     request.headers['Authorization'] = 'Bearer $token';

//     // Create a stream from bytes
// final streamData = utf8.encode(encryptedData.base64);

//    // Add the stream to the multipart request
// request.files.add(http.MultipartFile(
//   'file',
//   http.ByteStream.fromBytes(streamData),
//   streamData.length,
//   filename: testFile.name,
//   contentType: MediaType.parse(testFile.type), // Assuming testFile.type gives mime type
// ));
    
//     // Send the request
//     final response = await http.Response.fromStream(await request.send());
//     if (response.statusCode == 201) {
//       print('Medical record uploaded successfully');
//     } else {
//       print('Error uploading medical record: ${response.body}');
//     }
//   } catch (e) {
//     print('Error uploading medical record: $e');
//   }
  
//}

import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http_parser/http_parser.dart';
import '../models/report.dart';
import 'aesKeyStorage.dart';

Future<void> uploadMedicalRecord(UserReport report) async {
  // The URL of your Node.js backend endpoint
  var url = Uri.parse('http://localhost:3000/api/medical-records/upload');

  // Create a multipart request
  var request = http.MultipartRequest('POST', url);

  // Add fields to the multipart request
  request.fields['type'] = report.type;

  // Read the image file
  var imageBytes = await File(report.image.path).readAsBytes();

// Create an instance of FlutterSecureStorage
const storage = FlutterSecureStorage();
  // Retrieve the AES key and IV
  var aesKey = await retrieveAESKey();
  final ivString = await storage.read(key: 'iv');

  // Create an AES Encrypter with your key and IV
  
  final iv = encrypt.IV.fromUtf8(ivString!);
  final encrypter = encrypt.Encrypter(encrypt.AES(aesKey!));

  // Encrypt the image
  final encryptedImage = encrypter.encryptBytes(imageBytes, iv: iv);

  // Add the encrypted image to the multipart request
  request.files.add(http.MultipartFile.fromBytes(
    'image',
    utf8.encode(encryptedImage.base64),
    filename: basename(report.image.path),
    contentType: MediaType('application', 'octet-stream'),
  ));

  // Send the request
  var response = await request.send();

  // Check the status code of the response
  if (response.statusCode == 200) {
    print('User report sent successfully');
  } else {
    print('Failed to send user report');
  }
}

