import 'package:flutter/material.dart';
import '../screens/seller/food_setting_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/consumer/cart_screen.dart';
import '../screens/consumer/order_screen.dart';
import '../services/firebase_api.dart';

class DrawerWidget extends StatelessWidget {
  final userName;
  final userEmail;
  final bool isOrderLinkAvailable;
  final bool isCartLinkAvailable;
  final bool isFoodSettingAvailable;

  DrawerWidget({
    @required this.userName,
    @required this.userEmail,
    this.isCartLinkAvailable = false,
    this.isOrderLinkAvailable = false,
    this.isFoodSettingAvailable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                    userName ?? 'null',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    userEmail ?? 'null',
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
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.account_box),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ProfileScreen.id);
            },
          ),
          if (isFoodSettingAvailable)
            ListTile(
              dense: true,
              leading: Icon(Icons.settings),
              title: Text(
                'Food Setting',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, FoodSettingScreen.id);
              },
            ),
          if (isOrderLinkAvailable)
            ListTile(
              dense: true,
              leading: Icon(Icons.open_in_browser),
              title: Text(
                'My Orders',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, OrderScreen.id);
              },
            ),
          if (isCartLinkAvailable)
            ListTile(
              dense: true,
              leading: Icon(Icons.shopping_cart),
              title: Text(
                'My Cart',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, CartScreen.id);
              },
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
              FirebaseApi().signOut();
            },
          ),
        ],
      ),
    );
  }
}
