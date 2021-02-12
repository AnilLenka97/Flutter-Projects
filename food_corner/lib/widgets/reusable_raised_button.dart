import 'package:flutter/material.dart';

class ReusableRaisedButton extends StatelessWidget {
  final buttonTitle;
  final Function onPressed;
  ReusableRaisedButton({@required this.buttonTitle, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
      child: RaisedButton(
        elevation: 8,
        child: Text(
          buttonTitle,
          style: TextStyle(fontSize: 20),
        ),
        color: Colors.green,
        textColor: Colors.white,
        padding: EdgeInsets.all(10),
        onPressed: onPressed,
      ),
    );
  }
}
