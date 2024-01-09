import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyoona/vendors/providers/product_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../global_variables.dart';

class ImagesTabScreen extends StatefulWidget {
  const ImagesTabScreen({super.key});

  @override
  State<ImagesTabScreen> createState() => _ImagesTabScreenState();
}

class _ImagesTabScreenState extends State<ImagesTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  //getting images from the gallary
  final ImagePicker picker = ImagePicker();
  // ignore: prefer_final_fields
  List<File> _image = [];
  // ignore: prefer_final_fields
  List<String> _imageUrlList = [];

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      // print('zeroooo');
    } else {
      setState(() {
        _image.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ProdcutProvider productProvider =
        Provider.of<ProdcutProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: _image.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 8, childAspectRatio: 3 / 3),
            itemBuilder: ((context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                          onPressed: () {
                            chooseImage();
                          },
                          icon: const Icon(Icons.add)),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(_image[index - 1]))),
                    );
            }),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () async {
              final cloudinary = CloudinaryPublic(iduser, idpass);

              EasyLoading.show(status: 'Uploading');
              for (int i = 0; i < _image.length; i++) {
                CloudinaryResponse res = await cloudinary.uploadFile(
                  CloudinaryFile.fromFile(_image[i].path,
                      folder: 'ProductImages'),
                );
                _imageUrlList.add(res.secureUrl);
              }

              setState(() {
                productProvider.getFormData(imageUrList: _imageUrlList);

                EasyLoading.dismiss();
              });
            },
            child: _image.isNotEmpty
                ? const Text(
                    'Upload',
                    style: TextStyle(fontSize: 20),
                  )
                : const Text(''),
          )
        ],
      ),
    );
  }
}
