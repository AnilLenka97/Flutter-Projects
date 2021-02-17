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

  Stream<dynamic> getOrderHistorySnapshotsInDescOrder() {
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

  Stream<dynamic> getFoodItemSnapshots() {
    return cloudDb.collection('food-items').snapshots();
  }
}
