part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final String password;

  final String? errorText;

  final bool loginSucess;
  final bool? twoFARequired;
  final String? temporaryToken;

  const LoginState(
      {this.email = "",
      this.password = "",
      this.errorText = "",
      this.loginSucess = false,
      this.twoFARequired,
      this.temporaryToken});

  bool get isEmailValid => EmailValidator.validate(email);

  bool get isPasswordValid {
    return password.length > 3;
  }

  LoginState copyWith({
    String? email,
    String? password,
    String? errorText,
    bool? loginSucess,
    bool? twoFARequired,
    String? temporaryToken,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorText: errorText ?? this.errorText,
      loginSucess: loginSucess ?? this.loginSucess,
      twoFARequired: twoFARequired ?? this.twoFARequired,
      temporaryToken: temporaryToken ?? this.temporaryToken,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, errorText, loginSucess, twoFARequired];
}
