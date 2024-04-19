import 'dart:convert';

class TrendingDebateModel {
  final int id;
  final String topicName;
  final String topicImage;
  final int interactions;
  final List<int> hashtags;
  final DateTime createdAt;

  TrendingDebateModel({
    required this.id,
    required this.topicName,
    required this.topicImage,
    required this.interactions,
    required this.hashtags,
    required this.createdAt,
  });

  factory TrendingDebateModel.fromJson(Map<String, dynamic> json) {
    return TrendingDebateModel(
      id: json['id'],
      topicName: json['topic_name'],
      topicImage: json['topic_image'],
      interactions: json['interactions'],
      hashtags: List<int>.from(json['hashtags']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  factory TrendingDebateModel.fromRawJson(String str) =>
      TrendingDebateModel.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_name': topicName,
      'topic_image': topicImage,
      'interactions': interactions,
      'hashtags': hashtags,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String toRawJson() => json.encode(toJson());
}
