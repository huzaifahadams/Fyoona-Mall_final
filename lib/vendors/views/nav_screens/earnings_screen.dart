import 'package:flutter/material.dart';
import 'package:fyoona/const/images.dart';
import 'package:fyoona/global_variables.dart';
import 'package:fyoona/vendors/providers/vendor_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../vendor_inner_screen/withdraw_screen.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<VendorProvider>(context).user;

    final apiUrl = '$uri/api/vendor/vendor-stats/${user.id}';

    return FutureBuilder(
      future: http.get(Uri.parse(apiUrl)),
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (!snapshot.hasData || snapshot.data!.statusCode != 200) {
          // return const Center(child: Text("Failed to load data"));
          return const CircularProgressIndicator();
        }

        // Parse the response JSON
        final Map<String, dynamic> data = json.decode(snapshot.data!.body);

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                CircleAvatar(
                    backgroundImage: user.vendorlogo != null &&
                            user.vendorlogo != 'null' &&
                            user.vendorlogo != ''
                        ? NetworkImage(user.vendorlogo.toString())
                        : const AssetImage(userImgz) as ImageProvider),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Hi  ${user.businessname}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 4,
                    ),
                  ),
                )
              ],
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: fyoonaMainColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'TOTAL EARNINGS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '\$ ${data["totalEarnings"].toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'TOTAL ORDERS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '${data["totalOrders"]}',
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VendorWithdrawScreen();
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      color: fyoonaMainColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'WithDraw',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
