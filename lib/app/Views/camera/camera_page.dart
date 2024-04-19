// import 'dart:developer';
// import 'dart:io';
// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:camerawesome/pigeon.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:watermel/app/Views/camera/video_preview.dart';
// import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
// import 'package:watermel/app/Views/create_new_feed/create_new_feed.dart';
// import 'package:watermel/app/Views/draft/edit_draft-screen.dart';

// class CameraPage extends StatelessWidget {
//   CameraPage(
//       {super.key,
//       required this.fromEdit,
//       this.ind,
//       this.draftList,
//       this.thumbnailURL,
//       this.caption,
//       this.isPrivate,
//       this.mediaURL,
//       this.selectedType});
//   bool? fromEdit, isPrivate;

//   int? ind;
//   List? draftList = [];
//   int? selectedType;
//   String? thumbnailURL, caption, mediaURL;
//   @override
//   Widget build(BuildContext context) {
//     log("check file payh ==> ${ind}");

//     return PopScope(
//       canPop: false,
//       onPopInvoked: (v) async {
//         log("check file payh ==> ${ind}");

//         fromEdit == true
//             ? Get.offAll(
//                 () => EditDraftScreen(
//                       fromVideoRecording: false,
//                       isPrivate: isPrivate,
//                       thumbnailURL: thumbnailURL,
//                       postType: selectedType,
//                       index: ind,
//                       mediaURL: draftList?[ind!]["videopath"] ?? "",
//                       draftList: draftList,
//                     ),
//                 transition: Transition.leftToRight,
//                 duration: Duration(milliseconds: 400))
//             : Get.offAll(
//                 () => CreateNewFeedScreen(
//                       videoPath: mediaURL,
//                       caption: caption,
//                       thumbnailURl: thumbnailURL,
//                       selectedType: selectedType,
//                       fromVideoRecording: false,
//                     ),
//                 transition: Transition.leftToRight,
//                 duration: Duration(milliseconds: 400));
//       },
//       child: Scaffold(
//         body: GestureDetector(
//           onHorizontalDragStart: (details) {
//             CreateFeedController createFeedController =
//                 Get.put(CreateFeedController());
//             fromEdit == true
//                 ? Get.offAll(
//                     () => EditDraftScreen(
//                           fromVideoRecording: false,
//                           isPrivate: isPrivate,
//                           thumbnailURL: thumbnailURL,
//                           postType: selectedType,
//                           index: ind,
//                           mediaURL: draftList?[ind!]["videopath"] ?? "",
//                           draftList: draftList,
//                         ),
//                     transition: Transition.leftToRight,
//                     duration: Duration(milliseconds: 400))
//                 : Get.offAll(
//                     () => CreateNewFeedScreen(
//                           videoPath: mediaURL,
//                           caption: caption,
//                           thumbnailURl: thumbnailURL,
//                           selectedType: selectedType,
//                           fromVideoRecording: false,
//                         ),
//                     transition: Transition.leftToRight,
//                     duration: Duration(milliseconds: 400));
//           },
//           child: Container(
//             color: Colors.white,
//             child: CameraAwesomeBuilder.awesome(
//               saveConfig: SaveConfig.video(
//                 // initialCaptureMode: CaptureMode.photo,
//                 mirrorFrontCamera: false,

//                 videoOptions: VideoOptions(
//                   enableAudio: true,
//                   ios: CupertinoVideoOptions(
//                     fps: 10,
//                   ),
//                   android: AndroidVideoOptions(
//                     bitrate: 6000000,
//                     fallbackStrategy: QualityFallbackStrategy.lower,
//                   ),
//                 ),
//                 pathBuilder: (sensors) async {
//                   final Directory extDir = await getTemporaryDirectory();
//                   final testDir = await Directory(
//                     '${extDir.path}/camerawesome',
//                   ).create(recursive: true);
//                   if (sensors.length == 1) {
//                     final String filePath =
//                         '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

//                     return SingleCaptureRequest(filePath, sensors.first);
//                   } else {
//                     // Separate pictures taken with front and back camera
//                     return MultipleCaptureRequest(
//                       {
//                         for (final sensor in sensors)
//                           sensor:
//                               '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
//                       },
//                     );
//                   }
//                 },
//                 // exifPreferences: ExifPreferences(saveGPSLocation: true),
//               ),
//               sensorConfig: SensorConfig.single(
//                 sensor: Sensor.position(SensorPosition.back),
//                 flashMode: FlashMode.auto,
//                 aspectRatio: CameraAspectRatios.ratio_4_3,
//                 zoom: 0.0,
//               ),
//               enablePhysicalButton: true,

//               // filter: AwesomeFilter.AddictiveRed,
//               previewFit: CameraPreviewFit.contain,
//               onMediaTap: (mediaCapture) {
//                 mediaCapture.captureRequest.when(
//                   single: (single) {
//                     // single.file?.open();
//                     Get.to(() => CapturedVideoPreview(
//                           isPrivate: isPrivate,
//                           caption: caption,
//                           thumbnailURL: thumbnailURL,
//                           draftList: draftList,
//                           ind: ind,
//                           selectedType: selectedType,
//                           fromEdit: fromEdit,
//                           videoURL: single.file?.path,
//                         ));
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   int maxSize = 20 * 1024 * 1024; //20 MB
//   int minSize = 500 * 1024;
// }
