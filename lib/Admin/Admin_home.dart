import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pizzashop/Admin/add_product.dart';
import 'package:pizzashop/Admin/all_Orders.dart';
import 'package:pizzashop/Notification_Services.dart';
import 'package:pizzashop/Services/database.dart';

import 'package:pizzashop/Widgets/widget_supported.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
 NotificationService notificationService = NotificationService();
 FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
 

  @override  void initState() {
    super.initState();
     saveAdminToken();
  }



  void saveAdminToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await DatabaseMethods().saveAdminToken(token);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Home Admin",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
             IconButton(
  icon: Icon(Icons.notifications),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AllOrders()),
    );
  },
),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 180.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductScreen()));
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 50.0,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        "Add Product",
                        style: AppWidget.SimpleTextFeildStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllOrders()));
              },
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 50.0,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        "All Orders",
                        style: AppWidget.SimpleTextFeildStyle(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
