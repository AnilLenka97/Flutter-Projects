import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  static const String id = 'AdminHomeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner'),
      ),
      body: Center(
        child: Text('You are in Admin account!'),
      ),
    );
  }
}
