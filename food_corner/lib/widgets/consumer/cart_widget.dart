import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/food_item_model.dart';

class CartWidget extends StatefulWidget {
  final FoodItemModel foodItem;
  final int noOfItems;
  CartWidget({
    @required this.foodItem,
    @required this.noOfItems,
  });
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _userId = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  void changeNoOfItemsInCart(int val) {
    _users
        .doc(_userId)
        .collection('cart-items')
        .doc(widget.foodItem.foodItemId)
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
        .doc(widget.foodItem.foodItemId)
        .delete()
        .then((value) => print("Food item Deleted"))
        .catchError((error) => print("Failed to delete the item: $error"));
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
                  widget.foodItem.foodImgPath,
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
                    widget.foodItem.foodTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    '₹ ${widget.foodItem.foodPrice * widget.noOfItems}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    'No of items : ${widget.noOfItems}',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          int val = widget.noOfItems - 1;
                          if (val >= 1) {
                            changeNoOfItemsInCart(val);
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
                        constraints: BoxConstraints.tightFor(
                          width: 80,
                          height: 35,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RawMaterialButton(
                        onPressed: () {
                          int val = widget.noOfItems + 1;
                          if (val <= 5) {
                            changeNoOfItemsInCart(val);
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
