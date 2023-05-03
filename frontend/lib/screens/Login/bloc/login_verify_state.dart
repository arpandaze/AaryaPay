part of 'login_verify_bloc.dart';

enum LoginVerifyStatus {
  none,
  completed,
  submitted,
  verified,
}

class LoginVerifyState extends Equatable {
  final String verifyToken;
  final LoginVerifyStatus status;

  const LoginVerifyState({
    this.verifyToken = "",
    this.status = LoginVerifyStatus.none,
  });

  LoginVerifyState copywith({verifyToken, status}) {
    return LoginVerifyState(
      verifyToken: verifyToken ?? this.verifyToken,
      status: status ?? this.status,
    );
  }

  // const LoginVerifyState({});
  @override
  List<Object?> get props => [verifyToken, status];
}
