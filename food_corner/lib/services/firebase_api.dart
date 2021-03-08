import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../models/food_item_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class FirebaseApi {
  var auth;
  var cloudDb;
  User user;

  FirebaseApi() {
    this.auth = FirebaseAuth.instance;
    this.cloudDb = FirebaseFirestore.instance;
    this.user = auth.currentUser;
  }

  void signOut() {
    auth.signOut();
  }

  getUserInfo({String userId}) async {
    if (userId == null) userId = user.uid;
    UserModel userModel;
    await cloudDb.collection('users').doc(userId).get().then((value) {
      userModel = UserModel(
        userId: userId,
        userEmail: value.data()['email'],
        userName: value.data()['name'],
        userRole: value.data()['role'],
        userFloorNo: value.data()['floorNo'],
        userCubicleNo: value.data()['cubicleNo'],
      );
    });
    return userModel;
  }

  deleteUserData({String userId}) async {
    return await cloudDb.collection('users').doc(userId)
      ..delete()
          .then((_) => print("User Data Deleted Successfully"))
          .catchError((error) => print("Failed to delete user data: $error"));
  }

  Future updateUserProfileInfo({
    String name,
    String floorNo,
    int cubicleNo,
  }) async {
    await cloudDb
        .collection('users')
        .doc(user.uid)
        .update({
          'name': name,
          'floorNo': floorNo,
          'cubicleNo': cubicleNo,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  updateDeviceToken(String token) {
    cloudDb
        .collection('users')
        .doc(user.uid)
        .update({
          'deviceToken': token,
        })
        .then((value) => print("Device Token Updated"))
        .catchError((error) => print("Failed to update Device Token: $error"));
  }

  Stream<QuerySnapshot> getCartItemSnapshots() {
    return cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('cart-items')
        .snapshots();
  }

// update the no of items in cart section
  updateNoOfItemsInCart({
    int noOfItems,
    String foodItemId,
  }) async {
    await cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('cart-items')
        .doc(foodItemId)
        .update({
          'noOfItems': noOfItems,
        })
        .then((value) => print("Cart count updated."))
        .catchError((error) => print("Failed to update cart count: $error"));
  }

// delete/remove food item form cart
  deleteItemFromCart(String foodItemId) async {
    await cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('cart-items')
        .doc(foodItemId)
        .delete()
        .then((value) => print("Item Deleted from Cart"))
        .catchError(
            (error) => print("Failed to delete item from Cart: $error"));
  }

  // adding order data to firebase database and returning the newly created order id
  addItemToOrderHistory({
    String foodItemId,
    int noOfItems,
  }) async {
    String orderId;
    await cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('order-history')
        .add({
      'foodItemId': foodItemId,
      'noOfItems': noOfItems,
      'isDelivered': false,
      'orderTime': Timestamp.now(),
    }).then((value) {
      orderId = value.id;
      print("Order Added");
    }).catchError((error) => print("Failed to add Order: $error"));
    return orderId;
  }

  addOrderToSellerOrderList({
    @required OrderModel orderModel,
    @required String sellerId,
  }) {
    print('Order processing...');
    cloudDb
        .collection('users')
        .doc(sellerId)
        .collection('orders-received')
        .add({
          'consumerId': user.uid,
          'consumerOrderId': orderModel.consumerOrderId,
          'foodItemId': orderModel.foodItemId,
          'isDelivered': false,
          'noOfItems': orderModel.noOfItems,
          'orderTime': Timestamp.now(),
        })
        .then((value) => print("Order Added to seller"))
        .catchError((error) => print("Failed to add Order to seller: $error"));
  }

  Stream<QuerySnapshot> getOrderHistorySnapshotsInDescOrder() {
    return cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('order-history')
        .orderBy(
          'orderTime',
          descending: true,
        )
        .snapshots();
  }

  Stream<QuerySnapshot> getCustomerOrdersSnapshotsInDescOrder() {
    return cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('orders-received')
        .orderBy(
          'orderTime',
          descending: true,
        )
        .snapshots();
  }

  Stream<QuerySnapshot> getFoodItemSnapshots() {
    return cloudDb.collection('food-items').snapshots();
  }

  getFoodItemInfo({String foodItemId}) async {
    FoodItemModel foodItemModel;
    await cloudDb.collection('food-items').doc(foodItemId).get().then((value) {
      foodItemModel = FoodItemModel(
        foodTitle: value.data()['title'],
        foodPrice: value.data()['price'],
        foodImgPath: value.data()['imgPath'],
        isAvailable: value.data()['isAvailable'],
      );
    });
    return foodItemModel;
  }

  Future addNewFoodItem({
    @required String title,
    @required String imgPath,
    @required int price,
    bool isAvailable = false,
  }) async {
    await cloudDb
        .collection('food-items')
        .add({
          'sellerId': user.uid,
          'title': title,
          'imgPath': imgPath,
          'price': price,
          'isAvailable': isAvailable,
        })
        .then((value) => print("Food item Added"))
        .catchError((error) => print("Failed to add food item: $error"));
  }

  updateFoodItemAvailability({
    @required String itemId,
    @required bool isAvailable,
  }) async {
    return await cloudDb
        .collection('food-items')
        .doc(itemId)
        .update({
          'isAvailable': isAvailable,
        })
        .then((value) => print("Availability Updated"))
        .catchError((error) => print("Failed to update availability: $error"));
  }

  updateFoodItemPrice({
    @required String itemId,
    @required int price,
  }) async {
    return await cloudDb
        .collection('food-items')
        .doc(itemId)
        .update({
          'price': price,
        })
        .then((value) => print("Price Updated"))
        .catchError((error) => print("Failed to update price: $error"));
  }

  Future<bool> confirmOrderDelivery({
    @required OrderModel order,
  }) async {
    bool result = false;
    print('order delivery processing...');
    await cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('orders-received')
        .doc(order.orderId)
        .update({
      'isDelivered': true,
    }).then((value) async {
      await cloudDb
          .collection('users')
          .doc(order.consumerId)
          .collection('order-history')
          .doc(order.consumerOrderId)
          .update({
        'isDelivered': true,
      }).then((_) async {
        result = true;
        return print("Order Delivery Updated");
      }).catchError(
              (error) => print("Failed to update Order Delivery: $error"));
    }).catchError((error) => print("Failed to update Order Delivery: $error"));
    return result;
  }

  // get chat snapshots
  getChatSnapshots(String consumerId, String sellerId) {
    return cloudDb
        .collection('users/$consumerId/chat-data/$sellerId/chats')
        .orderBy(
          'messageTime',
          descending: true,
        )
        .snapshots();
  }

  // send message to user/seller
  addNewMessage({
    String message,
    String userId,
    String sellerId,
  }) {
    cloudDb
        .collection('users/$userId/chat-data/$sellerId/chats')
        .add({
          'message': message,
          'messageTime': Timestamp.now(),
        })
        .then((_) => print("Message sent Successfully!"))
        .catchError((error) => print("Failed to send the message: $error"));
  }
}
