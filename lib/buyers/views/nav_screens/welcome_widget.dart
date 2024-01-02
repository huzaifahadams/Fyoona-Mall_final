import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fyoona/buyers/providers/user_provider.dart';
import 'package:provider/provider.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  WelcomeWidgetState createState() => WelcomeWidgetState();
}

class WelcomeWidgetState extends State<WelcomeWidget> {
  late String buyersId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context).user;
    buyersId = user.id;
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 25,
        right: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Howdt, What Are You\n Looking For 👀',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'semibold',
            ),
          ),
          GestureDetector(
            // onTap: () {
            //   Navigator.pushReplacement(context,
            //       MaterialPageRoute(builder: (context) {
            //     return const CartScreen();
            //   }));
            // },
            child: Stack(
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
          ),
        ],
      ),
    );
  }
}
