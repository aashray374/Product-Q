// To parse this JSON data, do
//
//     final learning = learningFromJson(jsonString);

import 'dart:convert';

List<Learning> learningFromJson(String str) => List<Learning>.from(json.decode(str).map((x) => Learning.fromJson(x)));

String learningToJson(List<Learning> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Learning {
  final int id;
  final String name;
  final String description;
  final bool active;

  Learning({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
  });

  factory Learning.fromJson(Map<String, dynamic> json) => Learning(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "active": active,
  };
}
