import 'package:flutter/material.dart';

import 'package:pizzashop/Pages/splash_screen.dart';
import 'package:pizzashop/Pages/theme_controller.dart';
import 'package:pizzashop/Services/Shearedprefrences.dart';
import 'package:pizzashop/Services/auth_services.dart';
import 'package:pizzashop/Widgets/widget_supported.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, email, image;

  getTheSharesPref() async {
    name = await SharedPreferencesHelper().getUserName();
    email = await SharedPreferencesHelper().getUserEmail();
    image = await SharedPreferencesHelper().getUserImage();

    setState(() {});
  }

  @override
  void initState() {
    getTheSharesPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar:AppBar(
  backgroundColor: const Color(0xFFF6F6F6),
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        "Profile",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return Switch(
            value: themeController.isDark,
            onChanged: (value) {
              themeController.toggleTheme();
            },
            activeColor: Colors.blue,
          );
        },
      ),
    ],
  ),
),
        body: name == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.network(
                          image!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_3_outlined,
                                  size: 35,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: AppWidget.SimpleTextFeildStyle(),
                                    ),
                                    Text(
                                      name!,
                                      style: AppWidget.SimpleTextFeildStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.mail_outline,
                                  size: 35,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: AppWidget.SimpleTextFeildStyle(),
                                    ),
                                    Text(
                                      email!,
                                      style: AppWidget.SimpleTextFeildStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                     onTap: () async {
  await AuthMethods().signOut();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const SplashScreen()),
    (route) => false,
  );
},
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "LogOut",
                                    style: AppWidget.SimpleTextFeildStyle(),
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                       onTap: () async {
                        await AuthMethods().deleteUser().then((value) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Delete Accout",
                                    style: AppWidget.SimpleTextFeildStyle(),
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ));
  }
}
