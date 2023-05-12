part of 'account_information_bloc.dart';

class AccountInformationState extends Equatable {
  final Map<String, dynamic>? profileInfo;
  final String firstname;
  final String middlename;
  final String lastname;
  final DateTime? dob;
  final File? image;
  final String? paths;
  final String photoUrl;
  final MessageType msgType;
  final String errorText;
  final bool success;

  const AccountInformationState({
    this.firstname = "",
    this.middlename = "",
    this.lastname = "",
    this.dob,
    this.profileInfo,
    this.image,
    this.paths = "",
    this.photoUrl = "",
    this.msgType = MessageType.idle,
    this.errorText = "",
    this.success = false,
  });

  AccountInformationState copyWith({
    String? firstname,
    String? middlename,
    String? lastname,
    DateTime? dob,
    Map<String, dynamic>? profileInfo,
    File? image,
    String? paths,
    String? photoUrl,
    MessageType? msgType,
    String? errorText,
    bool? success,
  }) {
    return AccountInformationState(
      firstname: firstname ?? this.firstname,
      middlename: middlename ?? this.middlename,
      lastname: lastname ?? this.lastname,
      dob: dob ?? this.dob,
      profileInfo: profileInfo ?? this.profileInfo,
      image: image ?? this.image,
      paths: paths ?? this.paths,
      photoUrl: photoUrl ?? this.photoUrl,
      msgType: msgType ?? this.msgType,
      errorText: errorText ?? this.errorText,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [
        firstname,
        middlename,
        lastname,
        dob,
        profileInfo,
        image,
        paths,
        photoUrl,
        msgType,
        errorText,
        success,
      ];
}
