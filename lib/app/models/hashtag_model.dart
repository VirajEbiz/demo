class HashtagModel {
  final String name;
  final int id;

  HashtagModel({required this.name, required this.id});

  factory HashtagModel.fromJson(Map<String, dynamic> json) {
    return HashtagModel(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
