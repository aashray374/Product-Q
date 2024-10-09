// To parse this JSON data, do
//
//     final coachChallenge = coachChallengeFromJson(jsonString);

import 'dart:convert';

List<CoachChallenge> coachChallengeFromJson(String str) =>
    List<CoachChallenge>.from(
        json.decode(str).map((x) => CoachChallenge.fromJson(x)));

String coachChallengeToJson(List<CoachChallenge> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoachChallenge {
  final int id;
  final String challengeName;
  final String description;
  final bool active;
  final int total;
  final int completed;
  final List<Label> labels;

  CoachChallenge({
    required this.id,
    required this.challengeName,
    required this.description,
    required this.active,
    required this.completed,
    required this.total,
    required this.labels,
  });

  factory CoachChallenge.fromJson(Map<String, dynamic> json) => CoachChallenge(
        id: json["id"],
        challengeName: json["challenge_name"],
        description: json["description"],
        active: json["active"],
        completed: json["complition"]["completed"],
        total: json["complition"]["total"],
        labels: List<Label>.from(json["labels"].map((x) => Label.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "challenge_name": challengeName,
        "description": description,
        "active": active,
        "complition": {'completed': completed, 'total': total},
        "labels": List<dynamic>.from(labels.map((x) => x.toJson())),
      };
}

class Label {
  final int id;
  final String levelName;
  final String? levelQuestion;
  final String? levelHint;
  final String? companyLogo;
  final String? sampleAnswer;
  final bool active;
  final bool? completed;
  final bool isLocked;
  final List<dynamic> ? topics;
  final List<dynamic> ? topicId;
  final int order;
  final dynamic rating;
  final dynamic result;
  final dynamic answer;

  Label({
    required this.id,
    required this.levelName,
    this.sampleAnswer,
    this.levelQuestion,
    this.companyLogo,
    this.topicId,
    this.levelHint,
    this.topics,
    required this.active,
    required this.isLocked,
    required this.order,
    this.completed,
    this.rating,
    this.result,
    this.answer,
  });

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        id: json["id"],
        levelName: json["level_name"],
        levelQuestion: json["level_question"],
        levelHint: json["level_hint"],
    sampleAnswer: json["deep_link_iq"],
        companyLogo: json["company_logo"],
        active: json["active"],
    topics: json["topics"],
    topicId: json["topic_id"],
        completed: json["completed"],
        isLocked: json["is_locked"],
        order: json["order"],
        rating: json["rating"],
        result: json["result"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "level_name": levelName,
        "level_question": levelQuestion,
        "deep_link_iq": sampleAnswer,
        "level_hint": levelHint,
        "company_logo":companyLogo,
        "active": active,
        "topics": topics,
        "topic_id": topicId,
        "is_locked": isLocked,
        "order": order,
        "completed": completed,
        "rating": rating,
        "result": result,
        "answer": answer,
      };
}
