part of 'account_information_bloc.dart';

abstract class AccountInformationEvent extends Equatable {
  const AccountInformationEvent();

  @override
  List<Object?> get props => [];
}

class EditPersonal extends AccountInformationEvent {}

class FirstNameChanged extends AccountInformationEvent {
  final String firstname;

  FirstNameChanged({
    this.firstname = "",
  });

  @override
  List<Object> get props => [
        firstname,
      ];
}

class MiddleNameChanged extends AccountInformationEvent {
  final String middlename;

  MiddleNameChanged({
    this.middlename = "",
  });

  @override
  List<Object> get props => [
        middlename,
      ];
}

class LastNameChanged extends AccountInformationEvent {
  final String lastname;

  LastNameChanged({
    this.lastname = "",
  });

  @override
  List<Object> get props => [
        lastname,
      ];
}

class DateChanged extends AccountInformationEvent {
  final DateTime? dob;

  DateChanged({
    this.dob,
  });

  @override
  List<Object?> get props => [
        dob,
      ];
}
