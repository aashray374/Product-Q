// To parse this JSON data, do
//
//     final module = moduleFromJson(jsonString);

import 'dart:convert';

List<CoachModule> moduleFromJson(String str) =>
    List<CoachModule>.from(json.decode(str).map((x) => CoachModule.fromJson(x)));

String moduleToJson(List<CoachModule> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoachModule {
  final int id;
  final String moduleName;
  final String description;
  final bool active;
  final int order;
  final int completedPercent;
  final int totalPercent;
  final bool isAllowed;
  final Result? result;

  CoachModule({
    required this.id,
    required this.moduleName,
    required this.description,
    required this.active,
    required this.order,
    required this.completedPercent,
    required this.totalPercent,
    required this.isAllowed,
    this.result,
  });

  factory CoachModule.fromJson(Map<String, dynamic> json) => CoachModule(
        id: json["id"],
        moduleName: json["module_name"],
        description: json["description"],
        active: json["active"],
        order: json["order"],
        totalPercent: json["complition"]["total"],
        completedPercent: json["complition"]["completed"],
        isAllowed: json["is_allowed"],
  //      result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "module_name": moduleName,
        "description": description,
        "active": active,
        "order": order,
        "complition": {"total": totalPercent, "completed": completedPercent},
        "is_allowed": isAllowed,
        // "result": result.toJson(),
      };
}

class Result {
  Result();

  factory Result.fromJson(Map<String, dynamic> json) => Result();

  Map<String, dynamic> toJson() => {};
}
