import 'package:aap_dev_project/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class UserEmpty extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserProfile user;

  UserLoaded({required this.user}) : super([user]);
}

class UserError extends UserState {
  final String? errorMsg;
  UserError({this.errorMsg});
}

class UserSetting extends UserState {}

class UserSetSuccess extends UserState {}

class UserSetError extends UserState {
  final String? errorMsg;
  UserSetError({this.errorMsg});
}
