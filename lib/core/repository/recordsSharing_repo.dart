// import 'package:aap_dev_project/models/user.dart';
// import 'package:aap_dev_project/models/userSharing.dart';


// class RecordsSharingRepository {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<UserSharing>>getSharedRecords() async {
//     DocumentSnapshot snapshot =
//         await _firestore.collection('recordSharing').doc('efg').get();
//     if (snapshot.exists) {
//       List<dynamic>? sharedData =
//           (snapshot.data() as Map<String, dynamic>?)?['currentlySharing'];
//       if (sharedData != null) {
//         List<UserSharing> userRecords = sharedData
//             .map((record) =>
//                 UserSharing.fromJson(record as Map<String, dynamic>))
//             .toList();

//         return userRecords;
//       }
//     }
//     return [];
//   }

//   Future<List<UserSharing>> removerUserFromShared() async {
//     User? user = _auth.currentUser;

//     DocumentSnapshot snapshot =
//         await _firestore.collection('recordSharing').doc('efg').get();
//     if (snapshot.exists) {
//       List<dynamic>? sharedData =
//           (snapshot.data() as Map<String, dynamic>?)?['currentlySharing'];
//       List<UserSharing> userRecords = sharedData!
//           .map((records) =>
//               UserSharing.fromJson(records as Map<String, dynamic>))
//           .toList();
//       userRecords.removeWhere((users) => users.userid == user?.uid);
//       await _firestore.collection('recordSharing').doc('efg').update(
//           {'currentlySharing': userRecords.map((e) => e.toJson()).toList()});
//       return userRecords;
//     }
//     return [];
//   }

//   Future<List<UserSharing>> addUserToShared(String code) async {
//     print("hi");
//     print(code);
//     User? user = _auth.currentUser;

//     DocumentSnapshot snapshot1 =
//         await _firestore.collection('users').doc(user!.uid).get();
//     DocumentSnapshot snapshot =
//         await _firestore.collection('recordSharing').doc('efg').get();
//     if (snapshot.exists) {
//       var profiles = (snapshot1.data() as Map<String, dynamic>?);
//       UserProfile profile =
//           UserProfile.fromJson(profiles as Map<String, dynamic>);
//       print(profile.name);
//       List<dynamic>? sharedData =
//           (snapshot.data() as Map<String, dynamic>?)?['currentlySharing'];
//       List<UserSharing> userRecords = sharedData!
//           .map((records) =>
//               UserSharing.fromJson(records as Map<String, dynamic>))
//           .toList();
//       int existingIndex =
//           userRecords.indexWhere((users) => users.userid == user.uid);
//       if (existingIndex != -1) {
       
//         userRecords[existingIndex] =
//             UserSharing(code: code, userid: user.uid, name: profile.name);
//       } else {
//         userRecords
//             .add(UserSharing(code: code, userid: user.uid, name: profile.name));
//       }
//       print(userRecords.length);

//       await _firestore.collection('recordSharing').doc('efg').update(
//           {'currentlySharing': userRecords.map((e) => e.toJson()).toList()});
//       return userRecords;
//     }
//     return [];
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:aap_dev_project/models/userSharing.dart';

// class RecordsSharingRepository {
//   final String baseUrl = 'https://medqr-blockchain.onrender.com'; // Replace with your actual backend URL

//   Future<List<UserSharing>> getSharedRecords() async {
//     // Implement the API call to get shared records
//     final response = await http.get(Uri.parse('$baseUrl/api/shared-records'));
//     if (response.statusCode == 200) {
//       List<dynamic> sharedData = json.decode(response.body);
//       return sharedData.map((record) => UserSharing.fromJson(record)).toList();
//     } else {
//       throw Exception('Failed to load shared records');
//     }
//   }

//   Future<List<UserSharing>> removerUserFromShared() async {
//     // Implement the API call to remove user from shared records
//     final response = await http.delete(Uri.parse('$baseUrl/shared-records'));
//     if (response.statusCode == 200) {
//       List<dynamic> sharedData = json.decode(response.body);
//       return sharedData.map((record) => UserSharing.fromJson(record)).toList();
//     } else {
//       throw Exception('Failed to remove user from shared records');
//     }
//   }

//   Future<List<UserSharing>> addUserToShared(String code) async {
//     // Implement the API call to add user to shared records
//     final response = await http.post(
//       Uri.parse('$baseUrl/shared-records'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'code': code}),
//     );
//     if (response.statusCode == 200) {
//       List<dynamic> sharedData = json.decode(response.body);
//       return sharedData.map((record) => UserSharing.fromJson(record)).toList();
//     } else {
//       throw Exception('Failed to add user to shared records');
//     }
//   }
// }




// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:aap_dev_project/util/constant.dart'as constants;


// class RecordsSharingRepository {
//  String baseUrl = '${constants.url}/api/medical-records'; // Replace with your actual API endpoint

//   RecordsSharingRepository({required this.baseUrl});

//   Future<String> generateVerificationCode() async {
//     final response = await http.get(Uri.parse('$baseUrl/generate-code'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['code'];
//     } else {
//       throw Exception('Failed to generate verification code');
//     }
//   }

//   Future<List<dynamic>> verifyCodeAndRetrieveRecords(String code) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/verify-code'),
//       body: json.encode({'code': code}),
//       headers: {'Content-Type': 'application/json'},
//     );
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['medicalRecords'];
//     } else {
//       throw Exception('Failed to verify code or retrieve records');
//     }
//   }
// }


// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:aap_dev_project/util/constant.dart'as constants;
// class RecordsSharingRepository {
// String baseUrl = '${constants.url}/api/medical-records';
//   RecordsSharingRepository({required this.baseUrl});

//   Future<String> generateVerificationCode() async {
//     final response = await http.get(Uri.parse('$baseUrl/generate-code'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['code'];
//     } else {
//       throw Exception('Failed to generate verification code');
//     }
//   }

//   Future<List<dynamic>> verifyCodeAndRetrieveRecords(String code) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/verify-code'),
//       body: json.encode({'code': code}),
//       headers: {'Content-Type': 'application/json'},
//     );
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['medicalRecords'];
//     } else {
//       throw Exception('Failed to verify code or retrieve records');
//     }
//   }
// }
