import 'package:flutter/material.dart';

class CartWidget extends StatefulWidget {
  final String foodName;
  final int price;
  CartWidget({@required this.foodName, @required this.price});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  int noOfItems = 1;
  int foodPrice;
  int totalPrice;

  @override
  void initState() {
    super.initState();
    foodPrice = widget.price;
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
                          setState(() {
                            noOfItems -= 1;
                            foodPrice = foodPrice - widget.price;
                          });
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
                          setState(() {
                            noOfItems += 1;
                            foodPrice = foodPrice + widget.price;
                          });
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
