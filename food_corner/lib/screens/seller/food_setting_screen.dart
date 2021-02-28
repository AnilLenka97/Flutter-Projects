import 'package:flutter/material.dart';
import '../../services/firebase_api.dart';
import '../../widgets/seller/food_item_form_widget.dart';
import '../../widgets/seller/food_item_widget.dart';
import '../../widgets/spinner_widget.dart';

class FoodSettingScreen extends StatefulWidget {
  static const String id = 'FoodSettingScreen';
  @override
  _FoodSettingScreenState createState() => _FoodSettingScreenState();
}

class _FoodSettingScreenState extends State<FoodSettingScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Setting'),
      ),
      body: StreamBuilder(
        stream: _firebaseApi.getFoodItemSnapshots(),
        builder: (context, foodItemSnapshot) {
          if (foodItemSnapshot.connectionState == ConnectionState.waiting)
            return Spinner();
          final foodItems = foodItemSnapshot.data.docs;

          return ListView.builder(
            itemCount: foodItems.length,
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
