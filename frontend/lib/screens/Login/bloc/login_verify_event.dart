part of 'login_verify_bloc.dart';

abstract class LoginVerifyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnverifiedLogin extends LoginVerifyEvent {}
