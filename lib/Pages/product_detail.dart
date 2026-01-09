import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:pizzashop/Notification_Services.dart';
import 'package:pizzashop/Services/Shearedprefrences.dart';
import 'package:pizzashop/Services/database.dart';

// ⚠️ TEST SECRET KEY (FOR LEARNING ONLY)
const String stripeSecretKey = "YOUR_STRIPE_SECRET_KEY";

class ProductDetailPage extends StatefulWidget {
  final String image;
  final String name;
  final String detail;
  final String price;

  const ProductDetailPage({
    super.key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  // Method for getting the User data Store Locally in the 
  // SharedPrefrences files Inside the Services Folder
  // Here we get the User name, email, and image of the login user
  String? name, mail, image;

  getTheSharedPref() async {
    name = await SharedPreferencesHelper().getUserName();
    mail = await SharedPreferencesHelper().getUserEmail();
    image = await SharedPreferencesHelper().getUserImage();
  }

  onTheLoad() async {
    await getTheSharedPref();
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4EE),
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- BACK BUTTON ----------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- PRODUCT IMAGE ----------------
            SizedBox(
              height: size.height * 0.40,
              child: Center(
                child: widget.image.startsWith("http")
                    ? Image.network(widget.image, width: size.width * 0.8)
                    : Image.memory(base64Decode(widget.image),
                        width: size.width * 0.8),
              ),
            ),

            // ---------------- DETAILS ----------------
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.name,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Text("\$${widget.price}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text("Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),

                    const SizedBox(height: 8),

                    Text(widget.detail,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey, height: 1.5)),

                    const Spacer(),

                    // ---------------- BUY BUTTON ----------------
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => makePayment(widget.price),
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STRIPE PAYMENT =================
  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, "usd");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Shafaat Ullah',
          style: ThemeMode.dark,
        ),
      );

      await displayPaymentSheet();
    } catch (e) {
      debugPrint("Payment Error: $e");
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Store Data in FireStore 
      // the data of order details 
      // the database firestore function in the Database method Class
      Map<String, dynamic> orderInfoMap = {
        "Product": widget.name,
        "Price": widget.price,
        "Name": name,
        "Email": mail,
        "Image": image,
        "ProductImage": widget.image,
        "Status": "On the way",
      };
      // Call the DatabaseMethod class
      // here function is Create for the order details 
      await DatabaseMethods().orderDetails(orderInfoMap);

      // 🔔 SEND NOTIFICATION TO ADMIN
String adminToken = await DatabaseMethods().getAdminToken();

await NotificationService().sendPushNotification(
  deviceToken: adminToken,
  title: "New Order Booked 🛒",
  body: "${widget.name} order placed by $name",
  data: {
    "type": "new_order"
  },
);

      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("Payment Successful"),
            ],
          ),
        ),
      );

      paymentIntent = null;
    } on StripeException {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(content: Text("Payment Cancelled")),
      );
    }
  }

  // ================= CREATE PAYMENT INTENT =================
  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    final body = {
      "amount": calculateAmount(amount),
      "currency": currency,
      "payment_method_types[]": "card",
    };

    final response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      headers: {
        "Authorization": "Bearer $stripeSecretKey",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
    );

    return jsonDecode(response.body);
  }

  // ================= AMOUNT CALC =================
  String calculateAmount(String amount) {
    final int calculatedAmount = int.parse(amount) * 100;
    return calculatedAmount.toString();
  }
}
