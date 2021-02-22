import 'package:flutter/cupertino.dart';

class CartItemCount extends ChangeNotifier {
  int noOfCartItems = 0;
  void changeCartItemCount(int count) {
    noOfCartItems = count;
    notifyListeners();
  }
}
