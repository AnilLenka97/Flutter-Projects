import 'package:flutter/material.dart';
import 'package:food_corner/widgets/drawer_widget.dart';

class AdminHomeScreen extends StatelessWidget {
  static const String id = 'AdminHomeScreen';
  final userName;
  final userEmail;
  AdminHomeScreen({@required this.userEmail, @required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner'),
      ),
      drawer: DrawerWidget(
        userEmail: userName,
        userName: userEmail,
      ),
      body: Center(
        child: Text('You are in Admin account!'),
      ),
    );
  }
}
