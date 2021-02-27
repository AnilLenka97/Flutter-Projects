import 'package:flutter/material.dart';
import 'package:food_corner/widgets/seller/food_item_form_widget.dart';
import '../../widgets/seller/food_item_widget.dart';
import '../../services/firebase_api.dart';
import '../../widgets/spinner_widget.dart';
import '../../widgets/drawer_widget.dart';

class SellerHomeScreen extends StatefulWidget {
  static const String id = 'SellerHomeScreen';
  final String userEmail;
  final String userName;
  SellerHomeScreen({
    @required this.userEmail,
    @required this.userName,
  });
  @override
  _SellerHomeScreenState createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();
  String userEmail;
  String userName;
  bool _isLoading = true;

  @override
  void initState() {
    userEmail = widget.userEmail;
    userName = widget.userName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner'),
      ),
      drawer: DrawerWidget(
        userName: userName,
        userEmail: userEmail,
      ),
      body: StreamBuilder(
        stream: _firebaseApi.getFoodItemSnapshots(),
        builder: (context, foodItemSnapshot) {
          if (foodItemSnapshot.connectionState == ConnectionState.waiting)
            return Spinner();
          final foodItems = foodItemSnapshot.data.docs;

          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) => FoodItem(
              itemId: foodItems[index].id,
              title: foodItems[index]['title'],
              imgPath: foodItems[index]['imgPath'],
              price: foodItems[index]['price'],
              isAvailable: foodItems[index]['isAvailable'],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 5.0,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                child: FoodItemFormWidget(),
              ),
            ),
          );
        },
      ),
    );
  }
}
