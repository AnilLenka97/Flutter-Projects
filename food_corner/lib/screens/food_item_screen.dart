import 'package:firebase_auth/firebase_auth.dart';
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 96.0,
              child: DrawerHeader(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'example@gmail.com',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Text('Food items will be shown here.'),
      ),
    );
  }
}
