import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyoona/const/images.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emalController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? address;

  @override
  void initState() {
    _fullNameController.text = widget.user.fullname;
    _emalController.text = widget.user.email;
    _phoneController.text = widget.user.phonenumber;
    _addressController.text = widget.user.address;
    super.initState();
  }

  updateUser() {}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            letterSpacing: 3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: user.userImg != ''
                          ? NetworkImage(user.userImg!)
                          : const AssetImage(userImgz) as ImageProvider,
                      // backgroundColor: Colors.yellow.shade900,
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.photo),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Enter Full Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emalController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Enter Email",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Enter Phone number",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      address = value;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter Address",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // controller: _addressController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      // address = value;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter Old Password",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // controller: ,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      // address = value;
                    },
                    decoration: const InputDecoration(
                      labelText: "Enter New Password",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: 'Updating...');
            updateUser().whenComplete(() {
              EasyLoading.dismiss();
              Navigator.pop(context);
            });
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.yellow.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'UPDATE',
                style: TextStyle(
                    color: Colors.white, fontSize: 18, letterSpacing: 6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
