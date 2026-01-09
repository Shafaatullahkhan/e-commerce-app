import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzashop/Pages/bottom_nav_bar.dart';
import 'package:pizzashop/Pages/forgot_password_screen.dart';
import 'package:pizzashop/Services/Shearedprefrences.dart';
import 'package:pizzashop/Services/auth_services.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  SharedPreferencesHelper prefs = SharedPreferencesHelper();

  void showMessage(String msg, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  login() async {
    String email = mailController.text.trim();
    String password = passController.text.trim();

    if (email.isEmpty) {
      showMessage("Email is required");
      return;
    }

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      showMessage("Enter a valid email address");
      return;
    }

    if (password.isEmpty) {
      showMessage("Password is required");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await prefs.saveUserLoginStatus(true);
      await prefs.saveUserId(userCredential.user!.uid);
      await prefs.saveUserEmail(userCredential.user!.email ?? "");

      showMessage("Login Successful", color: Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        showMessage("Password is incorrect");
      } else if (e.code == "user-not-found") {
        showMessage("No user found with this email");
      } else if (e.code == "invalid-email") {
        showMessage("Email format is invalid");
      } else {
        showMessage(e.message.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 BACKGROUND IMAGE
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/signup_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🔹 DARK OVERLAY
          Container(
            width: size.width,
            height: size.height,
            color: Colors.black.withOpacity(0.6),
          ),

          /// 🔹 CONTENT
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.12),

                /// 🔹 LOGO
                ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.35),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: size.width * 0.85,
                    width: size.width * 0.85,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: size.height * 0.006),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: mailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.white70),
                      icon: const Icon(Icons.mail, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: passController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.white70),
                      icon: const Icon(Icons.lock, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔹 SIGN IN BUTTON
                GestureDetector(
                  onTap: login,
                  child: Container(
                    width: 250,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange,
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

                const SizedBox(height: 30),

                /// 🔹 GOOGLE SIGN IN
                GestureDetector(
                  onTap: () {
                    AuthMethods().SignInWithGoogle(context);
                  },
                  child: Container(
                    width: 250,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          height: 28,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Continue With Google",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
