import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:aaryapay/repository/register.dart';
import 'dart:core';

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
    emit(state.copyWith(page: state.page - 1));
  }

  void _onStatusChanged(StatusChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onFormSubmit(FormSubmitted event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.submitting));
    // var date = DateTime(int.parse(state.dob['year']), state.dob!['month'], state.dob!['day']);


    // String dobString = '${dob!['year']}-${dob['month']}-${dob['day']}';
    //
    // final data = {
    //   "firstName": state.firstName!,
    //   "lastName": state.lastName!,
    //   "middleName": state.middleName,
    //   "dob": dobString,
    //   "email": state.email!,
    //   "password": state.password!
    // };
    // print(data);
    //
    // final registerResponse = await registerRepo.register(
    //     firstName: state.firstName!,
    //     lastName: state.lastName!,
    //     middleName: state.middleName ?? "",
    //     dob: dobString,
    //     email: state.email!,
    //     password: state.password!);
    //
    // print(registerResponse);
  }

  void _onVerifyChanged(VerifyChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(token: event.token));
  }
}
