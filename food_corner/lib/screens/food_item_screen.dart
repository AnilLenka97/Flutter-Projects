import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:food_corner/services/local_auth.dart';
import 'package:provider/provider.dart';
import '../services/firebase_api.dart';
import '../widgets/spinner_widget.dart';
import '../widgets/food_item_widget.dart';
import '../widgets/drawer_widget.dart';
import 'cart_screen.dart';

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
  bool localAuthCheck;

  authenticateUser() async {
    bool authResult = await LocalAuth.authenticate();
    if (!authResult) FirebaseApi().signOut();
    if (!mounted) return;
    setState(() {
      localAuthCheck = !authResult;
    });
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

  @override
  void initState() {
    super.initState();
    localAuthCheck = !LocalAuth.isLoggedInByUserIdAndPassword;
    if (localAuthCheck) authenticateUser();
    getCurrentUser();
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
              List<String> cartItemIdList = [];
              for (var data in cartItemDocs) {
                cartItemIdList.add(data.id);
              }
              return ListView.builder(
                itemCount: foodDocs.length,
                itemBuilder: (ctx, index) => FoodItemWidget(
                  title: foodDocs[index]['title'],
                  imgPath: foodDocs[index]['imgPath'],
                  price: foodDocs[index]['price'],
                  id: foodDocs[index].id,
                  isItemAddedToCart: cartItemIdList.contains(foodDocs[index].id)
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
