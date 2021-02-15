import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/cart_widget.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'CartScreen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String _uid = FirebaseAuth.instance.currentUser.uid;
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('food-items').snapshots(),
            builder: (ctx, foodItemSnapshots) {
              if (foodItemSnapshots.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final cartFoodDocs = cartFoodSnapshots.data.docs;
              final foodItemDocs = foodItemSnapshots.data.docs;
              return ListView.builder(
                itemCount: cartFoodDocs.length,
                itemBuilder: (ctx, index) => CartWidget(),
                // itemBuilder: (ctx, index) =>
                //     Text(foodItemDocs[index]['noOfItems'].toString()),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 45,
        child: RawMaterialButton(
          onPressed: () {},
          child: Text(
            'Make Order',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          fillColor: Colors.green,
        ),
      ),
    );
  }
}
