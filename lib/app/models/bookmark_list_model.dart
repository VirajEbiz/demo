import 'dart:convert';

import 'package:watermel/app/models/media_data_model.dart';

class BookmarkItem {
  final int? id;
  final int? seedId;
  final String? seedType;
  final List<MediaDatum>? seedMediaData;
  final String? seedThumbnailUrl;

  BookmarkItem({
    this.id,
    this.seedId,
    this.seedType,
    this.seedMediaData,
    this.seedThumbnailUrl,
  });

  factory BookmarkItem.fromRawJson(String str) =>
      BookmarkItem.fromJson(json.decode(str));

  factory BookmarkItem.fromJson(Map<String, dynamic> json) => BookmarkItem(
        id: json["id"],
        seedId: json["seed_id"],
        seedType: json["seed__type"],
        seedMediaData: json["seed_media_data"] == [] ||
                json["seed_media_data"].isEmpty
            ? []
            : List<MediaDatum>.from(
                json["seed_media_data"]!.map((x) => MediaDatum.fromJson(x))),
        seedThumbnailUrl: json["seed_thumbnail_url"] ?? "",
      );
}
