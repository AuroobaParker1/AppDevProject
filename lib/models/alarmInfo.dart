
// class AlarmInformation {
//   final String id;
//   final String name;
//   final DateTime time;
//   final bool isActive;
//   final int frequency;

//   AlarmInformation({
//     required this.id,
//     required this.frequency,
//     required this.name,
//     required this.time,
//     required this.isActive,
//   });

//   factory AlarmInformation.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return AlarmInformation(
//       frequency: data['frequency'] ?? 0,
//       id: doc.id,
//       name: data['name'] ?? '',
//       time: (data['time'] as Timestamp).toDate(),
//       isActive: data['isActive'] ?? false,
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'name': name,
//       'time': Timestamp.fromDate(time),
//       'isActive': isActive,
//       'frequency': frequency,
//       'id': id,
//     };
//   }

//   factory AlarmInformation.fromJson(Map<String, dynamic> json) {
//     return AlarmInformation(
//       frequency: json['frequency'] ?? 0,
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       time: DateTime.parse(json['time']),
//       isActive: json['isActive'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'time': time.toIso8601String(),
//       'isActive': isActive,
//       'frequency': frequency,
//     };
//   }
// }
