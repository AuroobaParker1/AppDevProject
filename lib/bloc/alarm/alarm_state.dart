import 'package:aap_dev_project/models/alarmInfo.dart';
import 'package:equatable/equatable.dart';

abstract class AlarmState extends Equatable {
  const AlarmState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class AlarmInitial extends AlarmState {}

class AlarmLoading extends AlarmState {}

class AlarmLoaded extends AlarmState {
  final List<AlarmInformation> alarms;

  AlarmLoaded({required this.alarms}) : super([alarms]);
}

class AlarmError extends AlarmState {
  final String? errorMsg;
  const AlarmError({this.errorMsg});
}

class AlarmSetting extends AlarmState {}

class AlarmSetSuccess extends AlarmState {
  final List<AlarmInformation> alarms;

  AlarmSetSuccess({required this.alarms}) : super([alarms]);
}

class AlarmSetError extends AlarmState {
  final String? errorMsg;
  const AlarmSetError({this.errorMsg});
}

class AlarmDeleting extends AlarmState {}

class AlarmDeletedSuccess extends AlarmState {
  final List<AlarmInformation> alarms;

  AlarmDeletedSuccess({required this.alarms}) : super([alarms]);
}

class AlarmDeleteError extends AlarmState {
  final String? errorMsg;
  const AlarmDeleteError({this.errorMsg});
}
