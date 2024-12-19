// To parse this JSON data, do
//
//     final worktoolSkill = worktoolSkillFromJson(jsonString);

import 'dart:convert';

List<WorktoolSkill> worktoolSkillFromJson(String str) =>
    List<WorktoolSkill>.from(
        json.decode(str).map((x) => WorktoolSkill.fromJson(x)));

String worktoolSkillToJson(List<WorktoolSkill> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorktoolSkill {
  final int id;
  final String name;
  final String description;
  final bool active;
  final List<String> tags;
  final bool isAllowed;
  final List<QuestionSuggestion>? questionSuggestion;

  WorktoolSkill({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.tags,
    required this.isAllowed,
    required this.questionSuggestion,
  });

  factory WorktoolSkill.fromJson(Map<String, dynamic> json) => WorktoolSkill(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        active: json["active"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        isAllowed: json["is_allowed"],
        questionSuggestion: json['is_allowed']
            ? List<QuestionSuggestion>.from(json["question_suggestion"].map(
                (x) => QuestionSuggestion.fromJson(x as Map<String, dynamic>)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "active": active,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "is_allowed": isAllowed,
        "question_suggestion":
            List<dynamic>.from(questionSuggestion ?? [].map((x) => x.toJson())),
      };
}

class QuestionSuggestion {
  final int id;
  final String name;
  final String placeholder;
  final String type;

  QuestionSuggestion({
    required this.id,
    required this.name,
    required this.placeholder,
    required this.type,
  });

  factory QuestionSuggestion.fromJson(Map<String, dynamic> json) =>
      QuestionSuggestion(
        id: json["id"],
        name: json["field_name"],
        placeholder: json["placeholder"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "placeholder": placeholder,
        "type": type,
      };
}
