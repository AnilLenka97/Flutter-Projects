const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.myFunctions = functions.firestore
    .document("users/{userId}/order-history/{orderId}")
    .onCreate((snapshot, context)=>{
      try {
        const noOfItems = snapshot.data()["noOfItems"];
        const foodItemId = snapshot.data()["foodItemId"];
        return db.collection("users")
            .doc(context.params.userId).get().then((value)=>{
              const deviceToken = value.data()["deviceToken"];

              return db.collection("food-items").doc(foodItemId).get()
                  .then((value)=>{
                    const itemName = value.data()["title"];
                    const ttlCost = value.data()["price"] * noOfItems;
                    const imgPath = value.data()["imgPath"];

                    return admin.messaging().sendToDevice(deviceToken, {
                      notification: {
                        title: "Order Placed",
                        body:
                        itemName+", Qty: "+noOfItems+", Total Price: ₹"+ttlCost,
                        image: imgPath,
                      },
                      data: {
                        "click_action": "FLUTTER_NOTIFICATION_CLICK",
                        "itemName": itemName,
                        "imgPath": imgPath,
                        "noOfItems": noOfItems.toString(),
                        "totalCost": ttlCost.toString(),
                      },
                    });
                  });
            });
      } catch (err) {
        console.log(err);
      }
      return;
    });
