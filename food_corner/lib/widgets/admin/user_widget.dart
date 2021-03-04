import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:food_corner/models/user_model.dart';
import 'package:food_corner/services/firebase_api.dart';
import 'package:food_corner/widgets/spinner_widget.dart';

import '../dialog_box_widget.dart';

class UserWidget extends StatefulWidget {
  final UserModel userModel;
  final Function updateUserListScreen;

  const UserWidget({Key key, this.userModel, this.updateUserListScreen})
      : super(key: key);
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  final _firebaseFunction = FirebaseFunctions.instance;
  final FirebaseApi _firebaseApi = FirebaseApi();
  bool _isDeleting = false;

  deleteUser(uid) async {
    var response;
    try {
      response = await _firebaseFunction
          .httpsCallable('deleteUser')
          .call(uid)
          .catchError((err) {
        print('Error: $err');
      });
      if (response.data) {
        await _firebaseApi.deleteUserData(userId: uid);
        print("Deleted Successfully!");
        widget.updateUserListScreen();
      } else
        print("Deletion Failed!");
      if (!mounted) return;
      setState(() {
        _isDeleting = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleting) return Spinner();
    if (widget.userModel.userRole == 'admin') return Container();
    return Card(
      color: Colors.green[200],
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userModel.userName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Role: ${widget.userModel.userRole}',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${widget.userModel.userEmail}'),
                  Text(
                    'Id: ${widget.userModel.userId}',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                color: Colors.red[300],
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertWidget(
                        title:
                            'By deleting the user, the user and user data will be permanently deleted. Do you want to continue deleting process?',
                        defaultActionButtonTitle: 'Cancel',
                        actionWidget: RaisedButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          child: Text('Yes, Continue!'),
                          onPressed: () {
                            Navigator.pop(context);
                            deleteUser(widget.userModel.userId);
                            setState(() {
                              _isDeleting = true;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
