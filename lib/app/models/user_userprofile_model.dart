import 'dart:convert';

class AppUser {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final AppUserProfile? userprofile;

  AppUser({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.userprofile,
  });

  factory AppUser.fromRawJson(String str) => AppUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
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

class AppUserProfile {
  final String? profilePicture;
  final String? displayName;

  AppUserProfile({this.profilePicture, this.displayName});

  factory AppUserProfile.fromRawJson(String str) =>
      AppUserProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUserProfile.fromJson(Map<String, dynamic> json) => AppUserProfile(
        profilePicture: json["profile_picture"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
        "display_name": displayName,
      };
}
