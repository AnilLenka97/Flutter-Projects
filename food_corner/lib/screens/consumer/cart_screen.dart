import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_corner/models/order_model.dart';
import '../../services/firebase_api.dart';
import '../../widgets/empty_page_with_button.dart';
import '../../widgets/spinner_widget.dart';
import '../../widgets/dialog_box_widget.dart';
import '../../widgets/cart_widget.dart';
import 'order_screen.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'CartScreen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();
  var cartData;
  List<String> sellerIdList = [];

  //adding order data to database
  void initiateOrders() async {
    int index = 0;
    for (var cartItem in cartData) {
      await _firebaseApi.addItemToOrderHistory(
        noOfItems: cartItem['noOfItems'],
        foodItemId: cartItem.id,
      );
      await _firebaseApi.addOrderToSellerOrderList(
        orderModel: OrderModel(
          foodItemId: cartItem.id,
          noOfItems: cartItem['noOfItems'],
        ),
        sellerId: sellerIdList[index++],
      );
      await _firebaseApi.removeItemFromCart(cartItem.id);
    }
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return NotificationAlert(
          title: 'Your Order(s) Placed Successfully',
          message: 'Thank You!',
          actionWidget: FlatButton(
            child: Text('Goto Orders'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, OrderScreen.id);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: _firebaseApi.getCartItemSnapshots(),
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
            stream: _firebaseApi.getFoodItemSnapshots(),
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
                    sellerIdList.add(foodItem['sellerId']);
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
        child: StreamBuilder(
          stream: _firebaseApi.getCartItemSnapshots(),
          builder: (ctx, cartFoodSnapshots) {
            if (cartFoodSnapshots.connectionState == ConnectionState.waiting)
              return Spinner();
            bool isCartEmpty =
                cartFoodSnapshots.data.docs.length == 0 ? true : false;
            return RawMaterialButton(
              child: Text(
                'Make Order',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              fillColor: isCartEmpty ? Colors.grey : Colors.green,
              onPressed: isCartEmpty
                  ? null
                  : () {
                      initiateOrders();
                    },
            );
          },
        ),
      ),
    );
  }
}
