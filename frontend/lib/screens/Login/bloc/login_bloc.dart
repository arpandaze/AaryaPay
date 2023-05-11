import 'package:aaryapay/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:aaryapay/repository/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthenticationRepository authRepo = AuthenticationRepository();
  LoginBloc() : super((const LoginState())) {
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
    on<LoginFormSubmitted>(_onLoginFormSubmitted);
    on<ResetLogin>(_onResetLogin);
    add(ResetLogin());
  }

  void _onLoginEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onLoginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onLoginFormSubmitted(
      LoginFormSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
      verificationStatus: VerificationStatus.initial,
      status: LoginStatus.initial,
    ));

    if (!state.isEmailValid) {
      return emit(state.copyWith(
          errorText: "Invalid Username!",
          verificationStatus: VerificationStatus.error));
    }
    if (!state.isPasswordValid) {
      return emit(
        state.copyWith(
            errorText: "Invalid Password!",
            verificationStatus: VerificationStatus.error),
      );
    }
    emit(state.copyWith(status: LoginStatus.onprocess));
    try {
      final loginResponse =
          await authRepo.login(email: state.email, password: state.password);

      if (loginResponse["mismatch"] == true) {
        emit(state.copyWith(
          verificationStatus: VerificationStatus.error,
          errorText: loginResponse["response"]["msg"],
          status: LoginStatus.faliure,
        ));
      } else if (loginResponse["verification"] == false) {
        emit(state.copyWith(
          verificationStatus: VerificationStatus.unverified,
          errorText: "Unverified User",
          status: LoginStatus.faliure,
        ));
      } else if (loginResponse["verification"] == true) {
        if (loginResponse["two_fa_required"] == true) {
          emit(state.copyWith(
            verificationStatus: VerificationStatus.twofa,
            status: LoginStatus.initial,
          ));
        } else {
          emit(state.copyWith(
            loginSucess: true,
            verificationStatus: VerificationStatus.verified,
            status: LoginStatus.success,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        errorText: "Email or Password incorrect!",
        verificationStatus: VerificationStatus.error,
      ));
    }
    //send login request and cchange parameters that way
  }

  void _onResetLogin(ResetLogin event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
