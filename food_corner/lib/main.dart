import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/cart_screen.dart';
import './screens/food_item_screen.dart';
import './screens/login_screen.dart';
import './screens/order_screen.dart';
import './screens/profile_screen.dart';
import './widgets/spinner_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        backgroundColor: Color(0xFFC5D1CE),
        accentColor: Colors.greenAccent,
        accentColorBrightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<CartItemCount>(
        create: (ctx) => CartItemCount(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting)
              return Spinner();
            if (userSnapshot.hasData) return FoodItemScreen();
            return LoginScreen();
          },
        ),
      ),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        FoodItemScreen.id: (context) => FoodItemScreen(),
        CartScreen.id: (context) => CartScreen(),
        OrderScreen.id: (context) => OrderScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
    );
  }
}
