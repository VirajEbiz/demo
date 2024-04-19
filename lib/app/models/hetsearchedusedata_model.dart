import 'dart:convert';

import 'package:watermel/app/models/user_userprofile_model.dart';

class SearchedUserDataList {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final AppUserProfile? userprofile;

  SearchedUserDataList({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.userprofile,
  });

  factory SearchedUserDataList.fromRawJson(String str) =>
      SearchedUserDataList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchedUserDataList.fromJson(Map<String, dynamic> json) =>
      SearchedUserDataList(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        userprofile: json["userprofile"] == null
            ? null
            : AppUserProfile.fromJson(json["userprofile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "userprofile": userprofile?.toJson(),
      };
}
