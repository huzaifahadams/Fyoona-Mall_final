import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/nav_screens/welcome_widget.dart';
import 'package:fyoona/buyers/views/nav_screens/widgets/category_text.dart';

import 'widgets/banner_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 14,
        ),
        const WelcomeWidget(),
        // SearchWidget(),
        const BannerWidget(),
        Expanded(
          child: SingleChildScrollView(
            child: CategoryText(),
          ),
        ), // MainAllProducts(),
      ],
    );
  }
}
