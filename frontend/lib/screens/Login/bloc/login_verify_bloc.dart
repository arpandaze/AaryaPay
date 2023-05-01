import 'package:aaryapay/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:aaryapay/repository/auth.dart';

part 'login_verify_event.dart';
part 'login_verify_state.dart';

class LoginVerifyBloc extends Bloc<LoginVerifyEvent, LoginVerifyState> {
  LoginVerifyBloc() : super(LoginVerifyState()) {
    on<UnverifiedLogin>(_onUnverifiedLogin);
  }
  void _onUnverifiedLogin(
      UnverifiedLogin event, Emitter<LoginVerifyState> emit) {}
}
