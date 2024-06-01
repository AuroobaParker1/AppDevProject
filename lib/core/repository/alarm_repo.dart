
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
