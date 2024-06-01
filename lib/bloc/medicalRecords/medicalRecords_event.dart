import 'package:aap_dev_project/models/report.dart';

abstract class RecordEvent{
  const RecordEvent([List props = const []]) : super();
}

class FetchRecord extends RecordEvent {
  const FetchRecord();

  // @override
  // List<Object?> get props => [userid];
}

class SetRecord extends RecordEvent {
  final UserReport report;

  const SetRecord({required this.report});

  // @override
  // List<Object> get props => [report];
}
