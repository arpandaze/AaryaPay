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
    print("Verify Tapped");
    // emit(state.copyWith(status: RegisterStatus.verifying));
    if (state.status == LoginVerifyStatus.none) {
      // return emit(state.copyWith(errorText: "Invalid Username!"));
      return;
    }
    print("Verify Status Good");

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
      emit(state.copywith(status: LoginVerifyStatus.verified));
      return;
    }

    emit(state.copywith(status: LoginVerifyStatus.none));

    // emit(state.copyWith(
    //     status: RegisterStatus.verifySuccess, page: state.page + 1));

    // emit(state.copyWith(status: RegisterStatus.wrongToken, token: ""));;
  }

  void _onResendVerificationEmail(
      ResendVerificationEmail event, Emitter<LoginVerifyState> emit) async {
    print("Resend");
    final url = Uri.parse('$backendBase/auth/resend-verification');
    final userID = await storage.read(key: "user_id");
    print(userID);

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

    print(response.body);
    print(response.statusCode);
  }
}
