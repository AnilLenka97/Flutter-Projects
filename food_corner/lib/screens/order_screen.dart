import 'package:flutter/material.dart';
import 'package:food_corner/services/firebase_api.dart';
import 'package:food_corner/widgets/order_widget.dart';
import '../widgets/spinner_widget.dart';

class OrderScreen extends StatelessWidget {
  static const String id = 'OrderScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: FirebaseApi().getOrderHistorySnapshotsInDescOrder(),
        builder: (context, orderSnapshots) {
          if (orderSnapshots.connectionState == ConnectionState.waiting) {
            return Spinner();
          }
          if (orderSnapshots.data.docs.length == 0) {
            return Center(
              child: Text('No order history found!'),
            );
          }
          return StreamBuilder(
            stream: FirebaseApi().getFoodItemSnapshots(),
            builder: (ctx, foodItemSnapshots) {
              if (foodItemSnapshots.connectionState ==
                  ConnectionState.waiting) {
                return Spinner();
              }
              final foodItemDocs = foodItemSnapshots.data.docs;
              final orderedFoodDocs = orderSnapshots.data.docs;
              var orderedFoodItemList = [];
              for (var orderedItem in orderedFoodDocs) {
                for (var foodItem in foodItemDocs) {
                  if (orderedItem['foodItemId'] == foodItem.id) {
                    orderedFoodItemList.add(foodItem);
                  }
                }
              }
              return ListView.builder(
                itemCount: orderedFoodItemList.length,
                itemBuilder: (ctx, index) => OrderWidget(
                  title: orderedFoodItemList[index]['title'],
                  imgPath: orderedFoodItemList[index]['imgPath'],
                  noOfItems: orderedFoodDocs[index]['noOfItems'],
                  totalCost: orderedFoodItemList[index]['price'] *
                      orderedFoodDocs[index]['noOfItems'],
                  orderTime: orderedFoodDocs[index]['orderTime'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
