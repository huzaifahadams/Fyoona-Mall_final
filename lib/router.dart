import 'package:flutter/material.dart';

import 'buyers/views/nav_screens/widgets/address/screens/address_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
          
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('page not found!'),
          ),
        ),
      );
  }
}
