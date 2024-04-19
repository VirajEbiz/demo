import 'dart:convert';

class GetuserFeedDataModel {
  final int? code;
  final String? status;
  final String? message;
  final UserFeedData? data;

  GetuserFeedDataModel({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  factory GetuserFeedDataModel.fromRawJson(String str) =>
      GetuserFeedDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetuserFeedDataModel.fromJson(Map<String, dynamic> json) =>
      GetuserFeedDataModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : UserFeedData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserFeedData {
  final int? totalSeeds;
  final int? totalPages;
  final int? currentPage;
  final bool? accountPrivacy;
  final List<SeedListData>? seeds;

  UserFeedData({
    this.totalSeeds,
    this.totalPages,
    this.currentPage,
    this.accountPrivacy,
    this.seeds,
  });

  factory UserFeedData.fromRawJson(String str) =>
      UserFeedData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserFeedData.fromJson(Map<String, dynamic> json) => UserFeedData(
        totalSeeds: json["total_seeds"],
        totalPages: json["total_pages"],
        currentPage: json["current_page"],
        accountPrivacy: json["account_privacy"],
        seeds: json["seeds"] == null
            ? []
            : List<SeedListData>.from(
                json["seeds"]!.map((x) => SeedListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_seeds": totalSeeds,
        "total_pages": totalPages,
        "current_page": currentPage,
        "account_privacy": accountPrivacy,
        "seeds": seeds == null
            ? []
            : List<dynamic>.from(seeds!.map((x) => x.toJson())),
      };
}

class SeedListData {
  final int? id;
  final String? caption;
  final bool? isPrivate;
  final String? type;
  final bool? hasBeenSeen;
  final List<MediaDatum>? mediaData;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final int? user;
  final List<dynamic>? reaction;

  SeedListData({
    this.id,
    this.caption,
    this.isPrivate,
    this.type,
    this.hasBeenSeen,
    this.mediaData,
    this.createdAt,
    this.modifiedAt,
    this.user,
    this.reaction,
  });

  factory SeedListData.fromRawJson(String str) =>
      SeedListData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SeedListData.fromJson(Map<String, dynamic> json) => SeedListData(
        id: json["id"],
        caption: json["caption"],
        isPrivate: json["is_private"],
        type: json["type"],
        hasBeenSeen: json["has_been_seen"],
        mediaData: json["media_data"] == null
            ? []
            : List<MediaDatum>.from(
                json["media_data"]!.map((x) => MediaDatum.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        modifiedAt: json["modified_at"] == null
            ? null
            : DateTime.parse(json["modified_at"]),
        user: json["user"],
        reaction: json["reaction"] == null
            ? []
            : List<dynamic>.from(json["reaction"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caption": caption,
        "is_private": isPrivate,
        "type": type,
        "has_been_seen": hasBeenSeen,
        "media_data": mediaData == null
            ? []
            : List<dynamic>.from(mediaData!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "user": user,
        "reaction":
            reaction == null ? [] : List<dynamic>.from(reaction!.map((x) => x)),
      };
}

class MediaDatum {
  final String? image;

  MediaDatum({
    this.image,
  });

  factory MediaDatum.fromRawJson(String str) =>
      MediaDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaDatum.fromJson(Map<String, dynamic> json) => MediaDatum(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}
