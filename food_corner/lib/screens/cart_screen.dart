import 'package:flutter/material.dart';
import '../services/firebase_api.dart';
import '../widgets/empty_page_with_button.dart';
import '../widgets/spinner_widget.dart';
import '../widgets/cart_widget.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'CartScreen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var cartData;

  //adding order data to database
  void initiateOrders() {
    for (var data in cartData) {
      FirebaseApi().addItemToOrderHistory(
        noOfItems: data['noOfItems'],
        foodItemId: data.id,
      );
      FirebaseApi().removeItemFromCart(data.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: FirebaseApi().getCartItemSnapshots(),
        builder: (ctx, cartFoodSnapshots) {
          if (cartFoodSnapshots.connectionState == ConnectionState.waiting)
            return Spinner();
          final cartFoodDocs = cartFoodSnapshots.data.docs;
          cartData = cartFoodDocs;
          if (cartFoodDocs.length == 0)
            return EmptyPageWithAButton(
              message: 'No items in Cart',
              buttonTitle: 'See Items!',
              onPress: () {
                Navigator.pop(context);
              },
            );
          return StreamBuilder(
            stream: FirebaseApi().getFoodItemSnapshots(),
            builder: (ctx, foodItemSnapshots) {
              if (foodItemSnapshots.connectionState == ConnectionState.waiting)
                return Spinner();
              final foodItemDocs = foodItemSnapshots.data.docs;
              var cartList = [];
              var cartItemNumberList = [];
              for (var cartItem in cartFoodDocs) {
                for (var foodItem in foodItemDocs) {
                  if (cartItem.id == foodItem.id) {
                    cartItemNumberList.add(cartItem['noOfItems']);
                    cartList.add(foodItem);
                  }
                }
              }
              return ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (ctx, index) => CartWidget(
                  foodItemId: cartList[index].id,
                  foodName: cartList[index]['title'],
                  imgPath: cartList[index]['imgPath'],
                  price: cartList[index]['price'],
                  noOfItems: cartItemNumberList[index],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 45,
        child: RawMaterialButton(
          child: Text(
            'Make Order',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          fillColor: Colors.green,
          onPressed: () {
            initiateOrders();
          },
        ),
      ),
    );
  }
}
