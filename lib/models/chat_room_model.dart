import 'package:flutter/material.dart';

class ChatRoomModel {
  final String chatId;
  final List chatUser;

  const ChatRoomModel({
    @required this.chatId,
    @required this.chatUser,
  });

  static ChatRoomModel fromJson(Map<String, dynamic> json) => ChatRoomModel(
    chatId: json['chatId'],
    chatUser: json['chatUser'],
  );

  Map<String, dynamic> toJson() => {
    'chatId': chatId,
    'chatUser': chatUser,
  };
}