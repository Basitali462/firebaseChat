import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String username;
  final String message;
  final DateTime createdAt;

  const Message({
    @required this.username,
    @required this.message,
    @required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    username: json['username'],
    message: json['message'],
    createdAt: Utils.toDateTime(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'message': message,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}