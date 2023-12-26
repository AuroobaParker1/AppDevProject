import 'package:aap_dev_project/models/alarmz.dart';
import 'package:aap_dev_project/pages/alarm.dart';
import 'package:equatable/equatable.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent([List props = const []]) : super();
}

class FetchAlarm extends AlarmEvent {
  const FetchAlarm() : super();

  @override
  List<Object?> get props => [];
}

class SetAlarm extends AlarmEvent {
  final AlarmInformation alarmInfo;

  SetAlarm(this.alarmInfo);  // Removed the extra parameter

  @override
  List<Object> get props => [alarmInfo];
}


class DeleteAlarm extends AlarmEvent {
  final String alarmId;

  DeleteAlarm({required this.alarmId});

  @override
  List<Object> get props => [alarmId];
}