import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:pizzashop/Pages/home.dart';
import 'package:pizzashop/Services/Shearedprefrences.dart';
import 'package:pizzashop/Services/database.dart';


class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    return auth.currentUser;
  }

  // Now Google SignIn Function
  SignInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      // User canceled the sign-in
      return;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);
    User? userdetails = result.user;

    if (userdetails != null) {
      // ✅ SAVE USER DATA LOCALLY
      await SharedPreferencesHelper().saveUserId(userdetails.uid);

      await SharedPreferencesHelper()
          .saveUserName(userdetails.displayName ?? "Guest");

      await SharedPreferencesHelper().saveUserEmail(userdetails.email ?? "");

      await SharedPreferencesHelper().saveUserImage(userdetails.photoURL ?? "");

      Map<String, dynamic> UserInfoMap = {
        "email": userdetails.email,
        "Name": userdetails.displayName,
        "ImgUrl": userdetails.photoURL,
        "Id": userdetails.uid,
      };

      await DatabaseMethods().addUser(userdetails.uid, UserInfoMap);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  // SignOut Function
 final SharedPreferencesHelper _prefs = SharedPreferencesHelper();

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _prefs.clearUserData();
  }


  // Function for the Delete Account
  Future deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}
