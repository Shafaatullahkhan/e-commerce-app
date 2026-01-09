import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pizzashop/Pages/Order.dart';
import 'package:pizzashop/Pages/Profile.dart';
import 'package:pizzashop/Pages/home.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late List<Widget> Pages;
  late HomeScreen Home;
  late Order order;
  late Profile profile;
  int CurrentTabIndex = 0;

  @override
  void initState() {
    Home = HomeScreen();
    order = Order();
    profile = Profile();
    Pages = [Home, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          color: Colors.black,
          animationDuration: Duration(microseconds: 500),
          animationCurve: Curves.easeInOut,
          
          onTap: (int index) {
            setState(() {
              CurrentTabIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
          ]),
          body: Pages[CurrentTabIndex],
    );
  }
}
