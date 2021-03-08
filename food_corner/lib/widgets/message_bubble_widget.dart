import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;

  const MessageBubble({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      )),
      child: Text(message),
    );
  }
}
