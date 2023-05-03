part of 'password_bloc.dart';

// enum PasswordChangeStatus {
//   idle,
//   submitting,
//   mismatch,
//   success,
//   errorPassword,
//   error,
//   empty,
//   sameError,
// }

class PasswordState extends Equatable {
  final String? currentPassword;
  final String? newPassword;
  final String? confirmPassword;
  final String? errorText;
  final bool submitStatus;
  final MessageType msgType;

  const PasswordState({
    this.currentPassword = "",
    this.newPassword = "",
    this.confirmPassword = "",
    this.errorText = "",
    this.submitStatus = false,
    this.msgType = MessageType.idle,
  });

  PasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? errorText,
    bool? submitStatus,
    MessageType? msgType,
  }) {
    return PasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      submitStatus: submitStatus ?? this.submitStatus,
      errorText: errorText ?? this.errorText,
      msgType: msgType ?? this.msgType,
    );
  }

  @override
  List<Object?> get props => [
        currentPassword,
        newPassword,
        confirmPassword,
        submitStatus,
        errorText,
        msgType,
      ];
}
