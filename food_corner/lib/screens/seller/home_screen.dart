import 'package:flutter/material.dart';

class SellerHomeScreen extends StatelessWidget {
  static const String id = 'SellerHomeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner'),
      ),
      body: Center(
        child: Text('You are in seller account!'),
      ),
    );
  }
}
