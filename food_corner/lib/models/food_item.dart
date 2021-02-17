import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String title;
  final String imgPath;
  final int price;
  FoodItem({
    this.id,
    this.title,
    this.imgPath,
    this.price,
  });

  uploadFoodItems(title, imgPath, price) async {
    await FirebaseFirestore.instance.collection('food-items').add({
      'title': title,
      'imgPath': imgPath,
      'price': price,
    });
  }

  foodItemConstructor() {
    uploadFoodItems(
      'food1',
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mnx8bWVhbHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',
      499,
    );
    uploadFoodItems(
      'food2',
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mnx8bWVhbHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',
      399,
    );
    uploadFoodItems(
      'food3',
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mnx8bWVhbHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80',
      599,
    );
  }

  var userData;
  getUserBasedData(userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      userData = value.data();
    });
    return userData;
  }
}
