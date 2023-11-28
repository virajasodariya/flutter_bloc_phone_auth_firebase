import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_phone_auth_firebase/Cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;

  AuthCubit() : super(AuthInitialState()) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(AuthLogInState(firebaseUser: currentUser));
    } else {
      emit(AuthLogOutState());
    }
  }

  void sendOtp(String phoneNumber) async {
    emit(AuthLoadingState());

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        _verificationId = verificationId;
        emit(AuthCodeSentState());
      },
      verificationCompleted: (phoneAuthCredential) {
        loginWithPhone(phoneAuthCredential);
      },
      verificationFailed: (error) {
        emit(AuthErrorState(errorMessage: error.code));

        log("ERROR CODE ======== ${error.code}");
        log("ERROR MESSAGE ======== ${error.message}");
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOtp(String otp) async {
    if (_verificationId == null || otp.isEmpty) {
      emit(AuthErrorState(errorMessage: 'Invalid OTP'));
      return;
    }

    emit(AuthLoadingState());

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: otp);

      loginWithPhone(phoneAuthCredential);
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  void loginWithPhone(PhoneAuthCredential phoneAuthCredential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (userCredential.user != null) {
        emit(AuthLogInState(firebaseUser: userCredential.user!));
      }
    } on FirebaseAuthException catch (error) {
      emit(AuthErrorState(errorMessage: error.code));
    }
  }

  void logOut() async {
    await _auth.signOut();
    emit(AuthLogOutState());
  }
}
