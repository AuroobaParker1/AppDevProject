import 'package:aap_dev_project/models/user.dart';

// abstract class UserEvent extends Equatable {
//   const UserEvent([List props = const []]) : super();
// }

// class FetchUserData extends UserEvent {
//   final String jwtToken;
//   const FetchUserData({required String this.jwtToken}) : super();

//   @override
//   List<Object?> get props => throw UnimplementedError();
// }

// class SetUser extends UserEvent {
//   final UserProfile user;
//   final String? pass;

//   const SetUser({required this.user,this.pass});

//   @override
//   List<Object> get props => [user];
// }
abstract class UserEvent {

}
class FetchUserData extends UserEvent {
  final String jwtToken;
  FetchUserData({required String this.jwtToken}) : super();

}
class SetUser extends UserEvent {
  final UserProfile user;
  final String? pass;

   SetUser({required this.user,this.pass});

}
