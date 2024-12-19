// To parse this JSON data, do
//
//     final purchases = purchasesFromJson(jsonString);

import 'dart:convert';

List<Purchases> purchasesFromJson(String str) => List<Purchases>.from(json.decode(str).map((x) => Purchases.fromJson(x)));

String purchasesToJson(List<Purchases> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Purchases {
  final String plan;
  final DateTime startDate;
  final bool isValid;
  final String duration;
  final double amountPaid;
  final double actualAmount;
  final List<AppsSubscribedTo> appsSubscribedTo;

  Purchases({
    required this.plan,
    required this.startDate,
    required this.isValid,
    required this.duration,
    required this.amountPaid,
    required this.actualAmount,
    required this.appsSubscribedTo,
  });

  factory Purchases.fromJson(Map<String, dynamic> json) => Purchases(
    plan: json["plan"],
    startDate: DateTime.parse(json["start_date"]),
    isValid: json["is_valid"],
    duration: json["duration"],
    amountPaid: json["amount_paid"],
    actualAmount: json["actual_amount"],
    appsSubscribedTo: List<AppsSubscribedTo>.from(json["apps_subscribed_to"].map((x) => AppsSubscribedTo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "plan": plan,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "is_valid": isValid,
    "duration": duration,
    "amount_paid": amountPaid,
    "actual_amount": actualAmount,
    "apps_subscribed_to": List<dynamic>.from(appsSubscribedTo.map((x) => x.toJson())),
  };
}

class AppsSubscribedTo {
  final int id;
  final String name;
  final String description;

  AppsSubscribedTo({
    required this.id,
    required this.name,
    required this.description,
  });

  factory AppsSubscribedTo.fromJson(Map<String, dynamic> json) => AppsSubscribedTo(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}
