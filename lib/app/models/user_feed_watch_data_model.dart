import 'dart:convert';

class WatchSeedDataList {
  final int? id;
  final String? caption;
  final bool? isPrivate;
  final Type? type;
  final bool? hasBeenSeen;
  final List<MediaDatum>? mediaData;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String? thumbnailURL;
  final int? user;
  final List<dynamic>? reaction;
  dynamic videoFrame;

  WatchSeedDataList(
      {this.id,
      this.caption,
      this.isPrivate,
      this.type,
      this.hasBeenSeen,
      this.thumbnailURL,
      this.mediaData,
      this.createdAt,
      this.modifiedAt,
      this.user,
      this.reaction,
      this.videoFrame});

  factory WatchSeedDataList.fromRawJson(String str) =>
      WatchSeedDataList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WatchSeedDataList.fromJson(Map<String, dynamic> json) =>
      WatchSeedDataList(
          id: json["id"],
          caption: json["caption"],
          isPrivate: json["is_private"],
          type: typeValues.map[json["type"]]!,
          hasBeenSeen: json["has_been_seen"],
          thumbnailURL: json["thumbnail_url"],
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
          videoFrame: "");

  Map<String, dynamic> toJson() => {
        "id": id,
        "caption": caption,
        "is_private": isPrivate,
        "type": typeValues.reverse[type],
        "has_been_seen": hasBeenSeen,
        "thumbnail_url": thumbnailURL,
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
  final String? video;

  MediaDatum({
    this.video,
  });

  factory MediaDatum.fromRawJson(String str) =>
      MediaDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaDatum.fromJson(Map<String, dynamic> json) => MediaDatum(
        video: json["video"],
      );

  Map<String, dynamic> toJson() => {
        "video": video,
      };
}

enum Type { WATCH }

final typeValues = EnumValues({"watch": Type.WATCH});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
