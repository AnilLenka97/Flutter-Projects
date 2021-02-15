import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DataAccessFirebase {
  var floorData;
  getFloorInfo() async {
    await FirebaseFirestore.instance
        .collection('food-items')
        .get()
        .then((value) {
      floorData = value;
    });
    return floorData.data.docs;
  }
}
