import 'package:flutter/material.dart';
import '../../services/firebase_functions.dart';
import '../../services/push_notification_handler.dart';
import '../../widgets/admin/user_widget.dart';
import '../../models/user_model.dart';
import '../../widgets/spinner_widget.dart';
import '../../services/firebase_api.dart';
import '../../widgets/drawer_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  static const String id = 'AdminHomeScreen';
  final UserModel user;
  AdminHomeScreen({this.user});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseApi _firebaseApi = FirebaseApi();
  bool _isLoading = true;
  List<UserModel> userList = [];
  var userIdList;

  updateUserListScreen() {
    userList = [];
    getAllUsers();
  }

  getAllUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      userIdList = await FirebaseCloudFunctions.callGetAllUsers();
      for (var user in userIdList.data) {
        userList.add(await _firebaseApi.getUserInfo(userId: user['uid']));
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    PushNotificationHandler pushNotificationHandler =
        PushNotificationHandler(context: context);
    pushNotificationHandler.pushNotificationConfigure();
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner(Manage Users)'),
      ),
      drawer: DrawerWidget(
        userName: widget.user.userName ?? '',
        userEmail: widget.user.userEmail ?? '',
        isFoodSettingAvailable: true,
      ),
      body: _isLoading
          ? Spinner()
          : ListView.builder(
              itemCount: userIdList.data.length,
              itemBuilder: (context, index) => UserWidget(
                user: userList[index],
                updateUserListScreen: updateUserListScreen,
              ),
            ),
    );
  }
}
