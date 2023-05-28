import 'dart:convert';
import 'package:aaryapay/constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:aaryapay/repository/register.dart';
import 'dart:core';

import 'package:http/http.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterRepository registerRepo = RegisterRepository();

  RegisterBloc() : super(const RegisterState()) {
    on<FirstNameChanged>(_onFirstNameChanged);
    on<MiddleNameChanged>(_onMiddleNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<DOBChanged>(_onDOBChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PageChanged>(_onPageChanged);
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<FormSubmitted>(_onFormSubmit);
    on<VerifyChanged>(_onVerifyChanged);
    on<VerifyClicked>(_onVerifyClicked);
    on<ResendVerificationClicked>(_onResendVerificationEmail);
  }

  void _onFirstNameChanged(
      FirstNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(firstName: event.firstName, msgType: MessageType.idle));
  }

  void _onMiddleNameChanged(
      MiddleNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        middleName: event.middleName, msgType: MessageType.idle));
  }

  void _onLastNameChanged(LastNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(lastName: event.lastName, msgType: MessageType.idle));
  }

  void _onDOBChanged(DOBChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(dob: event.dob, msgType: MessageType.idle));
  }

  void _onEmailChanged(EmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.email, msgType: MessageType.idle));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.password, msgType: MessageType.idle));
  }

  void _onPageChanged(PageChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(page: event.page, msgType: MessageType.idle));
  }

  void _onNextPage(NextPage event, Emitter<RegisterState> emit) {
    if (state.firstName != null && state.lastName != null) {
      emit(state.copyWith(page: state.page + 1, msgType: MessageType.idle));
    } else {
      emit(state.copyWith(
          msgType: MessageType.error,
          errorText: "First name and Last name cannot be empty"));
    }
  }

  void _onPreviousPage(PreviousPage event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        page: state.page - 1, status: false, msgType: MessageType.idle));
  }

  void _onFormSubmit(FormSubmitted event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: true));

    if (state.firstName != null &&
        state.lastName != null &&
        state.dob != null &&
        state.email != null &&
        state.password != null) {
      final registerResponse = await registerRepo.register(
          firstName: state.firstName!,
          lastName: state.lastName!,
          middleName: state.middleName ?? "",
          dob: (state.dob!.millisecondsSinceEpoch ~/ 1000).toString(),
          email: state.email!,
          password: state.password!);

      Response response = registerResponse["response"];

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 201) {
        if (response.statusCode == 409) {
          emit(state.copyWith(
              status: false,
              msgType: MessageType.error,
              errorText: "The email is already is use"));
          return;
        }
        if (response.statusCode == 400) {
          emit(state.copyWith(
              status: false,
              msgType: MessageType.error,
              errorText: "Unknown error occurred"));
          return;
        }
      }
      emit(state.copyWith(
          status: false,
          msgType: MessageType.success,
          errorText: "User successfully registered",
          uuid: decodedResponse["user_id"],
          page: state.page + 1));
    } else {
      emit(state.copyWith(
          msgType: MessageType.error,
          errorText: "The fields cannot be empty",
          status: false));
    }
  }

  void _onVerifyClicked(
      VerifyClicked event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: true));

    if (state.token != null) {
      final url = Uri.parse('$backendBase/auth/verify');
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "user_id": state.uuid!,
          "token": state.token!,
        },
      );
      if (response.statusCode != 202) {
        if (response.statusCode == 401) {
          emit(state.copyWith(
              status: false,
              msgType: MessageType.error,
              errorText: "Invalid token"));
          return;
        }
        if (response.statusCode == 500) {
          emit(state.copyWith(
              status: false,
              msgType: MessageType.error,
              errorText: "Unknown error occurred"));
          return;
        }
      }
      emit(state.copyWith(
          status: false,
          page: state.page + 1,
          msgType: MessageType.success,
          errorText: "Verified Successfully"));
    } else {
      emit(state.copyWith(
          status: false,
          msgType: MessageType.error,
          errorText: "The fields cannot be empty"));
    }
  }

  void _onVerifyChanged(VerifyChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(token: event.token, msgType: MessageType.idle));
  }

  void _onResendVerificationEmail(
      ResendVerificationClicked event, Emitter<RegisterState> emit) async {
    try {
      final url = Uri.parse('$backendBase/auth/resend-verification');

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "id": state.uuid!,
        },
      );
      emit(state.copyWith(
          msgType: MessageType.success, errorText: "Verification Email sent"));
    } catch (e) {
      emit(state.copyWith(
          msgType: MessageType.error, errorText: "Unknown error occurred"));
    }
  }
}
