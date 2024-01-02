import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fyoona/vendors/providers/vendor_provider.dart';
import 'package:fyoona/vendors/views/auth/services/vendor_auth_services.dart';
import 'package:fyoona/vendors/views/auth/vendor_login.dart';
import 'package:fyoona/vendors/views/main_vendor_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// ignore: use_key_in_widget_constructors
class LandingScreen extends StatelessWidget {
  final AuthServiceVendor authService = AuthServiceVendor();

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<VendorProvider>(context).user;

    return Scaffold(
        backgroundColor: Colors.white,
        body:
            Consumer<VendorProvider>(builder: (context, vendorProvider, child) {
          final user = vendorProvider.user;

          if (user.approved == true) {
            return const MainVendorScreen();
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: user.vendorlogo.toString(),
                  width: 90,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer(
                    duration: const Duration(seconds: 10), //Default value
                    interval: const Duration(
                        seconds: 10), //Default value: Duration(seconds: 0)
                    color: Colors.white, //Default value
                    colorOpacity: 0, //Default value
                    enabled: true, //Default value
                    direction:
                        const ShimmerDirection.fromLTRB(), //Default Value
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                user.businessname.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  'Your application has been sent for Review\n We shall get back to you soon ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    await authService.logOutVendor().whenComplete(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const VendorLoginScreen();
                          },
                        ),
                      );
                    });
                  },
                  child: const Text(
                    'Signout',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ));
        }));
  }
}
