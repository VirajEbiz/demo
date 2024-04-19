import 'dart:convert';
import 'package:get/get.dart';
import 'package:watermel/app/models/media_data_model.dart';
import 'package:watermel/app/models/user_userprofile_model.dart';

class FeedListData {
  final int? id;
  final int? viewCount;
  final AppUser? user;
  final AppUser? owner;
  String? shareURL;
  final String? caption;
  final bool? isPrivate;
  final String? type;
  final List<MediaDatum>? mediaData;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  int? reactionsCount;
  int? commentsCount;
  dynamic myReaction;
  bool? bookmark;
  final List<dynamic>? topReactions;
  dynamic videoFrame;
  RxBool? isMore;
  String? thumbnailURL;
  final List<CaptionHistory>? captionHistory;

  FeedListData(
      {this.id,
      this.viewCount,
      this.user,
      this.owner,
      this.caption,
      this.isPrivate,
      this.type,
      this.mediaData,
      this.createdAt,
      this.modifiedAt,
      this.reactionsCount,
      this.shareURL,
      this.commentsCount,
      this.myReaction,
      this.isMore,
      this.bookmark,
      this.thumbnailURL,
      this.topReactions,
      this.captionHistory,
      this.videoFrame});

  factory FeedListData.fromRawJson(String str) =>
      FeedListData.fromJson(json.decode(str));

  factory FeedListData.fromJson(Map<String, dynamic> json) => FeedListData(
        id: json["id"],
        viewCount: json["view_count"],
        user: json["user"] == null ? null : AppUser.fromJson(json["user"]),
        owner: json["owner"] == null ? null : AppUser.fromJson(json["owner"]),
        shareURL: json["share_url"] ?? "",
        caption: json["caption"],
        isPrivate: json["is_private"],
        type: json["type"] ?? "",
        mediaData: json["media_data"] == null || json["media_data"] == []
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
        thumbnailURL: json["thumbnail_url"],
        videoFrame: "",
        isMore: true.obs,
        captionHistory: json["caption_history"] == null
            ? []
            : List<CaptionHistory>.from(json["caption_history"]!
                .map((x) => CaptionHistory.fromJson(x))),
        topReactions: json["top_reactions"] == null
            ? []
            : List<dynamic>.from(json["top_reactions"]!.map((x) => x)),
      );
}

enum Type { READ, WATCH, PODCAST }

class CaptionHistory {
  final int? userId;
  final String? userName;
  final String? userProfileUrl;
  final String? userPostCaption;
  final DateTime? createdAt;

  CaptionHistory(
      {this.userId,
      this.userName,
      this.userProfileUrl,
      this.userPostCaption,
      this.createdAt});

  factory CaptionHistory.fromRawJson(String str) =>
      CaptionHistory.fromJson(json.decode(str));

  factory CaptionHistory.fromJson(Map<String, dynamic> json) => CaptionHistory(
        userId: json["user_id"],
        userName: json["user_name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        userProfileUrl: json["user_profile_url"],
        userPostCaption: json["user_post_caption"],
      );
}
