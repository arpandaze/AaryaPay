part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final String? errorText;
  final VerificationStatus verificationStatus;
  final bool loginSucess;
  final bool twoFARequired;
  final String? temporaryToken;

  const LoginState({
    this.verificationStatus = VerificationStatus.unknown,
    this.email = "",
    this.password = "",
    this.errorText = "",
    this.loginSucess = false,
    this.twoFARequired = true,
    this.temporaryToken,
  });

  bool get isEmailValid => EmailValidator.validate(email);

  bool get isPasswordValid {
    return password.length > 3;
  }

  LoginState copyWith({
    VerificationStatus? verificationStatus,
    bool? twoFARequired,
    String? email,
    String? password,
    String? errorText,
    bool? loginSucess,
    String? temporaryToken,
  }) {
    return LoginState(
      verificationStatus: verificationStatus ?? this.verificationStatus,
      twoFARequired: twoFARequired ?? this.twoFARequired,
      email: email ?? this.email,
      password: password ?? this.password,
      errorText: errorText ?? this.errorText,
      loginSucess: loginSucess ?? this.loginSucess,
      temporaryToken: temporaryToken ?? this.temporaryToken,
    );
  }

  @override
  List<Object?> get props => [
        verificationStatus,
        email,
        password,
        errorText,
        loginSucess,
        temporaryToken,
      ];
}
