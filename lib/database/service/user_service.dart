import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static Future getUserInfo () async {
    final CollectionReference users = FirebaseFirestore.instance.collection("users");
    const storage = FlutterSecureStorage();
    String? UID = await storage.read(key: 'uID');
    final result = await users.doc(UID).get();
    return result;
  }
  static Stream getPeopleInfo (String peopleID)  {
    final CollectionReference users = FirebaseFirestore.instance.collection("users");
    final result = users.doc(peopleID).snapshots();
    return result;
  }
  static  addUser (String UID,String email, String fullname) {
    final CollectionReference users = FirebaseFirestore.instance.collection("users");
    users.doc(UID).set({
      "UID": UID,
      "email": email,
      "fullname": fullname,
      "following": [],
      "followers": [],
      "avatarURL": "https://iotcdn.oss-ap-southeast-1.aliyuncs.com/RpN655D.png",
      "Phone": 'None',
      "age": "None",
      "gender": "None"
    }).then((value) => print("add user")).catchError((error) => print("Failed to add user: $error"));
  }

}