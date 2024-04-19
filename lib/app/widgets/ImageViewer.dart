import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/theme/colors.dart';
import '../utils/theme/fonts.dart';
import 'cache_image_widget.dart';

class ImageViewer extends StatefulWidget {
  String? ImageUrl;
  ImageViewer({super.key, required this.ImageUrl});

  @override
  ImageViewerState createState() => ImageViewerState();
}

class ImageViewerState extends State<ImageViewer> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.whiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: MyColors.blackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(Get.height * 0.03),
            width: Get.width,
            height: Get.height * 0.50,
            // margin: const EdgeInsets.all(Insets.i4),
            child: CustomImageView(
                isProfilePicture: false,
                imagePathOrUrl: widget.ImageUrl,
                radius: Insets.i12),
          ),
        ],
      ),
    );
  }
}
