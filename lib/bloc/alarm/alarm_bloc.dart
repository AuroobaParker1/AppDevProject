import 'package:aap_dev_project/bloc/alarm/alarm_event.dart';
import 'package:aap_dev_project/bloc/alarm/alarm_state.dart';
import 'package:aap_dev_project/core/repository/alarm_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:aap_dev_project/models/alarmInfo.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository alarmRepository;

  AlarmBloc({required this.alarmRepository}) : super(AlarmInitial()) {
    on<FetchAlarm>(_onFetchAlarm);
    on<SetAlarm>(_onSetAlarm);
    on<DeleteAlarm>(_onDeleteAlarm);
  }

  Future<void> _onFetchAlarm(FetchAlarm event, Emitter<AlarmState> emit) async {
    emit(AlarmLoading());
    try {
      final List<AlarmInformation> alarms =
          await alarmRepository.getUserAlarms();
      emit(AlarmLoaded(alarms: alarms));
    } catch (e) {
      emit(AlarmError(errorMsg: e.toString()));
    }
  }

  Future<void> _onSetAlarm(SetAlarm event, Emitter<AlarmState> emit) async {
    emit(AlarmSetting());
    try {
      await alarmRepository.uploadUserAlarm(event.alarmInfo);
      final List<AlarmInformation> alarms =
          await alarmRepository.getUserAlarms();
      emit(AlarmSetSuccess(alarms: alarms));
    } catch (e) {
      emit(AlarmSetError(errorMsg: e.toString()));
    }
  }

  Future<void> _onDeleteAlarm(
      DeleteAlarm event, Emitter<AlarmState> emit) async {
    emit(AlarmDeleting());
    try {
      await alarmRepository.deleteUserAlarm(event.alarmId);
      final List<AlarmInformation> alarms =
          await alarmRepository.getUserAlarms();
      emit(AlarmDeletedSuccess(alarms: alarms));
    } catch (e) {
      emit(AlarmDeleteError(errorMsg: e.toString()));
    }
  }
}
