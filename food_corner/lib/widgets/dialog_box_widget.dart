import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final String title;
  final Widget actionWidget;
  final String defaultActionButtonTitle;
  AlertWidget({
    @required this.title,
    this.actionWidget,
    this.defaultActionButtonTitle = 'Ok',
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 7,
      title: Text(title),
      content: SingleChildScrollView(),
      actions: [
        actionWidget,
        RaisedButton(
          color: Colors.green,
          textColor: Colors.white,
          child: Text(defaultActionButtonTitle),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
