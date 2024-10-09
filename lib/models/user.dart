// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String token;
  final String name;
  final String email;
  final String username;
  final String productExp;
  final String phoneNumber;
  final String jobTitle;
  final String company;

  User({
    required this.token,
    required this.name,
    required this.email,
    required this.username,
    required this.productExp,
    required this.phoneNumber,
    required this.jobTitle,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    token: json["token"],
    name: json["name"],
    email: json["email"],
    username: json["username"],
    productExp: json["product_exp"],
    phoneNumber: json["phone_number"],
    jobTitle: json["job_title"],
    company: json["company"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "name": name,
    "email": email,
    "username": username,
    "product_exp": productExp,
    "phone_number": phoneNumber,
    "job_title": jobTitle,
    "company": company,
  };
}
