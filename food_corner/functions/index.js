const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

// get all users and send back to caller/admin
exports.getAllUsers = functions.https.onCall((_, __) => {
  return admin.auth().listUsers()
      .then((users) => {
        const userList = [];
        users.users.forEach((user) => {
          userList.push({
            'uid': user.uid,
          });
        });
        return userList;
      })
      .catch((err) => {
        console.log('Error listing users: ', err);
      });
});

// delete an user according to data received from caller/admin
exports.deleteUser = functions.https.onCall((uid, _) => {
  return admin.auth().deleteUser(uid)
      .then(() => {
        return true;
      })
      .catch((err) => {
        console.log('Error deleting user: ', err);
        return false;
      });
});

// intitiate a delivery confirmation push notification to an user according to data received from caller/seller
exports.orderDeliveredPushNotification = functions.https.onCall((data, _) => {
  try {
    return db.collection('users').doc(data['consumerId']).get()
        .then((value) => {
          const consumerDeviceToken = value.data()['deviceToken'];

          return initiatePushNotification(data['foodItemId'], consumerDeviceToken, data['noOfItems'], 'Order Delivered');
        });
  } catch (err) {
    console.log('Error sending push-notification: ', err);
  }
  return;
});

// initiate a push notification to both user and seller after a successful order creation
exports.orderPlacedPushNotification = functions.firestore
    .document('users/{userId}/order-history/{orderId}')
    .onCreate((snapshot, context)=>{
      try {
        const noOfItems = snapshot.data()['noOfItems'];
        const foodItemId = snapshot.data()['foodItemId'];
        return db.collection('users')
            .doc(context.params.userId).get().then((value)=>{
              const consumerDeviceToken = value.data()['deviceToken'];

              return initiatePushNotification(foodItemId, consumerDeviceToken, noOfItems, 'Order Placed');
            });
      } catch (err) {
        console.log('Error sending push-notification: ', err);
      }
      return;
    });

// reusable push notification function
function initiatePushNotification(foodItemId, consumerDeviceToken, noOfItems, notificationTitle) {
  return db.collection('food-items').doc(foodItemId).get()
      .then((value)=>{
        const itemName = value.data()['title'];
        const totalCost = value.data()['price'] * noOfItems;
        const imgPath = value.data()['imgPath'];
        const sellerId = value.data()['sellerId'];

        return db.collection('users')
            .doc(sellerId).get().then((value)=>{
              const sellerDeviceToken = value.data()['deviceToken'];

              return admin.messaging().sendToDevice([consumerDeviceToken, sellerDeviceToken], {
                notification: {
                  title: notificationTitle,
                  body: itemName+', Qty: '+noOfItems+', Total Price: ₹'+totalCost,
                  image: imgPath,
                },
                data: {
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'itemName': itemName,
                  'imgPath': imgPath,
                  'noOfItems': noOfItems.toString(),
                  'totalCost': totalCost.toString(),
                },
              });
            });
      });
}
