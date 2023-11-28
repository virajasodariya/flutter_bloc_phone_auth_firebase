import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthCodeSentState extends AuthState {}

class AuthCodeVerifyState extends AuthState {}

class AuthLogInState extends AuthState {
  final User firebaseUser;

  AuthLogInState({required this.firebaseUser});
}

class AuthLogOutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState({required this.errorMessage});
}
