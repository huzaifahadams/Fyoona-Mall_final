import 'package:fyoona/vendors/providers/product_provider.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../global_variables.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
      } else {}
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  String formatedDate(date) {
    final outputDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outputDateFormate.format(date);
    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ignore: no_leading_underscores_for_local_identifiers
    final ProdcutProvider _productProvider =
        Provider.of<ProdcutProvider>(context);

   
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Name';
                  } else {
                    return null;
                  }
                },
                onChanged: ((value) {
                  _productProvider.getFormData(productName: value);
                }),
                decoration: const InputDecoration(
                  labelText: 'Enter Product Name',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Price';
                  } else {
                    return null;
                  }
                },
                onChanged: ((value) {
                  _productProvider.getFormData(
                      productPrice: double.parse(value));
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Product Price',
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Quanity';
                  } else {
                    return null;
                  }
                },
                onChanged: ((value) {
                  _productProvider.getFormData(quantity: int.parse(value));
                }),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Product Quanity',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                hint: const Text('Select Category'),
                items: _categories.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Category ';
                  } else {
                    return null;
                  }
                },
                onChanged: ((value) {
                  setState(() {
                    _productProvider.getFormData(category: value);
                  });
                }),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Product Descritption';
                  } else {
                    return null;
                  }
                },
                onChanged: ((value) {
                  _productProvider.getFormData(productDescription: value);
                }),
                maxLength: 800,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Product Descritption',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(5000))
                          .then((value) {
                        setState(() {
                          _productProvider.getFormData(scheduleDate: value);
                        });
                      });
                    },
                    child: const Text(
                      'Schedule',
                      style: TextStyle(),
                    ),
                  ),
                  if (_productProvider.productData['scheduleDate'] != null)
                    Text(
                      formatedDate(
                        _productProvider.productData['scheduleDate'],
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
