import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart';
import '../models/food_item.dart';
import '../widgets/spinner_widget.dart';
import '../widgets/food_item_widget.dart';
import '../widgets/drawer_widget.dart';
import 'cart_screen.dart';

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

  getCurrentUser() async {
    User user = _auth.currentUser;
    userEmail = user.email;
    userId = user.uid;
    var userData = await FoodItem().getUserBasedData(userId);
    userName = userData['name'];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final fireStoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Spinner();
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner'),
        elevation: 5,
        actions: [
          Badge(
            padding: EdgeInsets.all(4.0),
            position: BadgePosition.topEnd(
              top: -2.0,
              end: 4.0,
            ),
            elevation: 3,
            animationType: BadgeAnimationType.fade,
            // badgeContent: Text(noOfItemsAddedToCart.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
            badgeContent: StreamBuilder(
              stream: fireStoreInstance
                  .collection('users')
                  .doc(userId)
                  .collection('cart-items')
                  .snapshots(),
              builder: (ctx, cartItemSnapshot) {
                if (cartItemSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Spinner();
                }
                return Text(cartItemSnapshot.data.docs.length.toString());
              },
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(
        userEmail: userEmail,
        userName: userName,
        onTapOnLogout: () {
          FirebaseAuth.instance.signOut();
        },
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: fireStoreInstance
            .collection('users')
            .doc(userId)
            .collection('cart-items')
            .snapshots(),
        builder: (ctx, cartItemSnapshot) {
          if (cartItemSnapshot.connectionState == ConnectionState.waiting) {
            return Spinner();
          }
          final cartItemDocs = cartItemSnapshot.data.docs;
          return StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('food-items').snapshots(),
            builder: (ctx, foodSnapshots) {
              if (foodSnapshots.connectionState == ConnectionState.waiting) {
                return Spinner();
              }
              final foodDocs = foodSnapshots.data.docs;
              List<String> cartItemIdList = [];
              for (var data in cartItemDocs) {
                cartItemIdList.add(data.id);
              }
              return ListView.builder(
                itemCount: foodDocs.length,
                itemBuilder: (ctx, index) => FoodItemWidget(
                  title: foodDocs[index]['title'],
                  imgPath: foodDocs[index]['imgPath'],
                  price: foodDocs[index]['price'],
                  id: foodDocs[index].id,
                  isItemAddedToCart: cartItemIdList.contains(foodDocs[index].id)
                      ? true
                      : false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
