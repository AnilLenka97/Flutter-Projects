import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_corner/widgets/order_widget.dart';

class OrderScreen extends StatelessWidget {
  static const String id = 'OrderScreen';
  final String _uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_uid)
              .collection('order-history')
              .snapshots(),
          builder: (context, orderSnapshots) {
            if (orderSnapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('food-items')
                    .snapshots(),
                builder: (ctx, foodItemSnapshots) {
                  if (foodItemSnapshots.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final foodItemDocs = orderSnapshots.data.docs;
                  final cartFoodDocs = foodItemSnapshots.data.docs;
                  return ListView.builder(
                    itemCount: foodItemDocs.length,
                    itemBuilder: (ctx, index) => OrderWidget(),
                    // itemBuilder: (ctx, index) =>
                    //     Text(foodItemDocs[index]['noOfItems'].toString()),
                  );
                });
          }),
    );
  }
}
