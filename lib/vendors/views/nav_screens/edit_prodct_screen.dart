import 'package:flutter/material.dart';
import 'package:fyoona/vendors/views/edit_products_tabs/published_tab.dart';
import 'package:fyoona/vendors/views/edit_products_tabs/unpublished_tab.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.yellow.shade900,
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
