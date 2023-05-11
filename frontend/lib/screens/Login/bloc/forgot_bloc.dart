import 'dart:convert';

import 'package:aaryapay/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'forgot_event.dart';
part 'forgot_state.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  final client = http.Client();

  ForgotBloc() : super(const ForgotState()) {
    on<SendEmail>(_onSendEmail);
    on<ForgotEmailChanged>(_onForgotEmailChanged);
    on<ForgotPasswordOneChanged>(_onFogotPasswordOneChanged);
    on<ForgotPasswordTwoChanged>(_onFogotPasswordTwoChanged);
    on<CheckMatching>(_onCheckMatching);
    on<TokenChanged>(_onTokenChanged);
    on<SubmitOTP>(_onSubmitOTP);
  }

  void _onTokenChanged(TokenChanged event, Emitter<ForgotState> emit) {
    emit(state.copyWith(otpToken: event.otpToken));
  }

  void _onSubmitOTP(SubmitOTP event, Emitter<ForgotState> emit) async {
    emit(state.copyWith(status: ForgotStatus.otpOnProcess));

    if (event.userid != null &&
        event.password != null &&
        state.otpToken != null) {
      final url = Uri.parse('$backendBase/auth/password-recovery-reset');

      var response = await http.post(
        url,
        body: {
          "id": event.userid,
          "token": state.otpToken,
          "new_password": event.password,
        },
      );
      if (response.statusCode == 202) {
        emit(state.copyWith(status: ForgotStatus.otpSuccess));
        emit(state.copyWith(status: ForgotStatus.initial));
        return;
      }
    }
    emit(state.copyWith(
        status: ForgotStatus.error, errorText: "Error with OTP"));
    emit(state.copyWith(status: ForgotStatus.initial));
  }

  void _onForgotEmailChanged(
      ForgotEmailChanged event, Emitter<ForgotState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onFogotPasswordOneChanged(
      ForgotPasswordOneChanged event, Emitter<ForgotState> emit) {
    emit(state.copyWith(passOne: event.pass));
  }

  void _onFogotPasswordTwoChanged(
      ForgotPasswordTwoChanged event, Emitter<ForgotState> emit) {
    emit(state.copyWith(passTwo: event.pass));
  }

  void _onCheckMatching(CheckMatching event, Emitter<ForgotState> emit) {
    emit(state.copyWith(matched: state.isPasswordsValid));
    emit(state.copyWith(matched: false));
  }

  void _onSendEmail(SendEmail event, Emitter<ForgotState> emit) async {
    emit(state.copyWith(status: ForgotStatus.initial));

    if (!state.isEmailValid) {
      emit(
        state.copyWith(errorText: "Invalid Email!", status: ForgotStatus.error),
      );
    } else {
      final url = Uri.parse('$backendBase/auth/password-recovery');
      emit(state.copyWith(status: ForgotStatus.onprocess));

      var response = await http.post(
        url,
        body: {
          "email": state.email,
        },
      );

      if (response.statusCode == 202) {
        emit(state.copyWith(
            status: ForgotStatus.success,
            userid: jsonDecode(response.body)["id"]));
      } else {
        emit(state.copyWith(
            status: ForgotStatus.error, errorText: "Email Could Not be Sent"));
      }
    }
    emit(state.copyWith(status: ForgotStatus.initial));
  }
}
