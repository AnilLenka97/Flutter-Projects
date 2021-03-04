import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/seller/food_setting_screen.dart';
import 'package:flutter/material.dart';
import './services/local_auth.dart';
import './screens/consumer/cart_screen.dart';
import './screens/consumer/home_screen.dart';
import './screens/login_screen.dart';
import './screens/consumer/order_screen.dart';
import './screens/profile_screen.dart';
import './widgets/spinner_widget.dart';
import './screens/admin/home_screen.dart';
import './screens/seller/home_screen.dart';
import './screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting)
            return Spinner();
          if (userSnapshot.hasData) return HomeScreen();
          LocalAuth.isLoggedInByUserIdAndPassword = true;
          return LoginScreen();
        },
      ),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        ConsumerHomeScreen.id: (context) => ConsumerHomeScreen(),
        CartScreen.id: (context) => CartScreen(),
        OrderScreen.id: (context) => OrderScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        AdminHomeScreen.id: (context) => AdminHomeScreen(),
        SellerHomeScreen.id: (context) => SellerHomeScreen(),
        FoodSettingScreen.id: (context) => FoodSettingScreen(),
      },
    );
  }
}
