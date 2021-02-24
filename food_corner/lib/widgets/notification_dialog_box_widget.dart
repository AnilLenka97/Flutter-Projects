import 'package:flutter/material.dart';

class NotificationAlert extends StatelessWidget {
  final String title;
  final String message;
  NotificationAlert({
    @required this.title,
    @required this.message,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 7,
      title: Text(title),
      content: SingleChildScrollView(
        child: Text(message),
      ),
      actions: [
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
