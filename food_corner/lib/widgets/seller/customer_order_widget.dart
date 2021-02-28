import 'package:flutter/material.dart';

class CustomerOrderWidget extends StatefulWidget {
  @override
  _CustomerOrderWidgetState createState() => _CustomerOrderWidgetState();
}

class _CustomerOrderWidgetState extends State<CustomerOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Tapped');
      },
      child: Card(
        child: Column(
          children: [
            Text('Test'),
          ],
        ),
      ),
    );
  }
}
