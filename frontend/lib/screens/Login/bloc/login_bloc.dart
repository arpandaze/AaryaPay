import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super((const LoginState())) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<FormSubmitted>(_onFormSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onFormSubmitted(FormSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isEmailValid) {
      return emit(state.copyWith(errorText: "Invalid Username!"));
    }

    if (!state.isPasswordValid) {
      return emit(state.copyWith(errorText: "Invalid Password!"));
    }

    try{
      final loginResponse = await auth.login(username: state.email, password: state.password);
      
    }
    //send login request and cchange parameters that way
  }
}
