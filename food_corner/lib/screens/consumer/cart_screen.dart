import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../models/food_item_model.dart';
import '../../models/order_model.dart';
import '../../services/firebase_api.dart';
import '../../widgets/empty_page_with_button.dart';
import '../../widgets/spinner_widget.dart';
import '../../widgets/dialog_box_widget.dart';
import '../../widgets/consumer/cart_widget.dart';
import 'order_screen.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'CartScreen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();
  var cartData;
  var cartFoodItemList;
  //adding order data to both user and seller database
  void initiateOrders() async {
    int index = 0;
    for (var cartItem in cartData) {
      // oder details added to consumer order history
      String newOrderId = await _firebaseApi.addItemToOrderHistory(
        noOfItems: cartItem['noOfItems'],
        foodItemId: cartItem.id,
        price: cartFoodItemList[index]['price'],
      );
      // oder details added to seller order received list
      if (newOrderId.isNotEmpty)
        await _firebaseApi.addOrderToSellerOrderList(
          orderModel: OrderModel(
            foodItemId: cartItem.id,
            consumerOrderId: newOrderId,
            price: cartFoodItemList[index]['price'],
            noOfItems: cartItem['noOfItems'],
          ),
          sellerId: cartFoodItemList[index]['sellerId'],
        );
      index += 1;
    }
    // food item deletes after order placed
    for (var cartItem in cartData)
      await _firebaseApi.deleteItemFromCart(cartItem.id);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertWidget(
          title: 'Your Order(s) Placed Successfully',
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
              for (var cartItem in cartFoodDocs)
                for (var foodItem in foodItemDocs)
                  if (cartItem.id == foodItem.id) cartList.add(foodItem);
              cartFoodItemList = cartList;
              return ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (ctx, index) => CartWidget(
                  foodItem: FoodItemModel(
                    foodItemId: cartList[index].id,
                    foodTitle: cartList[index]['title'],
                    foodImgPath: cartList[index]['imgPath'],
                    foodPrice: cartList[index]['price'],
                  ),
                  noOfItems: cartFoodDocs[index]['noOfItems'],
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
