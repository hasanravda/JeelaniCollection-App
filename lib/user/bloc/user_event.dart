part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class CheckUserLogin extends UserEvent {}

class UserLoggedIn extends UserEvent {
  final UserModel user;
  const UserLoggedIn(this.user);
}

class UserLoggedOut extends UserEvent {}