// To parse this JSON data, do
//
//     final worktoolsResult = worktoolsResultFromJson(jsonString);

import 'dart:convert';

WorktoolsResult worktoolsResultFromJson(String str) => WorktoolsResult.fromJson(json.decode(str));

String worktoolsResultToJson(WorktoolsResult data) => json.encode(data.toJson());

class WorktoolsResult {
  final String prdTitle;
  final String prdCategory;
  final List<String> prdTags;
  final PrdContent prdContent;

  WorktoolsResult({
    required this.prdTitle,
    required this.prdCategory,
    required this.prdTags,
    required this.prdContent,
  });

  factory WorktoolsResult.fromJson(Map<String, dynamic> json) => WorktoolsResult(
    prdTitle: json["prd_title"],
    prdCategory: json["prd_category"],
    prdTags: json["prd_tags"].toString().split(",").toList(),
    prdContent: PrdContent.fromJson(json["prd_content"]),
  );

  Map<String, dynamic> toJson() => {
    "prd_title": prdTitle,
    "prd_category": prdCategory,
    "prd_tags": List<dynamic>.from(prdTags.map((x) => x)),
    "prd_content": prdContent.toJson(),
  };
}

class PrdContent {
  final dynamic problemStatement;
  final dynamic objective;
  final dynamic persona;
  final dynamic risksAssumptions;
  final dynamic highLevelSolution;
  final List<FeaturesList> featuresList;
  final dynamic successMetrics;

  PrdContent({
    this.problemStatement,
    this.objective,
    this.persona,
    this.risksAssumptions,
    this.highLevelSolution,
    required this.featuresList,
    this.successMetrics,
  });

  factory PrdContent.fromJson(Map<String, dynamic> json) => PrdContent(
    problemStatement: json["problem_statement"],
    objective: json["objective"],
    persona: json["persona"],
    risksAssumptions: json["risks_assumptions"],
    highLevelSolution: json["high_level_solution"],
    featuresList: List<FeaturesList>.from(json["features_list"].map((x) => FeaturesList.fromJson(x))),
    successMetrics: json["success_metrics"],
  );

  Map<String, dynamic> toJson() => {
    "problem_statement": problemStatement,
    "objective": objective,
    "persona": persona,
    "risks_assumptions": risksAssumptions,
    "high_level_solution": highLevelSolution,
    "features_list": List<dynamic>.from(featuresList.map((x) => x.toJson())),
    "success_metrics": successMetrics,
  };
}

class FeaturesList {
  final String featureName;
  final List<String> featureDetailPoints;

  FeaturesList({
    required this.featureName,
    required this.featureDetailPoints,
  });

  factory FeaturesList.fromJson(Map<String, dynamic> json) => FeaturesList(
    featureName: json["feature_name"],
    featureDetailPoints: List<String>.from(json["feature_detail_points"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "feature_name": featureName,
    "feature_detail_points": List<dynamic>.from(featureDetailPoints.map((x) => x)),
  };
}
