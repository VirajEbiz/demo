import 'dart:convert';

import 'package:watermel/app/models/user_userprofile_model.dart';

class PeopleYouKnowDataList {
  final int? id;
  final dynamic firstName;
  final dynamic lastName;
  final String? username;
  final String? email;
  final bool? isFollowing;
  final AppUserProfile? userprofile;

  PeopleYouKnowDataList(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.userprofile,
      this.isFollowing});

  factory PeopleYouKnowDataList.fromRawJson(String str) =>
      PeopleYouKnowDataList.fromJson(json.decode(str));

  factory PeopleYouKnowDataList.fromJson(Map<String, dynamic> json) =>
      PeopleYouKnowDataList(
        id: json["id"],
        firstName: json["first_name"],
        isFollowing: json["is_following"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        userprofile: json["userprofile"] == null
            ? null
            : AppUserProfile.fromJson(json["userprofile"]),
      );
}
