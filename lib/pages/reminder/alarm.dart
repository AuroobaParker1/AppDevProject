
import 'package:aap_dev_project/models/alarmInfo.dart';
import 'package:aap_dev_project/pages/home/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_bloc.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_event.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_state.dart';
import 'package:aap_dev_project/core/repository/alarm_repo.dart';
import 'package:aap_dev_project/pages/reminder/medicine.dart';
import 'package:aap_dev_project/pages/navigation/appDrawer.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({Key? key}) : super(key: key);

  @override
  State<AlarmHomeScreen> createState() => _ExampleAlarmHomeScreenState();
}

class _ExampleAlarmHomeScreenState extends State<AlarmHomeScreen>
    with RouteAware {
  final AlarmRepository alarmRepository = AlarmRepository();
  late AlarmBloc _alarmBloc;

  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  void initState() {
    _alarmBloc = AlarmBloc(alarmRepository: alarmRepository);
    _alarmBloc.add(const FetchAlarm());
    super.initState();
    _alarmBloc.stream.listen((state) {
      if (state is AlarmLoaded) {
        scheduleNextRingTime(state.alarms);
      }
    });
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
          FlutterAlarmClock.createAlarm(
            hour: alarmTimes[i].hour,
            minutes: alarmTimes[i].minute,
            title: 'It is time to take ${alarmItem.name}!',
          );
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

    return alarmTimes;
  }

  Widget buildAlarmCard(AlarmInformation alarm, state) {
    return Card(
      color: const Color(0xFF01888B),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: const BorderSide(
          color: Colors.yellow,
          width: 5.0,
        ),
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
                    alarm.name.length > 9
                        ? '${state.user.name.substring(0, 9)}...'
                        : alarm.name,
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
                      child: const Row(
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
                  fontSize: 25.0,
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
              const SizedBox(height: 4.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _alarmBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: BlocBuilder(
        bloc: _alarmBloc,
        builder: (_, AlarmState state) {
          if (state is AlarmLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlarmLoaded) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                    color: Color(0xFF01888B),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => DashboardApp()),
                                );
                              },
                            )),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Alarm",
                          style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
                const SizedBox(height: 25),
              ],
            );
          } else if (state is AlarmError) {
            return Center(
                child: Text(state.errorMsg ?? 'No error message available'));
          } else if (state is AlarmDeletedSuccess) {
            _alarmBloc.add(const FetchAlarm());
          } else if (state is AlarmSetting) {
            const Center();
          } else if (state is AlarmSetSuccess) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AlarmHomeScreen(),
                ));
          } else if (state is AlarmDeleting) {
            const Center(
                child: Column(children: [
              CircularProgressIndicator(),
              Text("Deleting Alarm")
            ]));
          } else if (state is AlarmDeleteError) {
            return Center(
                child: Text(state.errorMsg ?? 'No error message available'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
