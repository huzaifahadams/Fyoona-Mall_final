import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../global_variables.dart';
import '../../providers/product_provider.dart';

class VideoTabScreen extends StatefulWidget {
  const VideoTabScreen({super.key});

  @override
  State<VideoTabScreen> createState() => _VideoTabScreenState();
}

class _VideoTabScreenState extends State<VideoTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ImagePicker picker = ImagePicker();
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _selectedMedia;
  String? _mediaUrl;
  VideoPlayerController? _videoController;
  // ignore: unused_field
  bool _isMuted = false;
  bool _isVideoUploaded = false;

  Future<void> chooseMedia(bool isVideo) async {
    final pickedFile = isVideo
        ? await picker.pickImage(source: ImageSource.gallery)
        : await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile == null) {
    } else {
      setState(() {
        _selectedMedia = File(pickedFile.path);
        _isMuted = false; // Reset mute state when selecting a new media
        _isVideoUploaded =
            false; // Reset the uploaded state when selecting a new media

        if (!isVideo) {
          _videoController
              ?.dispose(); // Dispose of the previous video controller
          _videoController = VideoPlayerController.file(_selectedMedia!)
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized
              setState(() {});
            });
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final ProdcutProvider productProvider =
        Provider.of<ProdcutProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _selectedMedia != null
              ? GestureDetector(
                  onTap: () {
                    if (_videoController != null) {
                      if (_videoController!.value.isPlaying) {
                        _isMuted = true;
                        _videoController!.pause();
                      } else {
                        _videoController!.play();
                        _isMuted = true;
                      }
                    }
                  },
                  child: SizedBox(
                    width: screenSize.width,
                    height:
                        screenSize.width * 9 / 16, // Assuming 16:9 aspect ratio
                    child: _videoController != null
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : Image.file(_selectedMedia!),
                  ),
                )
              : Container(), // Placeholder or any other UI element when no media is selected

          const SizedBox(height: 10),
          Center(
            child: _isVideoUploaded
                ? const Text(
                    'VIdeo Uploaded!',
                    style: TextStyle(fontSize: 20),
                  )
                : IconButton(
                    onPressed: () async {
                      bool isVideo =
                          false; // Set to true if you want to choose an image
                      await chooseMedia(isVideo);
                    },
                    icon: const Icon(Icons.add),
                  ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () async {
              if (_selectedMedia != null) {
                EasyLoading.show(status: 'Uploading');
                final cloudinary = CloudinaryPublic(iduser, idpass);
                if (_selectedMedia != null) {
                  CloudinaryResponse res = await cloudinary.uploadFile(
                    CloudinaryFile.fromFile(_selectedMedia!.path,
                        folder: 'productsvid'),
                  );
                  _mediaUrl = res.secureUrl;
                }
              }
              setState(() {
                productProvider.getFormData(mediaUrl: _mediaUrl);
                _isVideoUploaded = true;
                EasyLoading.dismiss();
              });
            },
            child: const Text(
              'Upload',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
