import 'dart:convert';

class PodcastSeedDataList {
  final int? id;
  final String? caption;
  final bool? isPrivate;
  final String? type;
  final bool? hasBeenSeen;
  final List<MediaDatum>? mediaData;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String? thumnailURL;
  final int? user;
  final List<dynamic>? reaction;
  dynamic videoFrame;

  PodcastSeedDataList({
    this.id,
    this.caption,
    this.isPrivate,
    this.type,
    this.hasBeenSeen,
    this.mediaData,
    this.thumnailURL,
    this.createdAt,
    this.modifiedAt,
    this.user,
    this.reaction,
    this.videoFrame,
  });

  factory PodcastSeedDataList.fromRawJson(String str) =>
      PodcastSeedDataList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PodcastSeedDataList.fromJson(Map<String, dynamic> json) =>
      PodcastSeedDataList(
        id: json["id"],
        caption: json["caption"],
        isPrivate: json["is_private"],
        type: json["type"],
        hasBeenSeen: json["has_been_seen"],
        thumnailURL: json["thumbnail_url"],
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
        videoFrame: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caption": caption,
        "is_private": isPrivate,
        "type": type,
        "has_been_seen": hasBeenSeen,
        "thumbnail_url": thumnailURL,
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
  final String? audio;

  MediaDatum({this.video, this.audio});

  factory MediaDatum.fromRawJson(String str) =>
      MediaDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaDatum.fromJson(Map<String, dynamic> json) => MediaDatum(
        video: json["video"],
        audio: json["audio"],
      );

  Map<String, dynamic> toJson() => {
        "video": video,
        "audio": audio,
      };
}
