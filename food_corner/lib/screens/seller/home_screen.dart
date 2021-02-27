import 'package:flutter/material.dart';
import '../../services/firebase_api.dart';
import '../../widgets/spinner_widget.dart';
import '../../widgets/drawer_widget.dart';

class SellerHomeScreen extends StatefulWidget {
  static const String id = 'SellerHomeScreen';

  @override
  _SellerHomeScreenState createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  String userEmail;
  String userName;
  bool _isLoading = true;

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
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Spinner();
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner'),
      ),
      drawer: DrawerWidget(
        userName: userName,
        userEmail: userEmail,
      ),
      body: Center(
        child: Text('You are in seller account!'),
      ),
    );
  }
}
