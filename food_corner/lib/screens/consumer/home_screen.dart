import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import '../../services/local_auth.dart';
import '../../widgets/dialog_box_widget.dart';
import '../../services/firebase_api.dart';
import '../../widgets/spinner_widget.dart';
import '../../widgets/food_item_widget.dart';
import '../../widgets/drawer_widget.dart';
import 'cart_screen.dart';
import 'order_screen.dart';

class ConsumerHomeScreen extends StatefulWidget {
  static const String id = 'ConsumerHomeScreen';
  final String userEmail;
  final String userName;
  ConsumerHomeScreen({
    @required this.userEmail,
    @required this.userName,
  });

  @override
  _ConsumerHomeScreenState createState() => _ConsumerHomeScreenState();
}

class _ConsumerHomeScreenState extends State<ConsumerHomeScreen> {
  String userEmail;
  String userName;
  int noOfCartItems = 0;
  var cartItemCountProvider;
  bool isBiometricsScanning = false;
  final firebaseMessage = FirebaseMessaging();

  initializeLocalAuthAndPushNotification() async {
    isBiometricsScanning = !LocalAuth.isLoggedInByUserIdAndPassword;
    if (isBiometricsScanning) {
      bool authResult = await LocalAuth.authenticate();
      // if (!authResult) {
      //   FirebaseApi().signOut();
      //   return;
      // }
      if (!mounted) return;
      // LocalAuth.isLoggedInByUserIdAndPassword = false;
      setState(() {
        isBiometricsScanning = !authResult;
      });
      pushNotificationConfigure();
    }
    pushNotificationConfigure();
  }

  static Future<dynamic> backgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      print(data);
    }

    if (message.containsKey('notification')) {
      print('Notification Message');
      final dynamic notification = message['notification'];
      print(notification);
    }
  }

  pushNotificationConfigure() async {
    try {
      firebaseMessage.configure(
        onMessage: (msg) async {
          await showDialog(
            context: context,
            builder: (context) {
              return NotificationAlert(
                title: 'Title',
                message: 'This is a sample text.',
              );
            },
          );
          return;
        },
        onResume: (msg) async {
          print('onResume: $msg');
          await Navigator.pushNamed(context, OrderScreen.id);
          return;
        },
        onLaunch: (msg) async {
          print('onLaunch: $msg');
          await Navigator.pushNamed(context, OrderScreen.id);
          return;
        },
        onBackgroundMessage: backgroundMessageHandler,
      );
      firebaseMessage.getToken().then((token) {
        FirebaseApi().updateDeviceToken(token);
      });
    } catch (err) {
      print('firebaseMessagingError: $err');
    }
  }

  @override
  void initState() {
    userEmail = widget.userEmail;
    userName = widget.userName;
    // initializeLocalAuthAndPushNotification();
    super.initState();
    // cartItemCountProvider = Provider.of<CartItemCount>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (isBiometricsScanning) return Spinner();
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
            // badgeContent: Text(noOfItemsAddedToCart.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
            // badgeContent: Consumer<CartItemCount>(
            //   builder: (ctx, value, child) =>
            //       Text(value.noOfCartItems.toString()),
            // ),
            badgeContent: StreamBuilder(
              stream: FirebaseApi().getCartItemSnapshots(),
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
        userEmail: userEmail,
        userName: userName,
        isCartLinkAvailable: true,
        isOrderLinkAvailable: true,
      ),
      body: StreamBuilder(
        stream: FirebaseApi().getCartItemSnapshots(),
        builder: (ctx, cartItemSnapshot) {
          if (cartItemSnapshot.connectionState == ConnectionState.waiting) {
            return Spinner();
          }
          final cartItemDocs = cartItemSnapshot.data.docs;

          // setState(() {
          //   noOfCartItems = cartItemDocs.length;
          // });
          //cartItemCountProvider.changeCartItemCount(cartItemDocs.length);

          return StreamBuilder(
            stream: FirebaseApi().getFoodItemSnapshots(),
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
                    FirebaseApi().removeItemFromCart(foodItem.id);
                }
              }
              return ListView.builder(
                itemCount: availableFoodItemList.length,
                itemBuilder: (ctx, index) => FoodItemWidget(
                  title: availableFoodItemList[index]['title'],
                  imgPath: availableFoodItemList[index]['imgPath'],
                  price: availableFoodItemList[index]['price'],
                  id: availableFoodItemList[index].id,
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
