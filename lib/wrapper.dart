import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/screens/chat_screens/chat_room.dart';
import 'package:flutter_chat_app/screens/login_signup/home_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return user == null ? HomePage() : ChatRoom();
  }
}
