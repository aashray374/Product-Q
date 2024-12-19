// To parse this JSON data, do
//
//     final contactUsMessage = contactUsMessageFromJson(jsonString);

import 'dart:convert';

List<ContactUsMessage> contactUsMessageFromJson(String str) => List<ContactUsMessage>.from(json.decode(str).map((x) => ContactUsMessage.fromJson(x)));

String contactUsMessageToJson(List<ContactUsMessage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ContactUsMessage {
  int id;
  String name;
  String message;
  String replay;

  ContactUsMessage({
    required this.id,
    required this.name,
    required this.message,
    required this.replay,
  });

  factory ContactUsMessage.fromJson(Map<String, dynamic> json) => ContactUsMessage(
    id: json["id"],
    name: json["name"],
    message: json["message"],
    replay: json["replay"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "message": message,
    "replay": replay,
  };
}
