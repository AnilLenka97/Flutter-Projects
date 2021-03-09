import 'package:flutter/material.dart';
import 'package:food_corner/widgets/seller/order_details_pop_up_dialog.dart';
import '../../models/food_item_model.dart';
import '../../models/order_model.dart';
import '../../screens/chat_screen.dart';
import '../../utilities/date_formatter.dart';

class OrderWidget extends StatelessWidget {
  final FoodItemModel foodItem;
  final OrderModel order;
  OrderWidget({
    @required this.order,
    @required this.foodItem,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => OrderDialog(
            order: order,
            foodItem: foodItem,
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 7,
        color: order.isDelivered ? Colors.green[50] : Colors.green[100],
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                child: Image.network(
                  foodItem.foodImgPath,
                  height: 110.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      foodItem.foodTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                    Text(
                      '₹ ${order.price * order.noOfItems}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'No of items : ${order.noOfItems}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ordered: ${DateFormatter.timeAgoSinceDate(order.orderTime)}',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      'Status: ${order.isDelivered ? 'Delivered' : 'Pending...'}',
                      style: TextStyle(
                        color: order.isDelivered ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
