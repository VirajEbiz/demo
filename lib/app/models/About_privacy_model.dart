import 'dart:convert';

class AboutAndPrivacyDataList {
  final int? id;
  final String? content;

  AboutAndPrivacyDataList({
    this.id,
    this.content,
  });

  factory AboutAndPrivacyDataList.fromRawJson(String str) =>
      AboutAndPrivacyDataList.fromJson(json.decode(str));

  factory AboutAndPrivacyDataList.fromJson(Map<String, dynamic> json) =>
      AboutAndPrivacyDataList(
        id: json["id"],
        content: json["content"],
      );
}
