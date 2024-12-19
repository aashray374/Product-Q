// To parse this JSON data, do
//
//     final searchResult = searchResultFromJson(jsonString);

import 'dart:convert';

SearchResult searchResultFromJson(String str) =>
    SearchResult.fromJson(json.decode(str));

//String searchResultToJson(SearchResult data) => json.encode(data.toJson());

class SearchResult {
  final List<Module>? modules;
  final List<Challenge>? challenges;
  final List<Label>? labels;
  final List<Category>? categories;
  final List<Skill>? skills;
  final List<Section>? sections;
  final List<Topic>? topics;
  final List<Lession>? lessions;

  SearchResult({
    this.modules,
    this.challenges,
    this.labels,
    this.categories,
    this.skills,
    this.sections,
    this.topics,
    this.lessions,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        modules: json['modules'] == null
            ? null
            : List<Module>.from(
                json["modules"].map((x) => Module.fromJson(x))),
        challenges: json['challenges'] == null
            ? null
            : List<Challenge>.from(
                json["challenges"].map((x) => Challenge.fromJson(x))),
        labels: json['labels'] == null
            ? null
            : List<Label>.from(json["labels"].map((x) => Label.fromJson(x))),
        categories: json['categories'] == null
            ? null
            :  List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        skills: json['skills'] == null
            ? null
            : List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
        sections: json['sections'] == null
            ? null
            : List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
        topics: json['topics'] == null
            ? null
            : List<Topic>.from(json["topics"].map((x) => Topic.fromJson(x))),
        lessions: json['lessions'] == null
            ? null
            : List<Lession>.from(
            json["lessions"].map((x) => Lession.fromJson(x))),
      );

//   Map<String, dynamic> toJson() => {
//     "modules": List<dynamic>.from(modules.map((x) => x.toJson())),
//     "challenges": List<dynamic>.from(challenges.map((x) => x.toJson())),
//     "labels": List<dynamic>.from(labels.map((x) => x.toJson())),
//     "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
//     "skills": List<dynamic>.from(skills.map((x) => x.toJson())),
//     "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
//     "topics": List<dynamic>.from(topics.map((x) => x.toJson())),
//     "lessions": List<dynamic>.from(lessions.map((x) => x.toJson())),
//   };
}


class Module {
  final int id;
  final String description;
  final bool active;
  final String moduleName;
  final int appId;

  Module({
    required this.appId,
    required this.id,
    required this.description,
    required this.active,
    required this.moduleName,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    id: json["id"],
    description: json["description"],
    active: json["active"],
    moduleName: json["module_name"], appId: json['app_id'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "active": active,
    "module_name": moduleName
  };
}


class Category {
  final int id;
  final String description;
  final bool active;
  final String name;
  final int appId;

  Category({
    required this.id,
    required this.description,
    required this.active,
    required this.name,
    required this.appId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        description: json["description"],
        active: json["active"],
        name: json["name"],
        appId: json['app_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "active": active,
        "name": name
      };
}

class Section {
  final int id;
  final int app;
  final bool active;
  final String name;
  final int appId;

  Section({
    required this.id,
    required this.app,
    required this.active,
    required this.name,
    required this.appId,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json["id"],
    app: json["app"],
    active: json["active"],
    name: json["name"],
    appId: json['app_id'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "app": app,
    "active": active,
    "name": name
  };
}

class Challenge {
  final int id;
  final String challengeName;
  final String description;
  final bool active;
  final int module;
  final String moduleName;
  final int appId;

  Challenge({
    required this.id,
    required this.challengeName,
    required this.description,
    required this.active,
    required this.module,
    required this.moduleName,
    required this.appId,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["id"],
        challengeName: json["challenge_name"],
        description: json["description"],
        active: json["active"],
        module: json["module"],
        moduleName: json["module_name"],
        appId: json['app_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "challenge_name": challengeName,
        "description": description,
        "active": active,
        "module": module,
        "module_name": moduleName,
      };
}

class Label {
  final int id;
  final String labelName;
  final String levelQuestion;
  final bool active;
  final int challenge;
  final String challengeName;
  final int module;
  final String moduleName;
  final int appId;

  Label({
    required this.id,
    required this.labelName,
    required this.levelQuestion,
    required this.active,
    required this.challenge,
    required this.challengeName,
    required this.module,
    required this.moduleName,
    required this.appId,
  });

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        id: json["id"],
        labelName: json["label_name"],
        levelQuestion: json["level_question"],
        active: json["active"],
        challenge: json["challenge"],
        challengeName: json["challenge_name"],
        module: json["module"],
        moduleName: json["module_name"],
        appId: json['app_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label_name": labelName,
        "level_question": levelQuestion,
        "active": active,
        "challenge": challenge,
        "challenge_name": challengeName,
        "module": module,
        "module_name": moduleName,
      };
}

class Lession {
  final int id;
  final String name;
  final String description;
  final bool active;
  final int topic;
  final String topicName;
  final int section;
  final String sectionName;
  final int appId;

  Lession({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.topic,
    required this.topicName,
    required this.section,
    required this.sectionName,
    required this.appId,
  });

  factory Lession.fromJson(Map<String, dynamic> json) => Lession(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        active: json["active"],
        topic: json["topic"],
        topicName: json["topic_name"],
        section: json["section"],
        sectionName: json["section_name"],
        appId: json['app_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "active": active,
        "topic": topic,
        "topic_name": topicName,
        "section": section,
        "section_name": sectionName,

      };
}

class Skill {
  final int id;
  final String name;
  final String description;
  final bool active;
  final int categorie;
  final String categorieName;
  final int appId;

  Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.categorie,
    required this.categorieName,
    required this.appId,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        active: json["active"],
        categorie: json["categorie"],
        categorieName: json["categorie_name"],
        appId: json['app_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "active": active,
        "categorie": categorie,
        "categorie_name": categorieName,
      };
}

class Topic {
  final int id;
  final String name;
  final bool active;
  final int section;
  final String sectionName;
  final int appId;

  Topic({
    required this.id,
    required this.name,
    required this.active,
    required this.section,
    required this.sectionName,
    required this.appId,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json["id"],
        name: json["name"],
        active: json["active"],
        section: json["section"],
        sectionName: json["section_name"],
        appId: json['app_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "active": active,
        "section": section,
        "section_name": sectionName,
      };
}
