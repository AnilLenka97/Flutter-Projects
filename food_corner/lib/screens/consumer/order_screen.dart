import 'package:flutter/material.dart';
import '../../widgets/empty_page_with_button.dart';
import '../../services/firebase_api.dart';
import '../../widgets/consumer/order_widget.dart';
import '../../widgets/spinner_widget.dart';

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
          final orderedFoodDocs = orderSnapshots.data.docs;
          if (orderedFoodDocs.length == 0) {
            return EmptyPageWithAButton(
              message: 'No order history found',
              buttonTitle: 'Order Now!',
              onPress: () {
                Navigator.pop(context);
              },
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
