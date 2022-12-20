import 'package:ezlogin/ezlogin.dart';

class MainUser extends EzLoginUser {
  final String firstName;
  final String lastName;
  final String notes;

  MainUser({
    required this.firstName,
    required this.lastName,
    required super.email,
    required super.userType,
    required super.shouldChangePassword,
    required this.notes,
    super.id,
  });
  MainUser.fromSerialized(map)
      : firstName = map['firstName'],
        lastName = map['lastName'],
        notes = map['notes'],
        super.fromSerialized(map);

  @override
  Map<String, dynamic> serializedMap() {
    return super.serializedMap()
      ..addAll({
        'firstName': firstName,
        'lastName': lastName,
        'notes': notes,
      });
  }

  @override
  MainUser deserializeItem(map) {
    return MainUser.fromSerialized(map);
  }

  @override
  EzLoginUser copyWith({
    String? firstName,
    String? lastName,
    String? email,
    EzloginUserType? userType,
    bool? shouldChangePassword,
    String? notes,
    String? id,
  }) {
    firstName ??= this.firstName;
    lastName ??= this.lastName;
    email ??= this.email;
    userType ??= this.userType;
    shouldChangePassword ??= this.shouldChangePassword;
    notes ??= this.notes;
    id ??= this.id;
    return MainUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      userType: userType,
      shouldChangePassword: shouldChangePassword,
      notes: notes,
      id: id,
    );
  }
}
