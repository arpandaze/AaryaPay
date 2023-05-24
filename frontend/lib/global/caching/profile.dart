import 'package:uuid/uuid.dart';

class Profile {
  UuidValue? id;
  String firstName;
  String? middleName;
  String lastName;
  DateTime dob;
  String email;

  Profile({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: UuidValue.fromList(Uuid.parse(json['id'])),
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      dob: DateTime.fromMillisecondsSinceEpoch(json['dob'] * 1000),
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'dob': dob,
      'email': email,
    };
  }
}
