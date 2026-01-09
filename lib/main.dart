import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pizzashop/Pages/theme_controller.dart';
import 'package:provider/provider.dart';

import 'package:pizzashop/Notification_Services.dart';


import 'package:pizzashop/Pages/splash_screen.dart';

// ThemeController class
import 'firebase_options.dart';
import 'Services/constant.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Load environment variables
  await dotenv.load(fileName: ".env");

  // 2️⃣ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3️⃣ Stripe key
  Stripe.publishableKey = Publishablekey;

  // 4️⃣ Background notification handler
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // 5️⃣ Initialize FCM
  await NotificationService().initFCM();

  // 6️⃣ Run app with Provider for Theme
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

// ⚠ Background notification handler
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Message: ${message.notification?.title}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Pizza Shop',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:
              themeController.isDark ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(), // <-- Splash first
        );
      },
    );
  }
}
