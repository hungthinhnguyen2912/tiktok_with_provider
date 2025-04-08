import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static Future<DocumentSnapshot?> getUserInfo() async {
    final CollectionReference users = FirebaseFirestore.instance.collection(
      "users",
    );
    const storage = FlutterSecureStorage();
    String? uid = await storage.read(key: 'uid');

    if (uid == null) {
      print("Error: uid is null");
      return null;
    }

    final result = await users.doc(uid).get();

    if (!result.exists) {
      print("Error: User document does not exist in Firestore");
      return null;
    }

    return result;
  }

  static Stream getPeopleInfo(String peopleID) {
    final CollectionReference users = FirebaseFirestore.instance.collection(
      "users",
    );
    final result = users.doc(peopleID).snapshots();
    return result;
  }

  static addUser(String uid, String email, String fullname) {
    final CollectionReference users = FirebaseFirestore.instance.collection(
      "users",
    );
    users
        .doc(uid)
        .set({
          "uid": uid,
          "email": email,
          "fullname": fullname,
          "following": [],
          "followers": [],
          "avatarURL":
              "https://iotcdn.oss-ap-southeast-1.aliyuncs.com/RpN655D.png",
          "Phone": 'None',
          "age": "None",
          "gender": "None",
        })
        .then((value) => print("add user"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static addAvatarFirebase(String avatarUrl) async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .update({"avatarURL": avatarUrl});
  }
}
