part of 'forgot_bloc.dart';

class ForgotState extends Equatable {
  final String email;
  final String passOne;
  final String passTwo;
  final String? errorText;
  final ForgotStatus status;
  final String? userid;
  final bool matched;
  final String? otpToken;

  const ForgotState({
    this.otpToken,
    this.email = "",
    this.passOne = "",
    this.passTwo = "",
    this.errorText,
    this.status = ForgotStatus.initial,
    this.userid,
    this.matched = false,
  });

  ForgotState copyWith({
    String? otpToken,
    String? passOne,
    String? passTwo,
    String? email,
    String? errorText,
    ForgotStatus? status,
    String? userid,
    bool? matched,
  }) {
    return ForgotState(
      otpToken: otpToken ?? this.otpToken,
      passOne: passOne ?? this.passOne,
      passTwo: passTwo ?? this.passTwo,
      email: email ?? this.email,
      errorText: errorText ?? this.errorText,
      status: status ?? this.status,
      userid: userid ?? this.userid,
      matched: matched ?? this.matched,
    );
  }

  bool get isEmailValid => EmailValidator.validate(email);
  bool get isPasswordsValid {
    if (passOne.length > 3 && passTwo.length > 3) {
      return passOne == passTwo;
    } else {
      return false;
    }
  }

  @override
  List<Object?> get props => [
        email,
        errorText,
        status,
        userid,
        passOne,
        passTwo,
        matched,
        otpToken,
      ];
}
