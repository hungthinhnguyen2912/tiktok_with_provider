import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiktokclone/database/service/user_service.dart';

import '../../views/pages/auth/auth_screen.dart';
import '../../views/pages/auth/home_screen.dart';
import '../../views/widgets/snackbar.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static logInFetch({
    required BuildContext context,
    required email,
    required password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      String? uid = userCredential.user?.uid.toString();
      final storage = FlutterSecureStorage();
      await storage.write(key: "uid", value: uid);
      String? value = await storage.read(key: 'uID');
      FocusScope.of(context).unfocus();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
      );
      getSnackBar('Login', 'Login Success.', Colors.green).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        getSnackBar(
          'Login',
          'No user found for that email.',
          Colors.red,
        ).show(context);
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print(e.code);

        getSnackBar(
          'Login',
          'Wrong password provided for that user.',
          Colors.red,
        ).show(context);
        print('Wrong password provided for that user.');
      }
    }
  }

  static logOut({required BuildContext context}) async {
    try {
      auth.signOut();
      final storage = FlutterSecureStorage();
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
            (route) => false,
      );
      getSnackBar('Logout', 'Logout Success.', Colors.green).show(context);
    } catch (e) {}
  }

  static register({
    required BuildContext context,
    required email,
    required password,
    required fullName,
    required UID,
  }) async {
    try {
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email,password: password);
      await UserService.addUser(userCredential.user!.uid, email, fullName);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()), (route) => false,
      );
      getSnackBar(
        'Register',
        'Register Success.',
        Colors.green,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //print('The password provided is too weak.');
        getSnackBar(
          'Register',
          'The password provided is too weak.',
          Colors.red,
        ).show(context);
      } else if (e.code == 'email-already-in-use') {
        getSnackBar(
          'Register',
          'The account already exists for that email.',
          Colors.red,
        ).show(context);
        //print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
