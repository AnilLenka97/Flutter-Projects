import 'package:flutter/material.dart';
import 'package:food_corner/models/order_model.dart';
import 'package:food_corner/utilities/date_formatter.dart';
import 'file:///F:/Assignment1_flutter_mini_project/food_corner/lib/widgets/seller/order_details_pop_up_dialog.dart';
import '../../services/firebase_api.dart';
import '../../widgets/spinner_widget.dart';
import '../../models/food_item_model.dart';
import '../../models/user_model.dart';

class CustomerOrderWidget extends StatefulWidget {
  final OrderModel orderModel;
  const CustomerOrderWidget({
    @required this.orderModel,
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
    userModel = await _firebaseApi.getUserInfo(
      userId: widget.orderModel.consumerId,
    );
    foodItemModel = await _firebaseApi.getFoodItemInfo(
      foodItemId: widget.orderModel.foodItemId,
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
        showDialog(
          context: context,
          builder: (context) => OrderDialog(
            orderModel: widget.orderModel,
            userModel: userModel,
            foodItemModel: foodItemModel,
          ),
        );
      },
      child: Card(
        color: widget.orderModel.isDelivered
            ? Colors.green[100]
            : Colors.green[300],
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodItemModel.foodTitle,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      'Quantity: ${widget.orderModel.noOfItems}',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Time:'),
                    Text(
                      DateFormatter.timeAgoSinceDate(
                          widget.orderModel.orderTime),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    foodItemModel.foodImgPath,
                    fit: BoxFit.fill,
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
