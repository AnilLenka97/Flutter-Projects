import 'package:flutter/material.dart';
import 'package:food_corner/screens/food_item_screen.dart';
import 'package:food_corner/widgets/reusable_raised_button.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC5D1CE),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  child: Image(
                    image: AssetImage(
                        'assets/images/food_corner_logo_internal.png'),
                  ),
                  height: 200,
                  padding: EdgeInsets.only(left: 20),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 12,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ReusableRaisedButton(
              buttonTitle: 'Login',
              onPressed: () {
                Navigator.pushNamed(context, FoodItemScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
