part of 'login_verify_bloc.dart';

enum LoginVerifyStatus {
  none,
  error,
  errorUnknown,
  completed,
  submitted,
  verified,
}

class LoginVerifyState extends Equatable {
  final String verifyToken;
  final LoginVerifyStatus status;
  final String errorText;

  const LoginVerifyState({
    this.verifyToken = "",
    this.status = LoginVerifyStatus.none,
    this.errorText = "",
  });

  LoginVerifyState copywith({
    verifyToken,
    status,
    errorText,
  }) {
    return LoginVerifyState(
      verifyToken: verifyToken ?? this.verifyToken,
      status: status ?? this.status,
      errorText: errorText ?? this.errorText,
    );
  }

  // const LoginVerifyState({});
  @override
  List<Object?> get props => [verifyToken, status, errorText];
}
