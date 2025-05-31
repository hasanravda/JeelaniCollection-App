import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<CheckUserLogin>(_onCheckUserLogin);
    on<UserLoggedIn>(_onUserLoggedIn);
    on<UserLoggedOut>(_onUserLoggedOut);
  }

  void _onCheckUserLogin(CheckUserLogin event, Emitter<UserState> emit) async {
    // Check from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      // Check if user document exists
      if (userDoc.exists) {
        final userModel = UserModel.fromMap(userDoc.data()!);
        emit(UserAuthenticated(userModel));
      } else {
        emit(UserUnauthenticated());
      }
    } else {
      emit(UserUnauthenticated());
    }
  }

  void _onUserLoggedIn(UserLoggedIn event, Emitter<UserState> emit) {
    emit(UserAuthenticated(event.user));  
  }

  void _onUserLoggedOut(UserLoggedOut event, Emitter<UserState> emit) async {
    await FirebaseAuth.instance.signOut();
    emit(UserUnauthenticated());
  }
  

}
