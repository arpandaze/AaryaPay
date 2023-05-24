import 'package:uuid/uuid.dart';

class Favorite {
  UuidValue? id;
  String firstName;
  String? middleName;
  String lastName;
  String email;
  DateTime dateAdded;

  Favorite({
    this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    required this.dateAdded,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: UuidValue.fromList(Uuid.parse(json['id'])),
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      email: json['email'],
      dateAdded: DateTime.fromMillisecondsSinceEpoch(json['date_added'] * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'date_added': dateAdded.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
