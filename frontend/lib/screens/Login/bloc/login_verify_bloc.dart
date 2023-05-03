import 'dart:convert';
import 'package:aaryapay/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

part 'login_verify_event.dart';
part 'login_verify_state.dart';

class LoginVerifyBloc extends Bloc<LoginVerifyEvent, LoginVerifyState> {
  static const storage = FlutterSecureStorage();

  LoginVerifyBloc() : super(const LoginVerifyState()) {
    on<VerifyTokenChanged>(_onVerifyTokenChanged);
    on<VerifyFormSubmitted>(_onVerifyFormSubmitted);
    on<ResendVerificationEmail>(_onResendVerificationEmail);
  }

  void _onVerifyTokenChanged(
      VerifyTokenChanged event, Emitter<LoginVerifyState> emit) {
    if (event.completed) {
      emit(state.copywith(
          verifyToken: event.verifyToken, status: LoginVerifyStatus.completed));
    }
  }

  void _onVerifyFormSubmitted(
      VerifyFormSubmitted event, Emitter<LoginVerifyState> emit) async {
    if (state.status == LoginVerifyStatus.none) {
      return;
    }

    final url = Uri.parse('$backendBase/auth/verify');

    final userID = await storage.read(key: "user_id");
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        "user_id": userID,
        "token": state.verifyToken,
      },
    );

    emit(state.copywith(status: LoginVerifyStatus.submitted));

    if (response.statusCode == 202) {
      emit(state.copywith(
          status: LoginVerifyStatus.verified,
          errorText: "Verified Successfully"));
      return;
    } else if (response.statusCode == 500) {
      emit(state.copywith(
          status: LoginVerifyStatus.errorUnknown,
          errorText: "Internal server error"));
    }

    emit(state.copywith(
        status: LoginVerifyStatus.error,
        errorText: "Error! Wrong verification token"));
  }

  void _onResendVerificationEmail(
      ResendVerificationEmail event, Emitter<LoginVerifyState> emit) async {
    final url = Uri.parse('$backendBase/auth/resend-verification');
    final userID = await storage.read(key: "user_id");

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        "id": userID,
      },
    );
  }
}
