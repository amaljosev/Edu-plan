import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ScreenFullScreenImage extends StatelessWidget {
  const ScreenFullScreenImage(
      {Key? key, required this.imageUrl, required this.isChecking})
      : super(key: key);

  final String? imageUrl;
  final bool isChecking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'full_screen_image',
          child: PhotoViewGallery(
            pageController: PageController(),
            scrollPhysics: const BouncingScrollPhysics(),
            pageOptions: [
              PhotoViewGalleryPageOptions(
                imageProvider: getImageProvider(),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ],
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider<Object> getImageProvider() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const AssetImage('path_to_placeholder_image');
    } else if (isChecking) {
      return Image.file(File(imageUrl!)).image;
    } else {
      return NetworkImage(imageUrl!);
    }
  }
}
