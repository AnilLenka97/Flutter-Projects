import 'package:flutter/material.dart';

class EmptyPageWithAButton extends StatelessWidget {
  final String message;
  final String buttonTitle;
  final Function onPress;
  const EmptyPageWithAButton({
    @required this.message,
    @required this.buttonTitle,
    @required this.onPress,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$message, ',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          RawMaterialButton(
            padding: EdgeInsets.zero,
            child: Text(
              buttonTitle,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.green,
              ),
            ),
            onPressed: onPress,
          ),
        ],
      ),
    );
  }
}
