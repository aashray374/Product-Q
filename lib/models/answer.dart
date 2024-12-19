// To parse this JSON data, do
//
//     final answer = answerFromJson(jsonString);

import 'dart:convert';

Answer answerFromJson(String str) => Answer.fromJson(json.decode(str));

String answerToJson(Answer data) => json.encode(data.toJson());

class Answer {
  final String answer;
  final Result result;
   String? evaluationResult;
  String? evalutionResult;

  Answer({
    required this.answer,
    required this.result,
    this.evalutionResult,
    this.evaluationResult,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        answer: json["answer"],
        result: Result.fromJson(json["result"]),
        evalutionResult: json["evalution_result"].toString(),
        evaluationResult: json["evaluation_result"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "answer": answer,
        "result": result.toJson(),
        "evalution_result": evalutionResult,
      };
}

class Result {
  final List<String> names;
  final List<String> scores;
  final List<String> suggestionsReport;

  Result({
    required this.names,
    required this.scores,
    required this.suggestionsReport,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        names: List<String>.from(json["names"].map((x) => x)),
        scores: List<String>.from(json["scores"].map((x) => x.toString())),
        suggestionsReport:
            List<String>.from(json["suggestions_report"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "names": List<dynamic>.from(names.map((x) => x)),
        "scores": List<dynamic>.from(scores.map((x) => x.toString())),
        "suggestions_report":
            List<dynamic>.from(suggestionsReport.map((x) => x)),
      };
}
