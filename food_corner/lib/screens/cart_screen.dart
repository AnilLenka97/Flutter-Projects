import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/spinner_widget.dart';
import '../widgets/cart_widget.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'CartScreen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String _uid = FirebaseAuth.instance.currentUser.uid;
  final _users = FirebaseFirestore.instance.collection('users');
  var cartData;

  //adding order data to database
  void initiateOrders() {
    for (var data in cartData) {
      makeOrder(
        noOfItems: data['noOfItems'],
        foodItemId: data.id,
        orderTime: Timestamp.now(),
      );
      removeItemFromCart(data.id);
    }
  }

  removeItemFromCart(String foodItemId) {
    _users
        .doc(_uid)
        .collection('cart-items')
        .doc(foodItemId)
        .delete()
        .then((value) => print("Item Deleted from Cart"))
        .catchError(
            (error) => print("Failed to delete item from Cart: $error"));
  }

  // adding order data to firebase database one by one
  void makeOrder({
    String foodItemId,
    int noOfItems,
    Timestamp orderTime,
  }) {
    _users
        .doc(_uid)
        .collection('order-history')
        .add({
          'foodItemId': foodItemId,
          'noOfItems': noOfItems,
          'orderTime': orderTime,
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add Order: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .collection('cart-items')
            .snapshots(),
        builder: (ctx, cartFoodSnapshots) {
          if (cartFoodSnapshots.connectionState == ConnectionState.waiting) {
            return Spinner();
          }
          return StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('food-items').snapshots(),
            builder: (ctx, foodItemSnapshots) {
              if (foodItemSnapshots.connectionState ==
                  ConnectionState.waiting) {
                return Spinner();
              }
              final cartFoodDocs = cartFoodSnapshots.data.docs;
              cartData = cartFoodDocs;
              final foodItemDocs = foodItemSnapshots.data.docs;
              var cartList = [];
              var cartItemNumberList = [];
              for (var cartItem in cartFoodDocs) {
                for (var foodItem in foodItemDocs) {
                  if (cartItem.id == foodItem.id) {
                    cartItemNumberList.add(cartItem['noOfItems']);
                    cartList.add(foodItem);
                  }
                }
              }
              return ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (ctx, index) => CartWidget(
                  foodItemId: cartList[index].id,
                  foodName: cartList[index]['title'],
                  imgPath: cartList[index]['imgPath'],
                  price: cartList[index]['price'],
                  noOfItems: cartItemNumberList[index],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 45,
        child: RawMaterialButton(
          child: Text(
            'Make Order',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          fillColor: Colors.green,
          onPressed: () {
            initiateOrders();
          },
        ),
      ),
    );
  }
}
