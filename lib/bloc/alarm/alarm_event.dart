import 'package:aap_dev_project/models/alarmz.dart';
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

  const SetAlarm(this.alarmInfo);  // Removed the extra parameter

  @override
  List<Object> get props => [alarmInfo];
}


class DeleteAlarm extends AlarmEvent {
  final String alarmId;

  const DeleteAlarm({required this.alarmId});

  @override
  List<Object> get props => [alarmId];
} 
class ToggleAlarm extends AlarmEvent {
  final String alarmId;
  final bool isActive;

  const ToggleAlarm({required this.alarmId, required this.isActive});

  @override
  List<Object> get props => [alarmId, isActive];
}
