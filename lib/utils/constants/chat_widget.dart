import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';

class UserMessages extends StatelessWidget {
  final Message message;
  final bool isMe;

  UserMessages({
    this.message,
    this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Container(
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              constraints: BoxConstraints(maxWidth: 140),
              decoration: BoxDecoration(
                color: isMe ? Colors.green : Colors.yellow[600],
                borderRadius: isMe
                    ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                    : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
              ),
              child: buildMessage(),
            ),
          ],
        )
    );
  }

  Widget buildMessage() => Column(
    crossAxisAlignment:
    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        message.message,
        style: TextStyle(
          color: isMe ? Colors.black : Colors.white,
          fontSize: 16,
        ),
        textAlign: isMe ? TextAlign.end : TextAlign.start,
      ),
    ],
  );
}