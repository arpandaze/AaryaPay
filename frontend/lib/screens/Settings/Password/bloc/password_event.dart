part of 'password_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}

class CurrentChanged extends PasswordEvent {
  final String currentPassword;

  CurrentChanged({
    this.currentPassword = "",
  });
  @override
  List<Object> get props => [
        currentPassword,
      ];
}

class NewChanged extends PasswordEvent {
  final String newPassword;

  NewChanged({
    this.newPassword = "",
  });
  @override
  List<Object> get props => [
        newPassword,
      ];
}

class ConfirmChanged extends PasswordEvent {
  final String confirmPassword;

  ConfirmChanged({
    this.confirmPassword = "",
  });
  @override
  List<Object> get props => [
        confirmPassword,
      ];
}

class PasswordChangeStatusEvent extends PasswordEvent {
  final PasswordChangeStatus status;
  PasswordChangeStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class SubmitEvent extends PasswordEvent {}
