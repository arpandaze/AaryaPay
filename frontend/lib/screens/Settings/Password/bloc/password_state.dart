part of 'password_bloc.dart';

enum PasswordChangeStatus {
  idle,
  submitting,
  mismatch,
  success,
  error,
  empty,
}

class PasswordState extends Equatable {
  final String? currentPassword;
  final String? newPassword;
  final String? confirmPassword;
  final PasswordChangeStatus status;

  const PasswordState({
    this.currentPassword = "",
    this.newPassword = "",
    this.confirmPassword = "",
    this.status = PasswordChangeStatus.idle,
  });

  PasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    PasswordChangeStatus? status,
  }) {
    return PasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        currentPassword,
        newPassword,
        confirmPassword,
        status,
      ];
}
