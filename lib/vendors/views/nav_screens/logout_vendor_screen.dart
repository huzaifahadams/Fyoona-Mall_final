import 'package:flutter/material.dart';
import 'package:fyoona/vendors/views/services/account_vendor_services.dart';

class LogoutVendorScreen extends StatelessWidget {
  final AccountVendorServices authService = AccountVendorServices();

  LogoutVendorScreen({super.key});
  // final user = Provider.of<VendorProvider>(context).user;

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<VendorProvider>(context).user;

    return Center(
      child: TextButton(
        onPressed: () async {
          authService.logoutvendor(context);
        },
        child: const Text('Logout'),
      ),
    );
  }
}
