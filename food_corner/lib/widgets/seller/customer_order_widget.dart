import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../utilities/date_formatter.dart';
import '../../widgets/seller/order_details_pop_up_dialog.dart';
import '../../services/firebase_api.dart';
import '../../widgets/spinner_widget.dart';
import '../../models/food_item_model.dart';
import '../../models/user_model.dart';

class CustomerOrderWidget extends StatefulWidget {
  final OrderModel order;
  const CustomerOrderWidget({
    @required this.order,
  });

  @override
  _CustomerOrderWidgetState createState() => _CustomerOrderWidgetState();
}

class _CustomerOrderWidgetState extends State<CustomerOrderWidget> {
  FirebaseApi _firebaseApi = FirebaseApi();
  bool _isLoading = true;
  UserModel user;
  FoodItemModel foodItem;

  getRequiredData() async {
    user = await _firebaseApi.getUserInfo(
      userId: widget.order.consumerId,
    );
    foodItem = await _firebaseApi.getFoodItemInfo(
      foodItemId: widget.order.foodItemId,
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
            order: widget.order,
            user: user,
            foodItem: foodItem,
          ),
        );
      },
      child: Card(
        color: widget.order.isDelivered ? Colors.green[100] : Colors.green[300],
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
                      foodItem.foodTitle,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      'Quantity: ${widget.order.noOfItems}',
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
                      DateFormatter.timeAgoSinceDate(widget.order.orderTime),
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
                    foodItem.foodImgPath,
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
