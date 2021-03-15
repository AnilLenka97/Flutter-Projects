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
  final FirebaseApi _firebaseApi = FirebaseApi();
  final firebaseMessage = FirebaseMessaging();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _foodItemList = [];
  var cartItemsSnaps;
  final int documentLimit = 3;
  bool _hasNext = true;
  bool _isFetchingData = false;
  bool _isLoading = true;
  bool _isCartItemsAccessedFirstTime = false;

  // get food items from data base
  getFoodItems() async {
    if (_isFetchingData) return;
    _isFetchingData = true;
    final foodDocsSnapshot = await _firebaseApi.getFoodItems(
      limit: documentLimit,
      getAvailableItem: true,
      lastDocument:
          _foodItemList.isNotEmpty ? _foodItemList.last['foodItem'] : null,
    );

    for (var foodItem in foodDocsSnapshot.docs) {
      bool isItemAddedToCart = false;
      for (var cartItem in cartItemsSnaps.docs)
        if (foodItem.id == cartItem.id) isItemAddedToCart = true;
      _foodItemList.add(
        {
          'foodItem': foodItem,
          'isItemAddedToCart': isItemAddedToCart,
        },
      );
    }

    if (foodDocsSnapshot.docs.length < documentLimit) _hasNext = false;
    _isFetchingData = false;
    setState(() {
      _isLoading = false;
    });
  }

  // get cart items
  getCartItems() async {
    cartItemsSnaps = await _firebaseApi.getCartItems();
    if (!_isCartItemsAccessedFirstTime) getFoodItems();
    _isCartItemsAccessedFirstTime = true;
  }

  // Scroll listener used to load next few Items when the user reach to the end of the doc
  void scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_hasNext) {
        getFoodItems();
      }
    }
  }

  @override
  void initState() {
    PushNotificationHandler pushNotificationHandler =
        PushNotificationHandler(context: context);
    pushNotificationHandler.pushNotificationConfigure();
    getCartItems();
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Spinner();
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
      body: ListView(
        controller: _scrollController,
        children: [
          ..._foodItemList
              .map(
                (foodItemMap) => FoodItemWidget(
                  foodItem: FoodItemModel(
                    foodItemId: foodItemMap['foodItem'].id,
                    foodTitle: foodItemMap['foodItem']['title'],
                    foodImgPath: foodItemMap['foodItem']['imgPath'],
                    foodPrice: foodItemMap['foodItem']['price'],
                  ),
                  isItemAddedToCart: foodItemMap['isItemAddedToCart'],
                ),
              )
              .toList(),
          if (_hasNext) Spinner(),
          if (!_hasNext)
            Center(
              heightFactor: 3.0,
              child: Text('End of the items.'),
            ),
        ],
      ),

      // disable 'add to cart' buttons if item is already added to cart
      //     for (var cartItem in cartItemDocs) {
      //       cartItemIdList.add(cartItem.id);
      //     }
      //
      // show only available food items
      // for (var foodItem in foodDocs) {
      //   // if (foodItem['isAvailable'])
      //     // availableFoodItemList.add(foodItem);
      //
      //   // delete cartItem from cart which is not available
      //   for (var cartItem in cartItemDocs) {
      //     if (cartItem.id == foodItem.id && !foodItem['isAvailable'])
      //       _firebaseApi.deleteItemFromCart(foodItem.id);
      //   }
      // }
    );
  }
}
