import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/bloc/user/user_state.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final UserRepository userRepository;

//   UserBloc({required this.userRepository}) : super(UserLoading()) {
//     on<FetchUserData>((event, emit) async {
//       await getUser(emit,event.jwtToken);
//     });
//     on<SetUser>((event, emit) async {
//       await setUser(event.user,event.pass! , emit);
//     });
//   }

//   Future<void> getUser(Emitter<UserState> emit, String token) async {
//     emit(UserLoading());
//     try {
//       final UserProfile user = await userRepository.getUser(token);
//       emit(UserLoaded(user: user));
//     } catch (e) {
//       emit(UserError(errorMsg: e.toString()));
//     }
//   }

//   Future<void> setUser(UserProfile report,String password, Emitter<UserState> emit) async {
//     emit(UserSetting());

//     try {
//       await userRepository.uploadUserRecords(userp:  report,pass:  password);
//       emit(UserSetSuccess());
//     } catch (e) {
//       emit(UserSetError(errorMsg: e.toString()));
//     }
//   }
// }
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
    // Store UserProfile object in the bloc state
  UserProfile? userProfile;


  UserBloc({required this.userRepository}) : super(UserLoading()) {
    on<FetchUserData>((event, emit) async {
      await getUser(emit,event.jwtToken);
    });
    on<SetUser>((event, emit) async {
      await setUser(event.user,event.pass! , emit);
    });
  }

  Future<void> getUser(Emitter<UserState> emit, String token) async {
    emit(UserLoading());
    try {
      final UserProfile user = await userRepository.getUser(token);
      emit(UserLoaded(user: user));
    } catch (e) {
      print(e.toString());
      emit(UserError(errorMsg: e.toString()));
    }
  }

  Future<void> setUser(UserProfile report,String password, Emitter<UserState> emit) async {
    try {
      await userRepository.uploadUserRecords(userp:  report,pass:  password);
      emit(UserSetSuccess());
      userProfile = report;
    } catch (e) {
      emit(UserSetError(errorMsg: e.toString()));
    }
  }

}