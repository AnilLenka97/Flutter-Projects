import 'package:flutter/material.dart';
import 'package:food_corner/screens/food_item_screen.dart';
import 'package:food_corner/screens/login_screen.dart';
import 'package:food_corner/screens/registration_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOOD CORNER',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        FoodItemScreen.id: (context) => FoodItemScreen(),
      },
    );
  }
}
