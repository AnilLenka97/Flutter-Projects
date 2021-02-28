import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:food_corner/models/food_item_model.dart';
import 'package:food_corner/models/user_model.dart';

class FirebaseApi {
  var auth;
  var cloudDb;
  User user;
  Map userProfileInfo;

  FirebaseApi() {
    this.auth = FirebaseAuth.instance;
    this.cloudDb = FirebaseFirestore.instance;
    this.user = auth.currentUser;
  }

  void signOut() {
    auth.signOut();
  }

  getCurrentUserProfileInfo() async {
    await cloudDb.collection('users').doc(user.uid).get().then((value) {
      userProfileInfo = {
        'name': value.data()['name'],
        'floorNo': value.data()['floorNo'],
        'cubicleNo': value.data()['cubicleNo'],
        'role': value.data()['role'],
      };
    });
    return userProfileInfo;
  }

  getConsumerInfo({String consumerId}) async {
    UserModel userModel;
    await cloudDb.collection('users').doc(consumerId).get().then((value) {
      userModel = UserModel(
        userEmail: value.data()['email'],
        userName: value.data()['name'],
        userRole: value.data()['role'],
        userFloorNo: value.data()['floorNo'],
        userCubicleNo: value.data()['cubicleNo'],
      );
    });
    return userModel;
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

  void removeItemFromCart(String foodItemId) {
    cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('cart-items')
        .doc(foodItemId)
        .delete()
        .then((value) => print("Item Deleted from Cart"))
        .catchError(
            (error) => print("Failed to delete item from Cart: $error"));
  }

  // adding order data to firebase database
  void addItemToOrderHistory({
    String foodItemId,
    int noOfItems,
  }) {
    cloudDb
        .collection('users')
        .doc(user.uid)
        .collection('order-history')
        .add({
          'foodItemId': foodItemId,
          'noOfItems': noOfItems,
          'orderTime': Timestamp.now(),
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add Order: $error"));
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
}
