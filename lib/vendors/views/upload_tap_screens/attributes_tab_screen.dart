import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global_variables.dart';
import '../../providers/product_provider.dart';

class AttributesTabScreen extends StatefulWidget {
  const AttributesTabScreen({super.key});

  @override
  State<AttributesTabScreen> createState() => _AttributesTabScreenState();
}

class _AttributesTabScreenState extends State<AttributesTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // bool _entred = false;
  bool _entred2 = false;

  // final List<String> _sizeList = [];
  final List<String> _colorList = [];
  // bool _isSave = false;
  bool _isSave2 = false;

  // final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ProdcutProvider productProvider =
        Provider.of<ProdcutProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Product brand';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                productProvider.getFormData(brandName: value);
              },
              decoration: const InputDecoration(
                labelText: 'Brand',
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            ///
            const SizedBox(
              height: 30,
            ),

            //color
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 100,
                    child: TextFormField(
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Enter color';
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      controller: _colorController,
                      onChanged: (value) {
                        setState(() {
                          _entred2 = true;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Color'),
                    ),
                  ),
                ),
                _entred2 == true
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: fyoonaMainColor),
                        onPressed: () {
                          setState(() {
                            _colorList.add(_colorController.text);
                            _colorController.clear();
                          });
                          // print(_colorList);
                        },
                        child: const Text('Add'),
                      )
                    : const Text(''),
              ],
            ),
            if (_colorList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _colorList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _colorList.removeAt(index);

                                productProvider.getFormData(
                                    colorList: _colorList);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.yellow.shade800,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _colorList[index],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            if (_colorList.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  productProvider.getFormData(colorList: _colorList);
                  setState(() {
                    _isSave2 = true;
                  });
                },
                child: Text(
                  _isSave2 ? 'Saved' : 'Save',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
