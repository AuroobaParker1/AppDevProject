import 'package:aap_dev_project/models/report.dart';
import 'package:equatable/equatable.dart';

abstract class RecordState extends Equatable {
  const RecordState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class RecordEmpty extends RecordState {}

class RecordLoading extends RecordState {}

class RecordLoaded extends RecordState {
  final List<MedicalRecord> records;

  RecordLoaded({required this.records}) : super([records]);
}

class RecordError extends RecordState {
  final String? errorMsg;
  const RecordError({this.errorMsg});
}

class RecordSetting extends RecordState {} 

// class RecordSetSuccess extends RecordState {
//   final List<UserReport> records;

//   RecordSetSuccess({required this.records}) : super([records]);
// } 
class RecordSetSuccess extends RecordState {

  // RecordSetSuccess() : super([]);
} 

class RecordSetError extends RecordState {
  final String? errorMsg;
  const RecordSetError({this.errorMsg});
}
