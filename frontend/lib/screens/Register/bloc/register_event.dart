part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FirstNameChanged extends RegisterEvent {
  final String? firstName;
  FirstNameChanged({this.firstName});

  @override
  List<Object?> get props => [firstName];
}

class MiddleNameChanged extends RegisterEvent {
  final String? middleName;
  MiddleNameChanged({this.middleName});

  @override
  List<Object?> get props => [middleName];
}

class LastNameChanged extends RegisterEvent {
  final String? lastName;
  LastNameChanged({this.lastName});

  @override
  List<Object?> get props => [lastName];
}

class DOBChanged extends RegisterEvent {
  final DateTime? dob;
  DOBChanged({this.dob});

  @override
  List<Object?> get props => [dob];
}

class EmailChanged extends RegisterEvent {
  final String? email;
  EmailChanged({this.email});

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends RegisterEvent {
  final String? password;
  PasswordChanged({this.password});

  @override
  List<Object?> get props => [password];
}

class StatusChanged extends RegisterEvent {
  final RegisterStatus status;
  StatusChanged({required this.status});

  @override
  List<Object?> get props => [status];
}

class PageChanged extends RegisterEvent {
  final int page;
  PageChanged({required this.page});

  @override
  List<Object?> get props => [page];
}

class VerifyChanged extends RegisterEvent {
  final String token;
  VerifyChanged({required this.token});

  @override
  List<Object?> get props => [token];
}

class NextPage extends RegisterEvent {}

class PreviousPage extends RegisterEvent {}

class FormSubmitted extends RegisterEvent {}

class VerifyClicked extends RegisterEvent {}

class ResendVerificationClicked extends RegisterEvent {}
