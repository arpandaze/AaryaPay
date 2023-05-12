part of 'account_information_bloc.dart';

abstract class AccountInformationEvent extends Equatable {
  const AccountInformationEvent();

  @override
  List<Object?> get props => [];
}

class FirstNameChanged extends AccountInformationEvent {
  final String firstname;

  const FirstNameChanged({
    this.firstname = "",
  });

  @override
  List<Object> get props => [firstname];
}

class MiddleNameChanged extends AccountInformationEvent {
  final String middlename;

  const MiddleNameChanged({
    this.middlename = "",
  });

  @override
  List<Object> get props => [middlename];
}

class LastNameChanged extends AccountInformationEvent {
  final String lastname;

  const LastNameChanged({
    this.lastname = "",
  });

  @override
  List<Object> get props => [lastname];
}

class DateChanged extends AccountInformationEvent {
  final DateTime? dob;

  const DateChanged({
    this.dob,
  });

  @override
  List<Object?> get props => [dob];
}

class ImagePicked extends AccountInformationEvent {
  final File image;
  final String? paths;

  const ImagePicked({
    required this.image,
    required this.paths,
  });

  @override
  List<Object?> get props => [
        image,
        paths,
      ];
}

class GetPersonal extends AccountInformationEvent {}

class GetPhoto extends AccountInformationEvent {}

class EditPersonal extends AccountInformationEvent {}

class UploadPhoto extends AccountInformationEvent {}



