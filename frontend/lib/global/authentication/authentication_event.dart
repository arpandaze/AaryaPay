part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class LoadAuthStatus extends AuthenticationEvent {}

class TwoFA extends AuthenticationEvent {}
