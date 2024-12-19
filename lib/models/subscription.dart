// To parse this JSON data, do
//
//     final subscription = subscriptionFromJson(jsonString);

import 'dart:convert';

List<Subscription> subscriptionFromJson(String str) => List<Subscription>.from(json.decode(str).map((x) => Subscription.fromJson(x)));

String subscriptionToJson(List<Subscription> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Subscription {
  final int id;
  final String name;
  final double priceMonthly;
  final double discountedMonthly;
  final double priceAnnual;
  final double discountedAnnual;
  final String description;
  final bool recommended;
  final List<String> apps;

  Subscription({
    required this.id,
    required this.name,
    required this.priceMonthly,
    required this.discountedMonthly,
    required this.priceAnnual,
    required this.discountedAnnual,
    required this.description,
    required this.recommended,
    required this.apps,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json["id"],
    name: json["name"],
    priceMonthly: json["price_monthly"],
    discountedMonthly: json["discounted_monthly"],
    priceAnnual: json["price_annual"],
    discountedAnnual: json["discounted_annual"],
    description: json["description"],
    recommended: json["recommended"],
    apps: List<String>.from(json["apps"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price_monthly": priceMonthly,
    "discounted_monthly": discountedMonthly,
    "price_annual": priceAnnual,
    "discounted_annual": discountedAnnual,
    "description": description,
    "recommended": recommended,
    "apps": List<dynamic>.from(apps.map((x) => x)),
  };
}
