import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzashop/Pages/login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Future<void> registration() async {
    String name = nameController.text.trim();
    String email = mailController.text.trim();
    String password = passController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showMessage("All fields are required");
      return;
    }

    if (password.length < 6) {
      showMessage("Password must be at least 6 characters");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showMessage("Registration Successful", color: Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
    }
  }

  void showMessage(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 BACKGROUND IMAGE
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

          // 🔹 DARK OVERLAY
          Container(
            width: size.width,
            height: size.height,
            color: Colors.black.withOpacity(0.6),
          ),

          // 🔹 CONTENT
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.12),

                // 🔹 LOGO
               ClipRRect(
  borderRadius: BorderRadius.circular(size.width * 0.35),
  child: Image.asset(
    "assets/images/logo.png",
    height: size.width * 0.85, // ⬅️ Increased
    width: size.width * 0.85,  // ⬅️ Increased
    fit: BoxFit.cover,
  ),
),


                SizedBox(height: size.height * 0.000015),


                // 🔹 TITLE
                Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.075,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                _inputField(
                  controller: nameController,
                  hint: "Name",
                  icon: Icons.person,
                ),

                _inputField(
                  controller: mailController,
                  hint: "Email",
                  icon: Icons.email,
                ),

                _inputField(
                  controller: passController,
                  hint: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),

                SizedBox(height: size.height * 0.05),

                // 🔹 SIGN UP BUTTON
                GestureDetector(
                  onTap: registration,
                  child: Container(
                    width: size.width * 0.7,
                    height: size.height * 0.065,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                // 🔹 SIGN IN TEXT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable Input Field Widget
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
