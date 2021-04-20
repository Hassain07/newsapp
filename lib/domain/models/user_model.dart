import 'dart:convert';

import 'package:newsapp/domain/models/location_model.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final UserLocation location;
  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'location': location.toMap(),
    };
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      username: map['username'],
      email: map['email'],
      location: UserLocation.fromMap(map['location']),
    );
  }

  // String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
