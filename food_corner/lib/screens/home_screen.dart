import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/local_auth.dart';
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
  UserModel user;
  bool _isLoading = true;
  String userRole;
  bool isAuthenticationSuccessful = false;

  initializeHomeScreen() async {
    user = await _firebaseApi.getUserInfo();
    userRole = user.userRole;
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  initializeLocalAuthentication() async {
    if (!LocalAuth.isLoggedInByUserIdAndPassword) {
      bool authResult = await LocalAuth.authenticate();
      if (!authResult) {
        FirebaseApi().signOut();
        return;
      }
      if (!mounted) return;
      setState(() {
        isAuthenticationSuccessful = authResult;
      });
    } else
      setState(() {
        isAuthenticationSuccessful = true;
      });
  }

  @override
  void initState() {
    // initializeLocalAuthentication();
    initializeHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading || !isAuthenticationSuccessful)
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
        user: user,
      );
    else if (userRole == 'seller')
      return SellerHomeScreen(
        user: user,
      );
    else
      return ConsumerHomeScreen(
        user: user,
      );
  }
}
