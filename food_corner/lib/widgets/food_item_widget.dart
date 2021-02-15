import 'package:flutter/material.dart';

class FoodItemWidget extends StatefulWidget {
  final title;
  final imgPath;
  final price;
  FoodItemWidget(
      {@required this.title, @required this.imgPath, @required this.price});
  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {
  var isAddedToCart = false;
  var isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
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
                bottom: 20,
                right: 10,
                child: Container(
                  width: 250,
                  color: Colors.black54,
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
              color: isAddedToCart ? Colors.grey : Colors.green,
            ),
            child: RawMaterialButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isAddedToCart
                        ? Icons.check_circle
                        : Icons.add_shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    isAddedToCart ? 'added to cart' : 'add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              onPressed: isClicked
                  ? null
                  : () {
                      setState(() {
                        isAddedToCart = true;
                        isClicked = true;
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }
}
