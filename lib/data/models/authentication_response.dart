import 'package:flutter_example_project/data/models/user.dart';

class AuthenticationResponse {
  String? jwt;
  User? user;

  AuthenticationResponse({this.jwt, this.user});

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    jwt = json['jwt'];
    if (json["user"] != null) {
      user = User.fromJson(json["user"]);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    return map;
  }
}