import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'ProfileScreen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    size: 200,
                    color: Colors.grey,
                  ),
                  Text(
                    'Admin Account',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'admin@tcs.com',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Floor : 1st floor',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Cubical No : 234',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(4),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    elevation: 5.0,
                    child: Icon(
                      Icons.edit,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
