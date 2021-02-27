import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import '../services/local_auth.dart';
import '../widgets/dialog_box_widget.dart';
import '../services/firebase_api.dart';
import '../widgets/spinner_widget.dart';
import '../widgets/food_item_widget.dart';
import '../widgets/drawer_widget.dart';
import 'cart_screen.dart';
import 'order_screen.dart';
import './admin/home_screen.dart';
import './seller/home_screen.dart';

class FoodItemScreen extends StatefulWidget {
  static const String id = 'FoodItemScreen';

  @override
  _FoodItemScreenState createState() => _FoodItemScreenState();
}

class _FoodItemScreenState extends State<FoodItemScreen> {
  var _isLoading = true;
  String userEmail;
  String userName;
  int noOfCartItems = 0;
  var cartItemCountProvider;
  bool localAuthCheck = false;
  final firebaseMessage = FirebaseMessaging();

  initializeLocalAuthAndPushNotification() async {
    localAuthCheck = !LocalAuth.isLoggedInByUserIdAndPassword;
    if (localAuthCheck) {
      bool authResult = await LocalAuth.authenticate();
      // if (!authResult) {
      //   FirebaseApi().signOut();
      //   return;
      // }
      if (!mounted) return;
      // LocalAuth.isLoggedInByUserIdAndPassword = false;
      setState(() {
        localAuthCheck = !authResult;
      });
      pushNotificationConfigure();
    }
    pushNotificationConfigure();
  }

  getCurrentUser() async {
    userEmail = FirebaseApi().user.email;
    Map userProfileInfo = await FirebaseApi().getUserProfileInfo();
    userName = userProfileInfo['name'];
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
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

  initializeHomeScreen() async {
    var userInfo = await FirebaseApi().getUserProfileInfo();
    if (userInfo['role'] == 'admin') {
      Navigator.pop(context);
      Navigator.pushNamed(context, AdminHomeScreen.id);
    } else if (userInfo['role'] == 'seller') {
      Navigator.pop(context);
      Navigator.pushNamed(context, SellerHomeScreen.id);
    } else {
      // Navigator.pop(context);
      // Navigator.pushNamed(context, AdminHomeScreen.id);
    }
  }

  @override
  void initState() {
    initializeHomeScreen();
    // initializeLocalAuthAndPushNotification();
    getCurrentUser();
    super.initState();
    // cartItemCountProvider = Provider.of<CartItemCount>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (localAuthCheck || _isLoading) return Spinner();
    // if () return Spinner();
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
        onTapOnLogout: () {
          FirebaseApi().signOut();
        },
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
