import 'package:flutter/material.dart';

import '../../../database/service/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  String? validateEmail(String email) {
    if (email == '') {
      return "Empty Field !";
    } else if (!isValidEmail(email)) {
      return "Wrong Email !";
    } else {
      return null;
    }
  }

  String? validatePassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length <= 5) {
      return "Your password is so short !";
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value != passwordController.text) {
      return "Your confirmation password does not match !";
    } else {
      return null;
    }
  }

  bool validate() {
    if (fullNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  void doRegister(BuildContext context) {
    if (validate()) {
      AuthService.register(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        fullName: fullNameController.text,
        uid: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.west, color: Colors.grey, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    hintText: "Full name",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    hintText: "Email",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    hintText: "Password",
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    hintText: "Confirm Password",
                  ),
                  obscureText: true,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  doRegister(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
