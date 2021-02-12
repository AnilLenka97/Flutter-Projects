import 'package:flutter/material.dart';

class ReusableRaisedButton extends StatelessWidget {
  final buttonTitle;
  final Function onPressed;
  ReusableRaisedButton({@required this.buttonTitle, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 8,
      child: Text(
        buttonTitle,
        style: TextStyle(fontSize: 20),
      ),
      color: Color(0xFF007435),
      textColor: Colors.white,
      padding: EdgeInsets.all(10),
      onPressed: onPressed,
    );
  }
}
