import 'dart:async';
import 'package:aap_dev_project/models/alarmz.dart';
import 'package:intl/intl.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_bloc.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_event.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_state.dart';
import 'package:aap_dev_project/core/repository/alarm_repo.dart';
import 'package:aap_dev_project/pages/Medicine.dart';
import 'package:aap_dev_project/pages/alarmScreen.dart';
import 'package:aap_dev_project/pages/appDrawer.dart';
import 'package:aap_dev_project/pages/bottomNavigationBar.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({Key? key}) : super(key: key);

  @override
  State<AlarmHomeScreen> createState() => _ExampleAlarmHomeScreenState();
}

class _ExampleAlarmHomeScreenState extends State<AlarmHomeScreen> {
  late List<AlarmSettings> alarms;
  final AlarmRepository alarmRepository = AlarmRepository();
  late AlarmBloc _alarmBloc;
  static StreamSubscription<AlarmSettings>? subscription;
  StreamSubscription? _alarmSubscription;

  @override
  void initState() {
    _alarmBloc = AlarmBloc(alarmRepository: alarmRepository);
    _alarmBloc.add(FetchAlarm());
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidExternalStoragePermission();
    }
    loadAlarms();
    scheduleNextRingTime(alarms);
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  String getNextClosestAlarmTime(AlarmInformation alarmItem) {
    var alarmTimes = generateAlarmTimes(alarmItem.time, alarmItem.frequency);
    DateTime now = DateTime.now();
    DateTime currentDateTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    List<DateTime> futureAlarms =
        alarmTimes.where((alarm) => alarm.isAfter(currentDateTime)).toList();

    if (futureAlarms.isEmpty) {
      return DateFormat('hh:mm a').format(alarmTimes.first);
    } else {
      DateTime closestTime =
          futureAlarms.reduce((a, b) => a.isBefore(b) ? a : b);
      return DateFormat('hh:mm a').format(closestTime);
    }
  }

  void scheduleNextRingTime(state) async {
    for (var index = 0; index < state.length; index++) {
      var alarmItem = state[index];
      var alarmTimes = generateAlarmTimes(alarmItem.time, alarmItem.frequency);

      if (alarmItem.isActive) {
        for (var i = 0; i < alarmTimes.length; i++) {
          final alarmSettings = AlarmSettings(
            id: index + i + 1,
            dateTime: alarmTimes[i],
            assetAudioPath: 'assets/tune.mp3',
            loopAudio: true,
            vibrate: true,
            volume: 0.8,
            fadeDuration: 3.0,
            notificationTitle: 'Its Time to take your Medicine',
            notificationBody: '${alarmItem.name} ',
            enableNotificationOnKill: true,
          );
          await Alarm.set(alarmSettings: alarmSettings);
        }
      }
    }
  }

  List<DateTime> generateAlarmTimes(DateTime initialTime, int ringCount) {
    List<DateTime> alarmTimes = [];

    for (int i = 1; i <= ringCount; i++) {
      Duration durationToAdd = Duration(hours: (i - 1) * (24 ~/ ringCount));
      DateTime nextAlarmTime = initialTime.add(durationToAdd);
      alarmTimes.add(nextAlarmTime);
    }

    print(alarmTimes);
    return alarmTimes;
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExampleAlarmRingScreen(alarmSettings: alarmSettings),
        ));
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Widget buildAlarmCard(AlarmInformation alarm, state) {
    return Card(
      color: const Color(0xFF01888B),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    alarm.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _alarmBloc.add(DeleteAlarm(alarmId: alarm.id));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Next Dose At:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
              Text(
                getNextClosestAlarmTime(alarm),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${alarm.frequency} times a day',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 1.4,
                      child: Switch(
                        activeColor: Colors.yellow,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        value: alarm.isActive,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _alarmBloc.close();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: BlocBuilder(
        bloc: _alarmBloc,
        builder: (_, AlarmState state) {
          print("Bol");
          print(state);
          if (state is AlarmLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlarmLoaded) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                    color: Color(0xFF01888B),
                  ),
                  child: const Center(
                    child: Text(
                      "Alarm",
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: state.alarms.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildAlarmCard(state.alarms[index], state);
                      },
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MedqrPage()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Color(0xFF01888B),
                      child: Icon(
                        size: 30.0,
                        Icons.alarm_add,
                        color: Colors.white,
                      ),
                    )),
              ],
            );
          } else if (state is AlarmError) {
            return Center(
                child: Text(state.errorMsg ?? 'No error message available'));
          } else if (state is AlarmDeletedSuccess) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlarmHomeScreen(),
                ));
          } else if (state is AlarmSetting) {
            print("JOKLKLK");
            const Center();
          } else if (state is AlarmSetSuccess) {
            print("Chekcout");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AlarmHomeScreen(),
                ));
          } else if (state is AlarmDeleting) {
            const Center();
          } else if (state is AlarmDeleteError) {
            return Center(
                child: Text(state.errorMsg ?? 'No error message available'));
          }
          return const Center();
        },
      ),
    );
  }
}
