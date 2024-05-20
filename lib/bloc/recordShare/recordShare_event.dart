import 'package:equatable/equatable.dart';

abstract class MedicalRecordEvent extends Equatable {
  const MedicalRecordEvent();

  @override
  List<Object> get props => [];
}

class GenerateVerificationCode extends MedicalRecordEvent {
  final String email;

  const GenerateVerificationCode(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyCodeAndRetrieveRecords extends MedicalRecordEvent {
  final String code;

  const VerifyCodeAndRetrieveRecords(this.code);

  @override
  List<Object> get props => [code];
}
