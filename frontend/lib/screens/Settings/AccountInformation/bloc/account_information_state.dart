part of 'account_information_bloc.dart';

class AccountInformationState extends Equatable {
  final Map<String, dynamic>? profileInfo;
  final String firstname;
  final String middlename;
  final String lastname;
  final DateTime? dob;

  const AccountInformationState({
    this.firstname = "",
    this.middlename = "",
    this.lastname = "",
    this.dob,
    this.profileInfo,
  });

  AccountInformationState copyWith({
    String? firstname,
    String? middlename,
    String? lastname,
    DateTime? dob,
    Map<String, dynamic>? profileInfo,
  }) {
    return AccountInformationState(
      firstname: firstname ?? this.firstname,
      middlename: middlename ?? this.middlename,
      lastname: lastname ?? this.middlename,
      dob: dob ?? this.dob,
      profileInfo: profileInfo ?? this.profileInfo,
    );
  }

  @override
  List<Object?> get props => [
        firstname,
        middlename,
        lastname,
        dob,
        profileInfo,
      ];
}
