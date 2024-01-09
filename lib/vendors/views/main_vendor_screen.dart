import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/vendors/views/nav_screens/edit_prodct_screen.dart';
import 'package:fyoona/vendors/views/nav_screens/uploads_products_screen.dart';

import '../../global_variables.dart';
import 'nav_screens/earnings_screen.dart';
import 'nav_screens/logout_vendor_screen.dart';
import 'nav_screens/orders_product_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;
  // ignore: prefer_final_fields
  List<Widget> _pages = [
    const EarningScreen(),
    UploadsScreen(),
    const EditScreen(),
    const VendorOrdersScreen(),
    LogoutVendorScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.black,
          selectedItemColor: fyoonaMainColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.money_dollar), label: 'Earnings'),
            BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.shopping_cart), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
          ]),
      body: _pages[_pageIndex],
    );
  }
}
