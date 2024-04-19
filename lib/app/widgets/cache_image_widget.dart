import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/widget_extenstion.dart';

class CustomImageView extends StatelessWidget {
  const CustomImageView(
      {super.key,
      required this.imagePathOrUrl,
      required this.isProfilePicture,
      this.isProfileThumbNail,
      this.fit,
      this.radius,
      this.cacheKey,
      this.fromDraftPodcast});
  final String? imagePathOrUrl;
  final bool? isProfileThumbNail;
  final BoxFit? fit;
  final double? radius;
  final String? cacheKey;
  final bool? fromDraftPodcast;
  final bool? isProfilePicture;

  @override
  Widget build(BuildContext context) {
    if (imagePathOrUrl == null) {
      return const SizedBox.shrink();
    }

    if (imagePathOrUrl!.startsWith('https')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: CachedNetworkImage(
          // maxHeightDiskCache: ((500)).round(),
          maxWidthDiskCache: Platform.isAndroid ? null : ((Get.width)).round(),
          imageUrl: imagePathOrUrl!,
          fit: fit ?? BoxFit.cover,
          // fadeOutDuration: Duration.zero,
          fadeInCurve: Curves.linear,

          errorWidget: (context, url, error) {
            return Image.asset(
              fit: BoxFit.fill,
              isProfilePicture == true
                  ? MyImageURL.dummyProfileImage
                  : MyImageURL.dummyfeedImage,
            );
          },

          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius ?? 0),
            ),
          ).shimmer(),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: imagePathOrUrl != null &&
                imagePathOrUrl != "" &&
                imagePathOrUrl != "null"
            ? Image.file(
                File(imagePathOrUrl!),
                fit: fit ?? BoxFit.cover,
              )
            : fromDraftPodcast == true
                ? Image.asset(MyImageURL.audioImage, fit: BoxFit.cover)
                : Image.asset(
                    isProfilePicture == true
                        ? MyImageURL.dummyProfileImage
                        : MyImageURL.dummyfeedImage,
                    fit: BoxFit.cover,
                  ),
      );
    }
  }
}
