import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_corner/services/firebase_api.dart';
import 'package:food_corner/widgets/spinner_widget.dart';
import '../../models/food_item_model.dart';
import '../../models/user_model.dart';

class CustomerOrderWidget extends StatefulWidget {
  final String consumerId;
  final String foodItemId;
  final int noOfItems;
  final bool isDelivered;
  final Timestamp orderTime;

  const CustomerOrderWidget({
    @required this.consumerId,
    @required this.foodItemId,
    @required this.noOfItems,
    @required this.isDelivered,
    @required this.orderTime,
  });

  @override
  _CustomerOrderWidgetState createState() => _CustomerOrderWidgetState();
}

class _CustomerOrderWidgetState extends State<CustomerOrderWidget> {
  FirebaseApi _firebaseApi = FirebaseApi();
  bool _isLoading = true;
  UserModel userModel;
  FoodItemModel foodItemModel;

  getRequiredData() async {
    userModel = await _firebaseApi.getConsumerInfo(
      consumerId: widget.consumerId,
    );
    foodItemModel = await _firebaseApi.getFoodItemInfo(
      foodItemId: widget.foodItemId,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getRequiredData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Spinner();
    return InkWell(
      onTap: () {
        print('Tapped');
      },
      child: Card(
        child: Row(
          children: [
            Column(
              children: [
                Text(foodItemModel.foodTitle),
                Text('Quantity: ${widget.noOfItems}'),
              ],
            ),
            Column(
              children: [
                Text('Order Time:'),
                Text(
                  widget.orderTime.toString(),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
