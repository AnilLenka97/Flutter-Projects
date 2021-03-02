class OrderModel {
  final String orderId;
  final String foodItemId;
  final String consumerId;
  final int noOfItems;
  final bool isDelivered;
  final DateTime orderTime;

  OrderModel({
    this.orderId,
    this.foodItemId,
    this.consumerId,
    this.noOfItems,
    this.isDelivered,
    this.orderTime,
  });
}
