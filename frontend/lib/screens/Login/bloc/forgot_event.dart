part of 'forgot_bloc.dart';

abstract class ForgotEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotEmailChanged extends ForgotEvent {
  final String? email;

  ForgotEmailChanged({this.email});

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordOneChanged extends ForgotEvent {
  final String? pass;

  ForgotPasswordOneChanged({this.pass});

  @override
  List<Object?> get props => [pass];
}

class ForgotPasswordTwoChanged extends ForgotEvent {
  final String? pass;

  ForgotPasswordTwoChanged({this.pass});

  @override
  List<Object?> get props => [pass];
}

class SendEmail extends ForgotEvent {}

class CheckMatching extends ForgotEvent {}

class TokenChanged extends ForgotEvent {
  final String? otpToken;

  TokenChanged({this.otpToken});

  @override
  List<Object?> get props => [otpToken];
}

class SubmitOTP extends ForgotEvent {
  final String? userid;
  final String? password;

  SubmitOTP({this.userid, this.password});

  @override
  List<Object?> get props => [userid, password];
}
