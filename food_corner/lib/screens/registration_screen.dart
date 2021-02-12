import 'package:flutter/material.dart';
import '../widgets/reusable_raised_button.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  String confirmPassword;
  String name;
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
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,
              onChanged: (value) {
                name = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your n1ame'),
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
              height: 12,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                confirmPassword = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Re-enter your password',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ReusableRaisedButton(
              buttonTitle: 'Register',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
