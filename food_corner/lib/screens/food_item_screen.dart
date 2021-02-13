import 'package:flutter/material.dart';

class FoodItemScreen extends StatelessWidget {
  static const String id = 'FoodItemScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner'),
        elevation: 5,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Food items will be shown here.'),
      ),
    );
  }
}
