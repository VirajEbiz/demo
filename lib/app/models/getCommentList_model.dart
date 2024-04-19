import 'dart:convert';

import 'package:get/get.dart';
import 'package:watermel/app/models/user_userprofile_model.dart';

class GetCommentListDataModel {
  final AppUser? user;
  int? commentID;
  final String? comment;
  dynamic commentReactionCount;
  dynamic userReaction;
  final List<AppUser>? cloner;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  GetCommentListDataModel({
    this.user,
    this.comment,
    this.commentID,
    this.commentReactionCount,
    this.userReaction,
    this.cloner,
    this.createdAt,
    this.modifiedAt,
  });

  factory GetCommentListDataModel.fromRawJson(String str) =>
      GetCommentListDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCommentListDataModel.fromJson(Map<String, dynamic> json) =>
      GetCommentListDataModel(
        user: json["user"] == null ? null : AppUser.fromJson(json["user"]),
        commentID: json["id"],
        comment: json["comment"],
        commentReactionCount: json["comment_reactions"],
        userReaction: json["user_reaction"],
        cloner: json["cloner"] == null
            ? []
            : List<AppUser>.from(
                json["cloner"]!.map((x) => AppUser.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "comment": comment,
        "comment_reactions": commentReactionCount,
        "cloner": cloner == null
            ? []
            : List<dynamic>.from(cloner!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
      };
}

// class AppUser {
//   final int? id;
//   final String? firstName;
//   final String? lastName;
//   final String? username;
//   final String? email;
//   final Userprofile? userprofile;

//   AppUser({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.username,
//     this.email,
//     this.userprofile,
//   });

//   factory AppUser.fromRawJson(String str) => AppUser.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
//         id: json["id"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         username: json["username"],
//         email: json["email"],
//         userprofile: json["userprofile"] == null
//             ? null
//             : Userprofile.fromJson(json["userprofile"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "first_name": firstName,
//         "last_name": lastName,
//         "username": username,
//         "email": email,
//         "userprofile": userprofile?.toJson(),
//       };
// }

// class Userprofile {
//   final String? profilePicture;
//   final String? displasyName;

//   Userprofile({this.profilePicture, this.displasyName});

//   factory Userprofile.fromRawJson(String str) =>
//       Userprofile.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Userprofile.fromJson(Map<String, dynamic> json) => Userprofile(
//         profilePicture: json["profile_picture"],
//         displasyName: json["display_name"],
//       );

//   Map<String, dynamic> toJson() =>
//       {"profile_picture": profilePicture, "display_name": displasyName};
// }
