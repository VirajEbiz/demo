import 'dart:convert';

class HelpDataModelList {
  final int? id;
  final String? question;
  final String? answer;

  HelpDataModelList({
    this.id,
    this.question,
    this.answer,
  });

  factory HelpDataModelList.fromRawJson(String str) =>
      HelpDataModelList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HelpDataModelList.fromJson(Map<String, dynamic> json) =>
      HelpDataModelList(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
      };
}
