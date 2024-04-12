import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_auth/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit() : super(AuthInitialState()){
      User? currentUser = _auth.currentUser;
      if(currentUser != null){
        emit(AuthLoggedInState(currentUser));
      }else{
                emit(AuthLoggedOutState());

      }
  }
  String _verificationId = '';

  void sendOTP(String phoneNumber) async {
    emit(AuthLoadingState());
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: ((verificationId, forceResendingToken) {
        _verificationId = verificationId;
        emit(AuthCodeSentState());
        print("Code sent");
      }),
      verificationCompleted: (phoneAuthCredential) {
        signInWithPhone(phoneAuthCredential);
      },
      verificationFailed: (error) {
        emit(AuthErrorState(error.toString()));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOTP(String phoneNumber) async {
    emit(AuthLoadingState());
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: phoneNumber);
    signInWithPhone(phoneAuthCredential);
  }

  void signInWithPhone(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (_auth.currentUser != null) {
        emit(AuthLoggedInState(userCredential.user!));
      } else {
        emit(AuthErrorState("Error"));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }

  void logout() async {
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }
}
