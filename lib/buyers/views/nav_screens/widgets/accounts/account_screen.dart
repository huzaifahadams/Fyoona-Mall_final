import 'package:flutter/material.dart';
import 'package:fyoona/buyers/views/nav_screens/widgets/accounts/services/account_services.dart';
import 'package:fyoona/buyers/views/nav_screens/widgets/orders.dart';
import 'package:fyoona/const/images.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../inner_screens/edit_profile.dart';
import '../../../../providers/user_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);
  // final Buyer userData;

  @override

  // ignore: library_private_types_in_public_api
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountServices accountServices = AccountServices();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.yellow.shade900,
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
                  backgroundImage: user.userImg != ''
                      ? NetworkImage(user.userImg!)
                      : const AssetImage(userImgz) as ImageProvider,
                  child: user.userImg == null
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
                        return EditProfileScreen(
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
                    color: Colors.yellow.shade900,
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
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Orders();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  accountServices.logout(context);
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
