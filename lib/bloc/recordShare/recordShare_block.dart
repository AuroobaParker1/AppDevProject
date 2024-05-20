import 'package:aap_dev_project/bloc/recordShare/recordShare_event.dart';
import 'package:aap_dev_project/bloc/recordShare/recordShare_state.dart';
import 'package:aap_dev_project/core/repository/recordsSharing_repo.dart';
import 'package:aap_dev_project/models/userSharing.dart';
import 'package:bloc/bloc.dart';

// class RecordShareBloc extends Bloc<RecordEvent, RecordState> {
//   final RecordsSharingRepository recordsRepository;

//   RecordShareBloc({required this.recordsRepository}) : super(RecordLoading()) {
//     on<FetchRecord>((event, emit) async {
//       await _getRecord(emit);
//     });
//     on<AddRecord>((event, emit) async {
//       await _addRecord(emit, event.code);
//     });
//     on<RemoveRecord>((event, emit) async {
//       await _removeRecord(emit);
//     });
//   }

//   Future<void> _getRecord(Emitter<RecordState> emit) async {
//     emit(RecordLoading());
//     try {
//       final List<UserSharing> records =
//           await recordsRepository.getSharedRecords();
//       emit(RecordLoaded(records: records));
//     } catch (e) {
//       emit(RecordError(errorMsg: e.toString()));
//     }
//   }

//   Future<void> _removeRecord(Emitter<RecordState> emit) async {
//     emit(RecordSetting());

//     try {
//       final List<UserSharing> records =
//           await recordsRepository.removerUserFromShared();
//       emit(RecordSetSuccess(records: records));
//     } catch (e) {
//       emit(RecordSetError(errorMsg: e.toString()));
//     }
//   }

//   Future<void> _addRecord(Emitter<RecordState> emit, String code) async {
//     emit(RecordSetting());

//     try {
//       final List<UserSharing> records =
//           await recordsRepository.addUserToShared(code);
//       emit(RecordSetSuccess(records: records));
//     } catch (e) {
//       emit(RecordSetError(errorMsg: e.toString()));
//     }
//   }
// }
