import 'dart:convert';

import 'package:watermel/app/models/media_data_model.dart';
import 'package:watermel/app/models/user_userprofile_model.dart';

class ProfilePostDetailData {
  final int? id;
  final AppUser? user;
  final String? shareURl;
  final String? caption;
  final bool? isPrivate;
  final String? type;
  List<MediaDatum>? mediaData;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  int? reactionsCount;
  int? commentsCount;
  dynamic myReaction;
  bool? bookmark;
  String? thumbURl;
  final List<dynamic>? topReactions;

  ProfilePostDetailData({
    this.id,
    this.user,
    this.caption,
    this.isPrivate,
    this.type,
    this.thumbURl,
    this.mediaData,
    this.createdAt,
    this.modifiedAt,
    this.shareURl,
    this.reactionsCount,
    this.commentsCount,
    this.myReaction,
    this.bookmark,
    this.topReactions,
  });

  factory ProfilePostDetailData.fromRawJson(String str) =>
      ProfilePostDetailData.fromJson(json.decode(str));

  factory ProfilePostDetailData.fromJson(Map<String, dynamic> json) =>
      ProfilePostDetailData(
        id: json["id"],
        user: json["user"] == null ? null : AppUser.fromJson(json["user"]),
        shareURl: json["share_url"] ?? "",
        thumbURl: json["thumbnail_url"],
        caption: json["caption"],
        isPrivate: json["is_private"],
        type: json["type"],
        mediaData: json["media_data"] == [] || json["media_data"] == null
            ? []
            : List<MediaDatum>.from(
                json["media_data"]!.map((x) => MediaDatum.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        reactionsCount: json["reactions_count"],
        commentsCount: json["comments_count"],
        myReaction: json["my_reaction"],
        bookmark: json["bookmark"],
        topReactions:
            json["top_reactions"] == [] || json["top_reactions"] == null
                ? []
                : List<dynamic>.from(json["top_reactions"]!.map((x) => x)),
      );
}
