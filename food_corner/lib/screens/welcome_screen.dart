import 'package:flutter/material.dart';
import '../widgets/reusable_raised_button.dart';

class WelcomeScreen extends StatefulWidget {
  static final id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    animation.addStatusListener((status) {});
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC5D1CE).withOpacity(controller.value),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                child: Image(
                  fit: BoxFit.fill,
                  image:
                      AssetImage('assets/images/food_corner_logo_internal.png'),
                ),
                height: 80,
                padding: EdgeInsets.only(left: 20),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Food Corner',
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          ReusableRaisedButton(
            buttonTitle: 'Register',
            onPressed: () {},
          ),
          ReusableRaisedButton(
            buttonTitle: 'Login',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
