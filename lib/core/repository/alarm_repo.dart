// import 'package:aap_dev_project/models/alarmInfo.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AlarmRepository {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<AlarmInformation>> getUserAlarms() async {
//     User? user = _auth.currentUser;
//     if (user == null) {
//       return [];
//     }

//     DocumentSnapshot snapshot =
//         await _firestore.collection('alarms').doc(user.uid).get();
//     if (snapshot.exists) {
//       List<dynamic>? alarmData =
//           (snapshot.data() as Map<String, dynamic>?)?['alarmsz'];
//       if (alarmData != null) {
//         return alarmData
//             .map((alarm) =>
//                 AlarmInformation.fromJson(alarm as Map<String, dynamic>))
//             .toList();
//       }
//     }
//     return [];
//   }

//   Future<void> uploadUserAlarm(AlarmInformation uploadedAlarm) async {
//     User? user = _auth.currentUser;
//     if (user == null) throw Exception('User not authenticated');
//     print('lollll');
//     DocumentReference docRef = _firestore.collection('alarms').doc(user.uid);
//     await _firestore.runTransaction((transaction) async {
//       DocumentSnapshot snapshot = await transaction.get(docRef);

//       if (!snapshot.exists) {
//         transaction.set(docRef, {
//           'alarmsz': [uploadedAlarm.toJson()]
//         });
//         print("asfasfsfa");
//       } else {
//         List<dynamic> existingAlarms = snapshot.get('alarmsz');
//         transaction.update(docRef, {
//           'alarmsz': [...existingAlarms, uploadedAlarm.toJson()]
//         });
//       }
//     });
//   }

//   Future<void> deleteUserAlarm(String alarmId) async {
//     User? user = _auth.currentUser;
//     DocumentSnapshot snapshot =
//         await _firestore.collection('alarms').doc(user?.uid).get();
//     if (snapshot.exists) {
//       List<dynamic>? alarmData =
//           (snapshot.data() as Map<String, dynamic>?)?['alarmsz'];
//       if (alarmData != null) {
//         List<AlarmInformation> userAlarms = alarmData
//             .map((alarm) =>
//                 AlarmInformation.fromJson(alarm as Map<String, dynamic>))
//             .toList();
//         userAlarms.removeWhere((alarm) => alarm.id == alarmId);
//         await _firestore
//             .collection('alarms')
//             .doc(user?.uid)
//             .update({'alarmsz': userAlarms.map((e) => e.toJson()).toList()});
//       }
//     }
//   }
// }


import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aap_dev_project/models/alarmInfo.dart';

class AlarmRepository {
  final String _alarmsKey = 'alarms';

  Future<List<AlarmInformation>> getUserAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsString = prefs.getString(_alarmsKey);

    if (alarmsString == null) {
      return [];
    }

    final List<dynamic> alarmData = json.decode(alarmsString);
    return alarmData.map((alarm) => AlarmInformation.fromJson(alarm)).toList();
  }

  Future<void> uploadUserAlarm(AlarmInformation uploadedAlarm) async {
    final prefs = await SharedPreferences.getInstance();
    final alarms = await getUserAlarms();
    alarms.add(uploadedAlarm);

    final alarmsString = json.encode(alarms.map((alarm) => alarm.toJson()).toList());
    await prefs.setString(_alarmsKey, alarmsString);
  }

  Future<void> deleteUserAlarm(String alarmId) async {
    final prefs = await SharedPreferences.getInstance();
    final alarms = await getUserAlarms();
    alarms.removeWhere((alarm) => alarm.id == alarmId);

    final alarmsString = json.encode(alarms.map((alarm) => alarm.toJson()).toList());
    await prefs.setString(_alarmsKey, alarmsString);
  }
}