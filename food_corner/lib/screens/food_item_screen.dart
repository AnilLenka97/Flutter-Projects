import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/drawer_widget.dart';

class FoodItemScreen extends StatefulWidget {
  static const String id = 'FoodItemScreen';

  @override
  _FoodItemScreenState createState() => _FoodItemScreenState();
}

class _FoodItemScreenState extends State<FoodItemScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = true;
  String userEmail;
  String userName;
  String userId;

  _FoodItemScreenState() {
    User user = _auth.currentUser;
    userEmail = user.email;
    userId = user.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      userName = value.data()['name'];
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    else
      return Scaffold(
        appBar: AppBar(
          title: Text('Food Corner'),
          elevation: 5,
        ),
        drawer: DrawerWidget(
          userEmail: userEmail,
          userName: userEmail,
          onTapOnLogout: () {
            FirebaseAuth.instance.signOut();
          },
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Text('Food items will be shown here.'),
        ),
      );
  }
}
