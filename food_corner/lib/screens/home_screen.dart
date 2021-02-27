import 'package:flutter/material.dart';
import './consumer/home_screen.dart';
import './seller/home_screen.dart';
import '../services/firebase_api.dart';
import '../widgets/spinner_widget.dart';
import './admin/home_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();
  bool _isLoading = true;
  String userEmail;
  String userName;
  String userRole;

  initializeHomeScreen() async {
    var userInfo = await _firebaseApi.getUserProfileInfo();
    userName = userInfo['name'];
    userRole = userInfo['role'];
    userEmail = _firebaseApi.user.email;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    initializeHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/food_corner_logo_internal.png'),
            Text(
              'Welcome to Food Corner',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 30.0,
              ),
            ),
            Spinner(),
          ],
        ),
      );
    else if (userRole == 'admin')
      return AdminHomeScreen(
        userName: userName,
        userEmail: userEmail,
      );
    else if (userRole == 'seller')
      return SellerHomeScreen(
        userName: userName,
        userEmail: userEmail,
      );
    else
      return ConsumerHomeScreen(
        userName: userName,
        userEmail: userEmail,
      );
  }
}
