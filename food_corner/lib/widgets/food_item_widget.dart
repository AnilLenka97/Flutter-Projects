import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodItemWidget extends StatefulWidget {
  final String title;
  final String imgPath;
  final int price;
  final String id;
  final bool isItemAddedToCart;
  FoodItemWidget(
      {@required this.title,
      @required this.imgPath,
      @required this.price,
      @required this.id,
      @required this.isItemAddedToCart});
  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {
  bool _isAddedToCart;
  bool _isClicked = false;
  final String _userId = FirebaseAuth.instance.currentUser.uid;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addFoodItemToCart(itemId) {
    return _users
        .doc(_userId)
        .collection('cart-items')
        .doc(itemId)
        .set({
          'noOfItems': 1,
        })
        .then((value) => print("Item Added to Cart"))
        .catchError((error) => print("Failed to add item to Cart: $error"));
  }

  @override
  void initState() {
    super.initState();
    _isAddedToCart = widget.isItemAddedToCart;
    _isClicked = widget.isItemAddedToCart;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.network(
                  widget.imgPath,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 12,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    color: Colors.black54,
                  ),
                  width: 230,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        '₹ ${widget.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: _isAddedToCart ? Colors.grey : Colors.green,
            ),
            child: RawMaterialButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isAddedToCart
                        ? Icons.check_circle
                        : Icons.add_shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    _isAddedToCart ? 'added to cart' : 'add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              onPressed: _isClicked
                  ? null
                  : () {
                      addFoodItemToCart(widget.id);
                      setState(() {
                        _isAddedToCart = true;
                        _isClicked = true;
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }
}
