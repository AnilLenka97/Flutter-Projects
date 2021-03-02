import 'package:flutter/material.dart';
import 'package:food_corner/models/food_item_model.dart';
import 'package:food_corner/models/order_model.dart';
import 'package:food_corner/models/user_model.dart';
import 'package:food_corner/services/firebase_api.dart';
import 'package:food_corner/utilities/date_formatter.dart';
import 'package:food_corner/widgets/spinner_widget.dart';

class OrderDialog extends StatefulWidget {
  final FoodItemModel foodItemModel;
  final UserModel userModel;
  final OrderModel orderModel;

  const OrderDialog({
    this.foodItemModel,
    this.userModel,
    this.orderModel,
  });

  @override
  _OrderDialogState createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  FirebaseApi _firebaseApi = FirebaseApi();

  bool _isDelivered;
  bool _isLoading = false;

  void deliverOrder() async {
    setState(() {
      _isLoading = true;
    });
    bool result = await _firebaseApi.updateOrderDelivery(
      orderId: widget.orderModel.orderId,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isDelivered = result;
    });
  }

  @override
  void initState() {
    _isDelivered = widget.orderModel.isDelivered;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: _isDelivered ? Colors.green[50] : Colors.green[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        elevation: 5.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Image.network(
                    widget.foodItemModel.foodImgPath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      color: Colors.black54,
                    ),
                    width: 230,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.foodItemModel.foodTitle,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          '₹ ${widget.foodItemModel.foodPrice}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Order Details:',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price: ₹${widget.foodItemModel.foodPrice * widget.orderModel.noOfItems}',
                            ),
                            Text(
                              'Order Time: ${DateFormatter.timeAgoSinceDate(widget.orderModel.orderTime)}',
                            ),
                            Row(
                              children: [
                                Text('Order Status: '),
                                Icon(
                                  _isDelivered
                                      ? Icons.check
                                      : Icons.pending_actions,
                                  color: Colors.green,
                                ),
                                Text(
                                  _isDelivered ? ' Delivered' : ' Pending...',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Consumer Details: ',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userModel.userName,
                            ),
                            Text(
                              'Email - ${widget.userModel.userEmail}',
                            ),
                            Text(
                              'Floor - ${widget.userModel.userFloorNo}',
                            ),
                            Text(
                              'Cubicle No - ${widget.userModel.userCubicleNo.toString()}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (_isLoading) Spinner(),
                  if (!_isLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_isDelivered)
                          RaisedButton(
                            elevation: 5.0,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              'Deliver Now',
                            ),
                            onPressed: () {
                              deliverOrder();
                            },
                          ),
                        SizedBox(
                          width: 10.0,
                        ),
                        RaisedButton(
                          elevation: 5.0,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
