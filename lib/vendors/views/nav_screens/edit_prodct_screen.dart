import 'package:flutter/material.dart';
import 'package:fyoona/vendors/views/edit_products_tabs/published_tab.dart';
import 'package:fyoona/vendors/views/edit_products_tabs/unpublished_tab.dart';

import '../../../global_variables.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              false, // Set this to false to hide the back button

          elevation: 0,
          centerTitle: true,
          backgroundColor: fyoonaMainColor,
          title: const Text(
            'Manage Products',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 5),
          ),
          bottom: const TabBar(tabs: [
            Tab(
              child: Text('Published'),
            ),
            Tab(
              child: Text('Unpublished'),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            PubLishedTab(),
            UnpubLishedTab(),
          ],
        ),
      ),
    );
  }
}
