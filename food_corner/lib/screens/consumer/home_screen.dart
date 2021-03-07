import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:food_corner/models/food_item_model.dart';
import '../../models/user_model.dart';
import '../../services/push_notification_handler.dart';
import '../../services/firebase_api.dart';
import '../../widgets/spinner_widget.dart';
import '../../widgets/consumer/food_item_widget.dart';
import '../../widgets/drawer_widget.dart';
import 'cart_screen.dart';

class ConsumerHomeScreen extends StatefulWidget {
  static const String id = 'ConsumerHomeScreen';
  final UserModel user;
  ConsumerHomeScreen({
    this.user,
  });

  @override
  _ConsumerHomeScreenState createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();
  final firebaseMessage = FirebaseMessaging();

  @override
  void initState() {
    PushNotificationHandler pushNotificationHandler =
        PushNotificationHandler(context: context);
    pushNotificationHandler.pushNotificationConfigure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Food Corner'),
        elevation: 5,
        actions: [
          Badge(
            padding: EdgeInsets.all(4.0),
            position: BadgePosition.topEnd(
              top: -2.0,
              end: 4.0,
            ),
            elevation: 3,
            animationType: BadgeAnimationType.fade,
            badgeColor: Colors.white70,
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
            badgeContent: StreamBuilder(
              stream: _firebaseApi.getCartItemSnapshots(),
              builder: (ctx, cartItemSnapshot) {
                return Text(
                  cartItemSnapshot.hasData
                      ? cartItemSnapshot.data.docs.length.toString()
                      : '',
                );
              },
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(
        userName: widget.user.userName ?? '',
        userEmail: widget.user.userEmail ?? '',
        isCartLinkAvailable: true,
        isOrderLinkAvailable: true,
      ),
      body: StreamBuilder(
        stream: _firebaseApi.getCartItemSnapshots(),
        builder: (ctx, cartItemSnapshot) {
          if (cartItemSnapshot.connectionState == ConnectionState.waiting) {
            return Spinner();
          }
          final cartItemDocs = cartItemSnapshot.data.docs;

          return StreamBuilder(
            stream: _firebaseApi.getFoodItemSnapshots(),
            builder: (ctx, foodSnapshots) {
              if (foodSnapshots.connectionState == ConnectionState.waiting) {
                return Spinner();
              }
              final foodDocs = foodSnapshots.data.docs;
              var availableFoodItemList = [];
              List<String> cartItemIdList = [];

              // disable 'add to cart' buttons if item is already added to cart
              for (var cartItem in cartItemDocs) {
                cartItemIdList.add(cartItem.id);
              }

              // show only available food items
              for (var foodItem in foodDocs) {
                if (foodItem['isAvailable'])
                  availableFoodItemList.add(foodItem);

                // delete cartItem from cart which is not available
                for (var cartItem in cartItemDocs) {
                  if (cartItem.id == foodItem.id && !foodItem['isAvailable'])
                    _firebaseApi.deleteItemFromCart(foodItem.id);
                }
              }
              return ListView.builder(
                itemCount: availableFoodItemList.length,
                itemBuilder: (ctx, index) => FoodItemWidget(
                  foodItem: FoodItemModel(
                    foodItemId: availableFoodItemList[index].id,
                    foodTitle: availableFoodItemList[index]['title'],
                    foodImgPath: availableFoodItemList[index]['imgPath'],
                    foodPrice: availableFoodItemList[index]['price'],
                  ),
                  isItemAddedToCart:
                      cartItemIdList.contains(availableFoodItemList[index].id)
                          ? true
                          : false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
