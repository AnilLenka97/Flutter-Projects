const functions = require("firebase-functions");
const admin = require("firebase-admin");
// const dt1 = "fP7u26blSIiN04Lj5OeP76:APA91bFMQpWw0GB5";
// const dt2 = "SglZpFiz8_GVc6sEnZU_XPGpkJApvLrwXyZvWV";
// const dt3 = "i2qKQLIFUNfD1YSJ2nxiJzTZkLnwW9YsqcAL4kVF8Mb";
// const dt4 = "wtLlxqMMaBt1mKxCb_wIriyQos9U0iIVzPDDydBEkl-";
// const deviceToken = dt1+dt2+dt3+dt4;
let deviceToken = "dummy-token";

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
              deviceToken = value.data()["deviceToken"];

              return db.collection("food-items").doc(foodItemId).get()
                  .then((value)=>{
                    const itemName = value.data()["title"];
                    const totalCost = value.data()["price"] * noOfItems;
                    const imgPath = value.data()["imgPath"];

                    return admin.messaging().sendToDevice(deviceToken, {
                      notification: {
                        title: "Order Placed",
                        body: itemName+" Ordered, Total Price: "+totalCost,
                        click_action: "FLUTTER_NOTIFICATION_CLICK",
                      },
                      data: {
                        "itemName": itemName,
                        "imgPath": imgPath,
                      },
                    });
                  });
            });
      } catch (err) {
        console.log(err);
      }
      return;
    });

// exports.orderSuccessfulNotification = functions.https
//     .onCall((data, context) => {
//       await admin.firestore()
//       .collection("users")
//       .doc(data["userId"])
//       .get()
//       .then((value)=>{
//         deviceToken = value.data()['deviceToken'];
//       });

//       try{
//         return admin.messaging().sendToDevice(deviceToken, {
//           notification: {
//             title: "Sample Title",
//             body: "This is a notification.",
//             click_action: "FLUTTER_NOTIFICATION_CLICK",
//           },
//           data: {}
//         });
//       }
//       catch(err){
//         console.log(err);
//       }
//     });
