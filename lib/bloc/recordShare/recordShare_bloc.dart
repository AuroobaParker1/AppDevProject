// import 'package:aap_dev_project/bloc/recordShare/recordShare_event.dart';
// import 'package:aap_dev_project/bloc/recordShare/recordShare_state.dart';
// import 'package:aap_dev_project/core/repository/medicalRecordService.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// class MedicalRecordBloc extends Bloc<MedicalRecordEvent, MedicalRecordState> {
//   MedicalRecordBloc() : super(MedicalRecordInitial());

//   @override
//   Stream<MedicalRecordState> mapEventToState(MedicalRecordEvent event) async* {
//     if (event is GenerateVerificationCode) {
//       yield MedicalRecordLoading();
//       try {
//         final data = await MedicalRecordService.generateVerificationCode(event.email);
//         yield MedicalRecordLoaded(data);
//       } catch (e) {
//         yield MedicalRecordError(e.toString());
//       }
//     } else if (event is VerifyCodeAndRetrieveRecords) {
//       yield MedicalRecordLoading();
//       try {
//         final data = await MedicalRecordService.verifyCodeAndRetrieveRecords(event.code);
//         yield MedicalRecordLoaded(data);
//       } catch (e) {
//         yield MedicalRecordError(e.toString());
//       }
//     }
//   }
// }
