part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserProfileIncomplete extends UserState {
  final User firebaseUser;
  const UserProfileIncomplete(this.firebaseUser);
}

class UserAuthenticated extends UserState {
  final UserModel user;
  const UserAuthenticated(this.user);
}

class UserUnauthenticated extends UserState {}