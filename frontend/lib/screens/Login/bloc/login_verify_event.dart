part of 'login_verify_bloc.dart';

abstract class LoginVerifyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyTokenChanged extends LoginVerifyEvent {
  final String verifyToken;
  final bool completed;

  VerifyTokenChanged(this.verifyToken, this.completed);

  @override
  List<Object?> get props => [verifyToken, completed];
}

class VerifyFormSubmitted extends LoginVerifyEvent {}

class ResendVerificationEmail extends LoginVerifyEvent {}
