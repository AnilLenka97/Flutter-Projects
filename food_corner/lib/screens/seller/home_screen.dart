import 'package:flutter/material.dart';
import 'package:food_corner/widgets/seller/customer_order_widget.dart';
import 'package:food_corner/widgets/spinner_widget.dart';
import '../../services/firebase_api.dart';
import '../../widgets/drawer_widget.dart';

class SellerHomeScreen extends StatefulWidget {
  static const String id = 'SellerHomeScreen';
  final String userEmail;
  final String userName;
  SellerHomeScreen({
    @required this.userEmail,
    @required this.userName,
  });
  @override
  _SellerHomeScreenState createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();
  String userEmail;
  String userName;
  bool _isLoading = true;

  @override
  void initState() {
    userEmail = widget.userEmail;
    userName = widget.userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner(Order List)'),
      ),
      drawer: DrawerWidget(
        userName: userName,
        userEmail: userEmail,
        isFoodSettingAvailable: true,
      ),
      body: StreamBuilder(
        stream: _firebaseApi.getCustomerOrdersSnapshotsInDescOrder(),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting)
            return Spinner();
          final customerOrders = orderSnapshot.data.docs;
          return ListView.builder(
            itemCount: customerOrders.length,
            itemBuilder: (context, index) => CustomerOrderWidget(),
          );
        },
      ),
    );
  }
}
