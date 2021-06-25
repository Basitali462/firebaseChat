import 'package:flutter/material.dart';

class ChatUser {
  final String email;
  final String username;
  final List searchQuery;

  const ChatUser({
    @required this.email,
    @required this.username,
    @required this.searchQuery,
  });

  static ChatUser fromJson(Map<String, dynamic> json) => ChatUser(
    email: json['email'],
    username: json['username'],
    searchQuery: json['searchQuery'],
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'searchQuery': searchQuery,
  };
}