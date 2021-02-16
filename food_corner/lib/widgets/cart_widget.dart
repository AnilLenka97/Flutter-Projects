import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartWidget extends StatefulWidget {
  final String foodItemId;
  final String foodName;
  final int price;
  final int noOfItems;
  CartWidget(
      {@required this.foodName,
      @required this.foodItemId,
      @required this.price,
      @required this.noOfItems});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  int noOfItems = 1;
  int foodPrice;
  int totalPrice;
  final _userId = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  void changeNoOfItemsInCart(int val) {
    _users
        .doc(_userId)
        .collection('cart-items')
        .doc(widget.foodItemId)
        .set({
          'noOfItems': val,
        })
        .then((value) => print("Item Added to Cart"))
        .catchError((error) => print("Failed to add item to Cart: $error"));
  }

  void removeItemFromCart() {
    _users
        .doc(_userId)
        .collection('cart-items')
        .doc(widget.foodItemId)
        .delete()
        .then((value) => print("Food item Deleted"))
        .catchError((error) => print("Failed to delete the item: $error"));
  }

  @override
  void initState() {
    super.initState();
    foodPrice = widget.price;
    noOfItems = widget.noOfItems;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Card(
        color: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 7,
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
                  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mnx8bWVhbHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.foodName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    '₹ $foodPrice',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    'No of items : $noOfItems',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          int val = noOfItems - 1;
                          if (val >= 1) {
                            changeNoOfItemsInCart(val);
                            setState(() {
                              foodPrice = foodPrice - widget.price;
                            });
                          } else {
                            final snackBar = SnackBar(
                              elevation: 5,
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Want to remove the item from your cart? '),
                                  FlatButton(
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      removeItemFromCart();
                                      Scaffold.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ],
                              ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        elevation: 5,
                        fillColor: Colors.green,
                        constraints:
                            BoxConstraints.tightFor(width: 80, height: 35),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          int val = noOfItems + 1;
                          if (val <= 5) {
                            changeNoOfItemsInCart(val);
                            setState(() {
                              foodPrice = foodPrice - widget.price;
                            });
                          } else {
                            final snackBar = SnackBar(
                              content: Text(
                                  'You can\'t add more than 5 items in a particular category!'),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        elevation: 5,
                        fillColor: Colors.green,
                        constraints:
                            BoxConstraints.tightFor(width: 80, height: 35),
                      ),
                    ],
                  ),
                ],
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
