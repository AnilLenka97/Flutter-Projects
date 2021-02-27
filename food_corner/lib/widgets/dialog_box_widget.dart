import 'package:flutter/material.dart';

class NotificationAlert extends StatelessWidget {
  final String title;
  final String message;
  final Widget actionWidget;
  NotificationAlert({
    @required this.title,
    @required this.message,
    this.actionWidget,
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
        actionWidget,
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
