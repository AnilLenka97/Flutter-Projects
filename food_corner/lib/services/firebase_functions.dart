import 'package:cloud_functions/cloud_functions.dart';

class FirebaseCloudFunctions {
  static FirebaseFunctions _firebaseFunction = FirebaseFunctions.instance;

  // get all existing users from server
  static callGetAllUsers() async {
    return await _firebaseFunction
        .httpsCallable('getAllUsers')
        .call()
        .catchError((err) {
      print('Error: $err');
    });
  }

  // delete any particular user
  static callDeleteUser(String uid) async {
    return await _firebaseFunction
        .httpsCallable('deleteUser')
        .call(uid)
        .catchError((err) {
      print('Error: $err');
    });
  }

  // initiate push notification for order delivey successful
  static callOrderDeliveryPushNotification(Map data) async {
    return await _firebaseFunction
        .httpsCallable('orderDeliveredPushNotification')
        .call(data)
        .catchError((err) {
      print('Error: $err');
    });
  }
}
