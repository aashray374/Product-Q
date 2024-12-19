// To parse this JSON data, do
//
//     final iqSection = iqSectionFromJson(jsonString);

import 'dart:convert';

List<IqSection> iqSectionFromJson(String str) =>
    List<IqSection>.from(json.decode(str).map((x) => IqSection.fromJson(x)));

String iqSectionToJson(List<IqSection> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IqSection {
  final int id;
  final String name;
  final bool active;
  final bool isAllowed;
  final List<IqSection>? topic;

  IqSection({
    required this.id,
    required this.name,
    required this.active,
    required this.isAllowed,
    this.topic,
  });

  factory IqSection.fromJson(Map<String, dynamic> json) => IqSection(
        id: json["id"],
        name: json["name"],
        active: json["active"],
        isAllowed: json["is_allowed"] ?? true,
        topic: json["topic"] == null
            ? []
            : List<IqSection>.from(
                json["topic"]!.map((x) => IqSection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "active": active,
        "topic": topic == null
            ? []
            : List<dynamic>.from(topic!.map((x) => x.toJson())),
      };
}
