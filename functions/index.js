const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyAboutFeed = functions.firestore
  .document("public_feed/{entryID}")
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic("feed", {
      notification: {
        title: "A new image has been added to FoxTails!",
        body: snapshot.data()["description"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      }
    });
  });
