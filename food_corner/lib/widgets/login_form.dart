import 'package:flutter/material.dart';
import 'reusable_raised_button.dart';

class LoginForm extends StatefulWidget {
  LoginForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail;
  String _userPassword;
  var _isLogin = true;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();

      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white70,
        elevation: 5,
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email address'),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Password must be at least 7 characters long.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        onSaved: (value) {
                          _userPassword = value;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (widget.isLoading)
                  CircularProgressIndicator(
                    backgroundColor: Colors.white38,
                    strokeWidth: 3,
                  ),
                if (!widget.isLoading)
                  ReusableRaisedButton(
                    buttonTitle: _isLogin ? 'Login' : 'Register',
                    onPressed: () {
                      _trySubmit();
                      //Navigator.pushNamed(context, FoodItemScreen.id);
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (!widget.isLoading)
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                      //Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    child: Text(
                      _isLogin ? 'Register here' : 'I have an account',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
