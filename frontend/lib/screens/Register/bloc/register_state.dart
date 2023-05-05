part of 'register_bloc.dart';

enum RegisterStatus {
  idle,
  submitting,
  success,
  errorUnknown,
  completeToken,
  errorEmailUsed,
  verifySuccess,
  wrongToken,
  verifying,
}

class RegisterState extends Equatable {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final DateTime? dob;
  final String? email;
  final String? password;
  final int page;
  final bool status;
  final MessageType msgType;
  final String? token;
  final String? uuid;
  final String? errorText;

  const RegisterState({
    this.page = 1,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.email,
    this.password,
    this.status = false,
    this.msgType = MessageType.idle,
    this.token,
    this.errorText,
    this.uuid,
  });

  RegisterState copyWith({
    int? page,
    String? firstName,
    String? middleName,
    String? lastName,
    DateTime? dob,
    String? email,
    String? password,
    bool? status,
    MessageType? msgType,
    String? token,
    String? errorText,
    String? uuid,
  }) {
    return RegisterState(
      page: page ?? this.page,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      msgType: msgType ?? this.msgType,
      token: token ?? this.token,
      uuid: uuid ?? this.uuid,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object?> get props => [
        page,
        firstName,
        middleName,
        lastName,
        dob,
        email,
        password,
        status,
        token,
        uuid,
        msgType,
        errorText,
      ];
}
