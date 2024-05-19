import 'package:aap_dev_project/models/user.dart';
import 'package:aap_dev_project/models/userSharing.dart';


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
