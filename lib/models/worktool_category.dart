// To parse this JSON data, do
//
//     final worktoolCategory = worktoolCategoryFromJson(jsonString);

import 'dart:convert';

List<WorktoolCategory> worktoolCategoryFromJson(String str) => List<WorktoolCategory>.from(json.decode(str).map((x) => WorktoolCategory.fromJson(x)));

String worktoolCategoryToJson(List<WorktoolCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorktoolCategory {
  final int id;
  final String name;
  final bool active;

  WorktoolCategory({
    required this.id,
    required this.name,
    required this.active,
  });

  factory WorktoolCategory.fromJson(Map<String, dynamic> json) => WorktoolCategory(
    id: json["id"],
    name: json["name"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active": active,
  };
}
