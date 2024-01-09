import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../global_variables.dart';
import 'home_products.dart';
import 'main_products_widget.dart';

// ignore: use_key_in_widget_constructors
class CategoryText extends StatefulWidget {
  @override
  State<CategoryText> createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  // ignore: unused_field
  String? _selectedCategory;
  // ignore: prefer_final_fields
  List<String> _categories = []; // List to store categories

  Future<void> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/admin/getcategory'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<String> categories = data
            .map((dynamic item) => item['categoryName']?.toString())
            .whereType<String>()
            .toList();

        setState(() {
          _categories.clear();
          _categories.addAll(categories);
        });
      } else {
        // Handle error if needed
        // print(
        //     'Failed to load categories. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Handle error if needed
      // print('Error fetching categories: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontSize: 19),
          ),
          if (_categories.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Loading Categories"),
            ),
          if (_categories.isNotEmpty)
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final categoryName = _categories[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ActionChip(
                            backgroundColor: fyoonaMainColor,
                            onPressed: () {
                              setState(() {
                                _selectedCategory = categoryName;
                              });
                            },
                            label: Center(
                              child: Text(
                                categoryName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle navigation if needed
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
            ),
          if (_selectedCategory == null) const MainAllProducts(),
          if (_selectedCategory != null)
            HomeProductWidget(categoryName: _selectedCategory!),
        ],
      ),
    );
  }
}
