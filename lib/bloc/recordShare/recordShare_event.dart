import 'package:equatable/equatable.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent([List props = const []]) : super();
}

class FetchRecord extends RecordEvent {
  const FetchRecord() : super();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddRecord extends RecordEvent {
  final String code;

  const AddRecord({required this.code});

  @override
  List<Object> get props => [code];
}

class RemoveRecord extends RecordEvent {
  const RemoveRecord();

  @override
  List<Object> get props => [];
}
