import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/floor_details.dart';
import '../services/firebase_api.dart';
import '../widgets/spinner_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'ProfileScreen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail;
  String _userName;
  String _userFloorNo;
  int _userCubicleNo;
  bool _isLoading = true;
  bool _isEditModeActive = false;

  void getUserData() async {
    _userEmail = FirebaseApi().user.email;
    Map userProfileInfo = await FirebaseApi().getUserProfileInfo();
    _userName = userProfileInfo['name'];
    _userFloorNo = userProfileInfo['floorNo'];
    _userCubicleNo = userProfileInfo['cubicleNo'];
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      // update user information
      bool isCompleted = await FirebaseApi().updateUserProfileInfo(
        name: _userName.trim(),
        floorNo: _userFloorNo,
        cubicleNo: _userCubicleNo,
      );
      setState(() {
        _isLoading = !isCompleted;
      });
      setState(() {
        _isEditModeActive = !_isEditModeActive;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _isLoading
          ? Spinner()
          : Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5.0,
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    width: double.infinity,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Icon(
                            Icons.person,
                            size: 200,
                            color: Colors.grey,
                          ),
                          _isEditModeActive
                              ? TextFormField(
                                  key: ValueKey('name'),
                                  initialValue: _userName,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter your name.';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(labelText: 'Name'),
                                  onSaved: (value) {
                                    _userName = value;
                                  },
                                )
                              : Text(
                                  _userName,
                                  key: ValueKey('name'),
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.center,
                                ),
                          if (!_isEditModeActive)
                            Text(
                              _userEmail,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                            ),
                          SizedBox(
                            height: 8,
                          ),
                          _isEditModeActive
                              ? DropdownButtonFormField(
                                  value: _userFloorNo,
                                  onChanged: (value) {
                                    setState(() {
                                      _userFloorNo = value;
                                    });
                                  },
                                  items: Floor()
                                      .floorInfo
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList(),
                                  hint: Text('Choose Floor'),
                                )
                              : Text(
                                  'Floor : $_userFloorNo',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.center,
                                ),
                          SizedBox(
                            height: 8,
                          ),
                          _isEditModeActive
                              ? TextFormField(
                                  key: ValueKey('cubicleNo'),
                                  initialValue: _userCubicleNo.toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter your cubicle number.';
                                    }
                                    final n = num.tryParse(value);
                                    if (n == null) {
                                      return '"$value" is not a valid number';
                                    } else if (n == 0) {
                                      return 'Please enter a valid cubicle number.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Cubicle Number'),
                                  onSaved: (value) {
                                    _userCubicleNo = num.tryParse(value);
                                  },
                                )
                              : Text(
                                  'Cubicle No : ${_userCubicleNo.toString()}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.center,
                                ),
                          SizedBox(
                            height: 15.0,
                          ),
                          if (_isLoading) Spinner(),
                          if (!_isLoading)
                            RaisedButton(
                              padding: EdgeInsets.all(4),
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              elevation: 5.0,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isEditModeActive ? Icons.save : Icons.edit,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _isEditModeActive ? 'Save' : 'Edit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (_isEditModeActive) {
                                  _trySubmit();
                                } else {
                                  setState(() {
                                    _isEditModeActive = !_isEditModeActive;
                                  });
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
