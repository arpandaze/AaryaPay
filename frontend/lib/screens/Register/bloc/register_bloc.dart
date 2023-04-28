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
    on<StatusChanged>(_onStatusChanged);
    on<FormSubmitted>(_onFormSubmit);
    on<VerifyChanged>(_onVerifyChanged);
    on<VerifyClicked>(_onVerifyClicked);
  }

  void _onFirstNameChanged(
      FirstNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(firstName: event.firstName));
  }

  void _onMiddleNameChanged(
      MiddleNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(middleName: event.middleName));
  }

  void _onLastNameChanged(LastNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(lastName: event.lastName));
  }

  void _onDOBChanged(DOBChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(dob: event.dob));
    print(state.dob);
  }

  void _onEmailChanged(EmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onPageChanged(PageChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(page: event.page));
  }

  void _onNextPage(NextPage event, Emitter<RegisterState> emit) {
    emit(state.copyWith(page: state.page + 1));
  }

  void _onPreviousPage(PreviousPage event, Emitter<RegisterState> emit) {
    emit(state.copyWith(page: state.page - 1, status: RegisterStatus.idle));
  }

  void _onStatusChanged(StatusChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onFormSubmit(FormSubmitted event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.submitting));

    if (state.firstName != null &&
        state.lastName != null &&
        state.dob != null &&
        state.email != null &&
        state.password != null) {
      final registerResponse = await registerRepo.register(
          firstName: state.firstName!,
          lastName: state.lastName!,
          middleName: state.middleName ?? "",
          dob: state.dob.toString(),
          email: state.email!,
          password: state.password!);

      Response response = registerResponse["response"];

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 201) {
        if (response.statusCode == 409) {
          emit(state.copyWith(status: RegisterStatus.errorEmailUsed));
          return;
        }
        if (response.statusCode == 400) {
          emit(state.copyWith(status: RegisterStatus.errorUnknown));
          return;
        }
      }
      emit(state.copyWith(
          status: RegisterStatus.success,
          uuid: decodedResponse["user_id"],
          page: state.page + 1));
    }
    emit(state.copyWith(status: RegisterStatus.errorUnknown));
  }

  void _onVerifyClicked(
      VerifyClicked event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.verifying));
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
    if (response.statusCode == 401) {
      emit(state.copyWith(status: RegisterStatus.wrongToken));
      print(response.body);
      return;
    }

    emit(state.copyWith(
        status: RegisterStatus.verifySuccess, page: state.page + 1));

    emit(state.copyWith(status: RegisterStatus.wrongToken, token: ""));
  }

  void _onVerifyChanged(VerifyChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(token: event.token));
  }
}
