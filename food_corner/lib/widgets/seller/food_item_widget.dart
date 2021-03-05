import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/food_item_model.dart';
import '../../services/firebase_api.dart';
import '../spinner_widget.dart';

class FoodItem extends StatefulWidget {
  final FoodItemModel foodItem;
  FoodItem({
    @required this.foodItem,
  });

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  FirebaseApi _firebaseApi = FirebaseApi();
  bool _isAvailable;
  int _price;
  int _newPrice;
  bool _isEditModeEnabled = false;
  bool _isLoading = false;

  changeAvailability(bool val) async {
    await _firebaseApi.updateFoodItemAvailability(
      itemId: widget.foodItem.foodItemId,
      isAvailable: val,
    );
    setState(() {
      _isLoading = false;
      _isAvailable = val;
    });
  }

  changeItemPrice(int val) async {
    await _firebaseApi.updateFoodItemPrice(
      itemId: widget.foodItem.foodItemId,
      price: val,
    );
    setState(() {
      _isLoading = false;
      _price = val;
    });
  }

  @override
  void initState() {
    _isAvailable = widget.foodItem.isAvailable;
    _price = widget.foodItem.foodPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 2),
      color: Colors.white38,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                child: Image.network(
                  widget.foodItem.foodImgPath,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Spinner()
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.foodItem.foodTitle,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Availability',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    _isAvailable
                                        ? 'Available'
                                        : 'Not Available',
                                    style: TextStyle(
                                      color: Colors.black26,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Switch(
                                activeColor: Colors.green,
                                value: _isAvailable,
                                onChanged: (value) {
                                  changeAvailability(value);
                                  setState(() {
                                    _isLoading = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (!_isEditModeEnabled)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹ $_price',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isEditModeEnabled = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          if (_isEditModeEnabled)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: 5.0,
                                      ),
                                      prefix: Text('₹ '),
                                      focusColor: Colors.white,
                                    ),
                                    autofocus: true,
                                    initialValue: _price.toString(),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) {
                                      _newPrice = num.tryParse(value);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.save_outlined,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      if (_newPrice != null && _newPrice != 0)
                                        changeItemPrice(_newPrice);
                                      else
                                        changeItemPrice(_price);
                                      setState(() {
                                        _isLoading = true;
                                        _isEditModeEnabled = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
