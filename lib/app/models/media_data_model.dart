import 'dart:convert';

class MediaDatum {
  final String? image;
  final String? video;
  final String? audio;

  MediaDatum({
    this.image,
    this.video,
    this.audio,
  });

  factory MediaDatum.fromRawJson(String str) =>
      MediaDatum.fromJson(json.decode(str));

  factory MediaDatum.fromJson(Map<String, dynamic> json) => MediaDatum(
        image: json["image"] ?? "",
        video: json["video"] ?? "",
        audio: json["audio"] ?? "",
      );
}
