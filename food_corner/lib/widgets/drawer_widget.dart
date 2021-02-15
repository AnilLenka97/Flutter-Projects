import 'package:flutter/material.dart';
import 'package:food_corner/screens/cart_screen.dart';

class DrawerWidget extends StatelessWidget {
  final userName;
  final userEmail;
  final Function onTapOnLogout;

  DrawerWidget({
    @required this.userName,
    @required this.userEmail,
    @required this.onTapOnLogout,
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
            onTap: () {},
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
            onTap: () {},
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.open_in_browser),
            title: Text(
              'My Orders',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {},
          ),
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
            onTap: onTapOnLogout,
          ),
        ],
      ),
    );
  }
}
