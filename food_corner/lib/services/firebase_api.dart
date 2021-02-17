import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApi {
  var auth;
  var cloudDb;
  User user;
  FirebaseApi() {
    this.auth = FirebaseAuth.instance;
    this.cloudDb = FirebaseFirestore.instance;
    this.user = auth.currentUser;
  }

  getUserProfileInfo() {}

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
}
