import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizzashop/Services/Shearedprefrences.dart';
import 'package:pizzashop/Services/database.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;
  Stream<QuerySnapshot>? orderStream;

  getTheSharedPref() async {
    email = await SharedPreferencesHelper().getUserEmail();
  }

  getOnTheLoad() async {
    await getTheSharedPref();
    orderStream = await DatabaseMethods().getOrders(email!);
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
    
  }

  Widget allOrders(double height, double width) {
    return StreamBuilder<QuerySnapshot>(
      stream: orderStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      // ---------- PRODUCT IMAGE ----------
                     Container(
  height: height * 0.08,
  width: height * 0.08,
  decoration: BoxDecoration(
    color: const Color(0xFFF2F2F2),
    borderRadius: BorderRadius.circular(14),
  ),
  clipBehavior: Clip.antiAlias,
  child: Image.network(
    ds["ProductImage"],
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
      );
    },
  ),
),


                      SizedBox(width: width * 0.04),

                      // ---------- PRODUCT INFO ----------
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds["Product"],
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: height * 0.005),
                            Text(
                              "\$${ds["Price"]}",
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),

                            Text(
                              "Status : " + ds["Status"],
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: Column(
            children: [
              // ---------- TITLE ----------
              Text(
                "Current Orders",
                style: TextStyle(
                  fontSize: width * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: height * 0.03),

              // ---------- ORDER LIST ----------
              Expanded(
                child: orderStream == null
                    ? const Center(child: CircularProgressIndicator())
                    : allOrders(height, width),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
