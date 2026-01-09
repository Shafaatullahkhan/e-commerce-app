import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:pizzashop/Admin/Admin_home.dart';

import 'package:pizzashop/Widgets/widget_supported.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 250),
            Center(
                child: Text(
              "Admin Panel",
              style: AppWidget.HeadLineTextFeildStyle(),
            )),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: "UserName",
                  icon: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  icon: Icon(Icons.lock),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ---------------- SIGN IN BUTTON -------------------
            GestureDetector(
              onTap: () {
                LoginAdmin();
              },
              child: Container(
                width: 250,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: const Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  LoginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      for (var result in snapshot.docs) {
        if (result.data()["username"] != usernameController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Your id is  not Correct",
                style: AppWidget.SimpleTextFeildStyle(),
              )));
        } else if (result.data()["Password"] != passController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Your Password  not Correct",
                style: AppWidget.SimpleTextFeildStyle(),
              )));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminHome()));
        }
      }
    });
  }
}
