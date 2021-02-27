import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

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

  getUserProfileInfo() async {
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

  Future<bool> updateUserProfileInfo({
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
    return true;
  }

  void updateDeviceToken(String token) {
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

  Stream<QuerySnapshot> getFoodItemSnapshots() {
    return cloudDb.collection('food-items').snapshots();
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
