import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_corner/services/firebase_api.dart';
import 'package:food_corner/widgets/spinner_widget.dart';

class FoodItemFormWidget extends StatefulWidget {
  @override
  _FoodItemFormWidgetState createState() => _FoodItemFormWidgetState();
}

class _FoodItemFormWidgetState extends State<FoodItemFormWidget> {
  FirebaseApi _firebaseApi = FirebaseApi();
  final _formKey = GlobalKey<FormState>();

  String _foodItemName;
  String _imgPath;
  int _price;
  bool _isLoading = false;

  _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });

      // add new food item to server
      await _firebaseApi.addNewFoodItem(
        title: _foodItemName.trim(),
        imgPath: _imgPath.trim(),
        price: _price,
      );
      Navigator.pop(context);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF757575),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Add New Food Item',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                autofocus: true,
                key: ValueKey('name'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter food name.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Food Name',
                ),
                onSaved: (value) {
                  _foodItemName = value;
                },
              ),
              TextFormField(
                key: ValueKey('imgPath'),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter food image url.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Image URL',
                ),
                onSaved: (value) {
                  _imgPath = value;
                },
              ),
              TextFormField(
                key: ValueKey('price'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter food price.';
                  }
                  final n = num.tryParse(value);
                  if (n == null) {
                    return '"$value" is not a valid number';
                  } else if (n == 0) {
                    return 'Price should be greater than zero.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefix: Text('₹'),
                  labelText: 'Price',
                ),
                onSaved: (value) {
                  _price = num.tryParse(value);
                },
              ),
              SizedBox(
                height: 10,
              ),
              if (_isLoading) Spinner(),
              if (!_isLoading)
                RaisedButton(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text('Add'),
                  onPressed: () {
                    _trySubmit();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
