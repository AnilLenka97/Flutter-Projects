import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:food_corner/models/user_model.dart';
import 'package:food_corner/services/firebase_api.dart';
import 'package:food_corner/widgets/admin/user_widget.dart';
import 'package:food_corner/widgets/drawer_widget.dart';
import 'package:food_corner/widgets/spinner_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  static const String id = 'AdminHomeScreen';
  final userName;
  final userEmail;
  AdminHomeScreen({@required this.userEmail, @required this.userName});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final _firebaseFunction = FirebaseFunctions.instance;
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
      userIdList = await _firebaseFunction
          .httpsCallable('getAllUsers')
          .call()
          .catchError((err) {
        print('Error: $err');
      });
      print(userIdList.data);
      int x = 1;
      for (var user in userIdList.data) {
        userList.add(await _firebaseApi.getUserInfo(userId: user['uid']));
        print('loop....................${x++}');
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
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Corner(Manage Users)'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('clicked');
          Navigator.of(context).build(context);
        },
      ),
      drawer: DrawerWidget(
        userEmail: widget.userName,
        userName: widget.userEmail,
        isFoodSettingAvailable: true,
      ),
      body: _isLoading
          ? Spinner()
          : ListView.builder(
              itemCount: userIdList.data.length,
              itemBuilder: (context, index) => UserWidget(
                userModel: userList[index],
                updateUserListScreen: updateUserListScreen,
              ),
            ),
    );
  }
}
