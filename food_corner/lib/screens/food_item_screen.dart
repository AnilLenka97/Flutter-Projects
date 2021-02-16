import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_corner/models/food_item.dart';
import 'package:food_corner/utilities/data_access_from_firebase.dart';
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
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
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
          stream:
              FirebaseFirestore.instance.collection('food-items').snapshots(),
          builder: (ctx, foodSnapshots) {
            if (foodSnapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('cart-items')
                  .snapshots(),
              builder: (ctx, cartItemSnapshot) {
                if (cartItemSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final foodDocs = foodSnapshots.data.docs;
                final cartItemDocs = cartItemSnapshot.data.docs;
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
                    isItemAddedToCart:
                        cartItemIdList.contains(foodDocs[index].id)
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
