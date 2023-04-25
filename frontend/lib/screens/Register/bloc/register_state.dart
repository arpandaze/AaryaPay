part of 'register_bloc.dart';

enum RegisterStatus {
  idle,
  submitting,
  success,
  errorUnknown,
  errorPassword,
  errorEmailUsed,
}

class RegisterState extends Equatable {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final DateTime? dob;
  final String? email;
  final String? password;
  final int page;
  final RegisterStatus status;
  final int? token;

  const RegisterState({
    this.page = 1,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.email,
    this.password,
    this.status = RegisterStatus.idle,
    this.token,
  });

  RegisterState copyWith({
    int? page,
    String? firstName,
    String? middleName,
    String? lastName,
    DateTime? dob,
    String? email,
    String? password,
    RegisterStatus? status,
    int? token,
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
      token: token ?? this.token,
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
      ];
}
