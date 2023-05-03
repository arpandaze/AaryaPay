part of 'password_bloc.dart';

enum PasswordChangeStatus {
  idle,
  submitting,
  mismatch,
  success,
  errorPassword,
  error,
  empty,
  sameError,
}

class PasswordState extends Equatable {
  final String? currentPassword;
  final String? newPassword;
  final String? confirmPassword;
  final String? errorText;
  final PasswordChangeStatus status;
  final MessageType msgType;

  const PasswordState({
    this.currentPassword = "",
    this.newPassword = "",
    this.confirmPassword = "",
    this.errorText = "",
    this.status = PasswordChangeStatus.idle,
    this.msgType = MessageType.error,
  });

  PasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? errorText,
    PasswordChangeStatus? status,
    MessageType? msgType,
  }) {
    return PasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      errorText: errorText ?? this.errorText,
      msgType: msgType ?? this.msgType,
    );
  }

  @override
  List<Object?> get props => [
        currentPassword,
        newPassword,
        confirmPassword,
        status,
        errorText,
        msgType,
      ];
}
