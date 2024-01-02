// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';

// import '../../../../global_variables.dart';
// import '../../../utils.dart';

// class BannerWidget extends StatefulWidget {
//   const BannerWidget({super.key});

//   @override
//   State<BannerWidget> createState() => _BannerWidgetState();
// }

// class _BannerWidgetState extends State<BannerWidget> {
//   final List<String> _bannerImage = [];
//   late PageController _pageController;
//   late Timer _timer;
//   int _currentPage = 0;

//   Future<void> getBanners() async {
//     try {
//       final response = await http.get(Uri.parse('$uri/api/admin/banners'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         final List<String> banners = data
//             .map((dynamic item) => item['img']?.toString())
//             .whereType<String>()
//             .toList();

//         setState(() {
//           _bannerImage.clear();
//           _bannerImage.addAll(banners);
//         });
//       } else {}
//       // ignore: empty_catches
//     }
//     // catch (e) {}

//     on SocketException {
//       showSnackBar(context, "Please check your internet connection.");
//     } on TimeoutException {
//       showSnackBar(context, "The request timed out. Please try again later.");
//     } catch (e, stackTrace) {
//       showSnackBar(context,
//           "An error occurred while uploading product: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
//     }
//   }

//   @override
//   void initState() {
//     getBanners();
//     _pageController = PageController(initialPage: 0);
//     _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
//       if (_currentPage < _bannerImage.length - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//       _pageController.animateToPage(
//         _currentPage,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         height: 140,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: PageView.builder(
//           controller: _pageController,
//           itemCount: _bannerImage.length,
//           itemBuilder: (context, index) {
//             return ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: CachedNetworkImage(
//                 imageUrl: _bannerImage[index],
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Shimmer(
//                   duration: const Duration(seconds: 10),
//                   interval: const Duration(seconds: 10),
//                   color: Colors.white,
//                   colorOpacity: 0,
//                   enabled: true,
//                   direction: const ShimmerDirection.fromLTRB(),
//                   child: Container(
//                     color: Colors.white,
//                   ),
//                 ),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:http/http.dart' as http;

import '../../../../global_variables.dart';
import '../../../utils.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final List<String> _bannerImage = [];
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  Future<void> getBanners() async {
    try {
      final response = await http.get(Uri.parse('$uri/api/admin/banners'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<String> banners = data
            .map((dynamic item) => item['img']?.toString())
            .whereType<String>()
            .toList();

        if (mounted) {
          setState(() {
            _bannerImage.clear();
            _bannerImage.addAll(banners);
          });
        }
      } else {
        // Handle other status codes if needed
      }
    } on SocketException {
      if (mounted) {
        showSnackBar(context, "Please check your internet connection.");
      }
    } on TimeoutException {
      if (mounted) {
        showSnackBar(context, "The request timed out. Please try again later.");
      }
    } catch (e, stackTrace) {
      if (mounted) {
        showSnackBar(context,
            "An error occurred while uploading product: ${e.toString()} \n Line number: ${stackTrace.toString().split('\n')[1]}");
      }
    }
  }

  @override
  void initState() {
    getBanners();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (mounted) {
        if (_currentPage < _bannerImage.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _bannerImage.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: _bannerImage[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  duration: const Duration(seconds: 10),
                  interval: const Duration(seconds: 10),
                  color: Colors.white,
                  colorOpacity: 0,
                  enabled: true,
                  direction: const ShimmerDirection.fromLTRB(),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            );
          },
        ),
      ),
    );
  }
}
