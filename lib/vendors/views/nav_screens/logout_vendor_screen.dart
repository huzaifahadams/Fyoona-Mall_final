import 'package:flutter/material.dart';
import 'package:fyoona/const/images.dart';
import 'package:fyoona/vendors/providers/vendor_provider.dart';
import 'package:fyoona/vendors/views/nav_screens/vendor_edit_profile.dart';
import 'package:fyoona/vendors/views/services/account_vendor_services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../../global_variables.dart';

class LogoutVendorScreen extends StatefulWidget {
  const LogoutVendorScreen({Key? key}) : super(key: key);
  // final Buyer userData;

  @override

  // ignore: library_private_types_in_public_api
  _LogoutVendorScreenState createState() => _LogoutVendorScreenState();
}

class _LogoutVendorScreenState extends State<LogoutVendorScreen> {
    final AccountVendorServices authService = AccountVendorServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<VendorProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: fyoonaMainColor,
        title: const Text(
          'Profile',
          style: TextStyle(letterSpacing: 4),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: InkWell(onTap: () {}, child: const Icon(Icons.brightness_2)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: user.vendorlogo != ''
                      ? NetworkImage(user.vendorlogo!)
                      : const AssetImage(userImgz) as ImageProvider,
                  child: user.vendorlogo == null
                      ? Shimmer(
                          duration: const Duration(seconds: 10),
                          interval: const Duration(seconds: 10),
                          color: Colors.white,
                          colorOpacity: 0,
                          enabled: true,
                          direction: const ShimmerDirection.fromLTRB(),
                          child: Container(
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user.fullname,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user.email,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EditProfileScreenVendor(
                          user: user,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 200,
                  decoration: BoxDecoration(
                    color: fyoonaMainColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('Edit Profile',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 5,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
              ),
              // ListTile(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return const Orders();
              //         },
              //       ),
              //     );
              //   },
              //   leading: const Icon(Icons.logout),
              //   title: const Text(
              //     'Orders',
              //     style: TextStyle(
              //       fontSize: 20,
              //     ),
              //   ),
              // ),
              ListTile(
                onTap: () async {
                            authService.logoutvendor(context);

                },
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
