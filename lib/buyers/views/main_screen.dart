import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fyoona/buyers/views/nav_screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../../const/exiting.dart';
import '../providers/user_provider.dart';
import 'cart/screens/cart_screen.dart';
import 'nav_screens/store_screen.dart';
import 'nav_screens/widgets/accounts/account_screen.dart';
import 'nav_screens/home_screen.dart';
// import 'nav_screens/account_screen.dart';
// import 'nav_screens/cart_screen.dart';
import 'nav_screens/category_screen.dart';
// import 'nav_screens/home_screen.dart';
// import 'nav_screens/search_screen.dart';
// import 'nav_screens/store_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  // ignore: prefer_final_fields
  List<Widget> _pages = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoreScreen(),
    const CartScreen(),
    const SearchScreen(),
    const AccountScreen(),
  ];

  Future<bool> _onWillPop() async {
    if (_pageIndex == 0) {
      showDialog(
        context: context,
        builder: (context) => exitDialog(context),
      );
      return false;
    } else {
      setState(() {
        _pageIndex = 0;
      });
      return false; // add this line
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    // print(user.cart.length);
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: ((value) {
            setState(() {
              _pageIndex = value;
            });
          }),
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.yellow.shade900,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home), label: 'HOME'),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/explore.svg',
                width: 20,
              ),
              label: 'CATEGORIES',
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/shop.svg',
                  width: 20,
                ),
                label: 'STORE'),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/icons/cart.svg',
                    width: 20,
                  ),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$userCartLen', // Change this line
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              label: 'CART',
            ),
            // BottomNavigationBarItem(

            //     icon: SvgPicture.asset(
            //       'assets/icons/cart.svg',
            //       width: 20,
            //     ),
            //     label: 'CART',

            //     ),

            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/search.svg',
                  width: 20,
                ),
                label: 'SEARCH'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/account.svg',
                  width: 20,
                ),
                label: 'ACCOUNT'),
          ],
        ),
        body: _pages[_pageIndex],
      ),
    );
  }
}
