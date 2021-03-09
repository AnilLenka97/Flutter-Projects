import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/push_notification_handler.dart';
import '../../models/order_model.dart';
import '../../widgets/seller/customer_order_widget.dart';
import '../../widgets/spinner_widget.dart';
import '../../services/firebase_api.dart';
import '../../widgets/drawer_widget.dart';

class SellerHomeScreen extends StatefulWidget {
  static const String id = 'SellerHomeScreen';
  final UserModel user;
  SellerHomeScreen({
    this.user,
  });
  @override
  _SellerHomeScreenState createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();

  @override
  void initState() {
    PushNotificationHandler pushNotificationHandler =
        PushNotificationHandler(context: context);
    pushNotificationHandler.pushNotificationConfigure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner(Order List)'),
      ),
      drawer: DrawerWidget(
        userName: widget.user.userName ?? '',
        userEmail: widget.user.userEmail ?? '',
        isFoodSettingAvailable: true,
      ),
      body: StreamBuilder(
        stream: _firebaseApi.getCustomerOrdersSnapshotsInDescOrder(),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting)
            return Spinner();
          final customerOrders = orderSnapshot.data.docs;
          if (customerOrders.length == 0)
            return Center(
              child: Text('No order received!'),
            );
          return ListView.builder(
            itemCount: customerOrders.length,
            itemBuilder: (context, index) {
              return CustomerOrderWidget(
                order: OrderModel(
                  orderId: customerOrders[index].id,
                  consumerOrderId: customerOrders[index]['consumerOrderId'],
                  consumerId: customerOrders[index]['consumerId'],
                  foodItemId: customerOrders[index]['foodItemId'],
                  price: customerOrders[index]['price'],
                  noOfItems: customerOrders[index]['noOfItems'],
                  isDelivered: customerOrders[index]['isDelivered'],
                  orderTime: customerOrders[index]['orderTime'].toDate(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
