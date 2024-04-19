// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:video_player/video_player.dart';
// import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
// import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
// import 'package:watermel/app/core/helpers/contants.dart';
// import 'package:watermel/app/utils/preference.dart';
// import 'package:watermel/app/utils/theme/colors.dart';
// import 'package:watermel/app/utils/theme/fonts.dart';
// import 'package:watermel/app/utils/theme/images.dart';
// import 'package:watermel/app/utils/toast.dart';
// import 'package:watermel/app/widgets/cache_image_widget.dart';
// import 'package:watermel/app/widgets/common_text.dart';
// import 'package:watermel/app/widgets/common_widget.dart';
// import 'package:watermel/main.dart';

// import '../../../addComment/addcomments.dart';

// class ProfileVideoDetailScreen extends StatefulWidget {
//   ProfileVideoDetailScreen({
//     super.key,
//   });

//   @override
//   State<ProfileVideoDetailScreen> createState() =>
//       ProfileVideoDetailScreenState();
// }

// class ProfileVideoDetailScreenState extends State<ProfileVideoDetailScreen> {
//   HomeFeedController homeFeedController = Get.put(HomeFeedController());

//   @override
//   void initState() {
//     super.initState();
//     onloadMethod();
//     // getData();
//   }

//   onloadMethod() async {
//     // await homeFeedController.getUserPotDetailsAPI(widget.feedID);
//     await setVideo();
//     getData();
//   }

//   getData() async {
//     homeFeedController.CommentCount.value = int.parse(
//         homeFeedController.profilePostDetails.value.commentsCount.toString());
//     homeFeedController.ReactionCount.value = int.parse(
//         homeFeedController.profilePostDetails.value.reactionsCount.toString());
//     homeFeedController.isBookMarkedtemp.value =
//         homeFeedController.profilePostDetails.value.bookmark ?? false;
//   }

//   late VideoPlayerController _controller;
//   Future setVideo() async {
//     log("Check video path ==> ${homeFeedController.profilePostDetails.value.mediaData?.first.video}");
//     try {
//       _controller = VideoPlayerController.networkUrl(Uri.parse(
//           "$baseUrl${homeFeedController.profilePostDetails.value.mediaData!.first.video}"))
//         ..initialize().then((_) {
//           _isPlaying.value = true;
//           isShowSlider.value = true;
//           setState(() {});
//         })
//         ..addListener(() {
//           setState(() {});
//         });
//       ;
//       await _controller.play();
//     } catch (e) {
//       Toaster().warning(e.toString());
//     }
//   }

//   RxBool _isPlaying = false.obs;
//   RxBool isShowSlider = false.obs;

//   void _togglePlaying() {
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//       _isPlaying.value = false;
//     } else {
//       _controller.play();
//       _isPlaying.value = true;
//     }
//   }

//   void _onSeek(double value) {
//     final duration = _controller.value.duration;
//     final newPosition = value * duration.inMilliseconds;
//     _controller.seekTo(Duration(milliseconds: newPosition.round()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: MyColors.blackColor,
//         body: Obx(
//           () => Column(
//             children: [
//               Container(
//                 color: MyColors.blackColor,
//                 child: Container(
//                   margin: EdgeInsets.only(top: Get.height * 0.05),
//                   padding: EdgeInsets.symmetric(horizontal: Insets.i15),
//                   color: MyColors.blackColor,
//                   height: Get.height * 0.1,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           storage.read(MyStorage.userName) ==
//                                   homeFeedController
//                                       .profilePostDetails.value.user?.username
//                               ? Get.to(() => UserProfileScreenbackup(
//                                     fromProfile: true,
//                                     userName: storage.read(MyStorage.userName),
//                                   ))
//                               : Get.to(() => UserProfileScreenbackup(
//                                     fromProfile: false,
//                                     userName: homeFeedController
//                                         .profilePostDetails
//                                         .value
//                                         .user
//                                         ?.username,
//                                   ));
//                         },
//                         child: Row(
//                           children: [
//                             Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     Get.back();
//                                   },
//                                   child: Icon(
//                                     Icons.arrow_back_ios_new_rounded,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: Insets.i10,
//                                 ),
//                                 UnicornOutlineButton(
//                                   strokeWidth: 2,
//                                   radius: 100,
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       MyColors.greenColor,
//                                       MyColors.redColor
//                                     ],
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                   ),
//                                   child: Container(
//                                     height: Insets.i60,
//                                     width: Insets.i60,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.circular(Insets.i12),
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(5),
//                                       child: CustomImageView(
//                                           imagePathOrUrl:
//                                               "$baseUrl${homeFeedController.profilePostDetails.value.user!.userprofile!.profilePicture}",
//                                           radius: 100),
//                                     ),
//                                   ),
//                                   onPressed: () {},
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               width: Insets.i10,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 MyText(
//                                   text_name: homeFeedController
//                                           .profilePostDetails
//                                           .value
//                                           .user
//                                           ?.userprofile!
//                                           .displayName ??
//                                       "N/A",
//                                   txtcolor: MyColors.whiteColor,
//                                   fontWeight: FontWeight.w500,
//                                   txtfontsize: FontSizes.s14,
//                                 ),
//                                 MyText(
//                                   text_name: homeFeedController.timeDiffrance(
//                                       homeFeedController.profilePostDetails
//                                               .value.createdAt ??
//                                           ""),
//                                   txtcolor: MyColors.grayColor,
//                                   fontWeight: FontWeight.w400,
//                                   txtfontsize: FontSizes.s12,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           await homeFeedController
//                               .bookMarkTheFeed(
//                                   homeFeedController
//                                       .profilePostDetails.value.id,
//                                   fromProfile: true)
//                               .whenComplete(() {
//                             setState(() {});
//                           });
//                         },
//                         child: Obx(
//                           () => Container(
//                               height: Insets.i50,
//                               width: Insets.i50,
//                               padding: EdgeInsets.all(Insets.i12),
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: MyColors.grayColor.withOpacity(.3)),
//                               child:
//                                   homeFeedController.isBookMarkedtemp.value ==
//                                           true
//                                       ? SvgPicture.asset(
//                                           "assets/images/unbookMark.svg")
//                                       : SvgPicture.asset(
//                                           "assets/images/bookMark.svg")),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: Get.height * 0.85,
//                 width: Get.width,
//                 alignment: Alignment.center,
//                 color: MyColors.blackColor,
//                 child: Stack(
//                   children: [
//                     _controller.value.isInitialized
//                         ? GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _controller.value.isPlaying
//                                     ? _controller.pause()
//                                     : _controller.play();
//                               });
//                             },
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 _controller.value.isInitialized
//                                     ? Center(
//                                         child: AspectRatio(
//                                           aspectRatio:
//                                               _controller.value.aspectRatio,
//                                           child: VideoPlayer(_controller),
//                                         ),
//                                       )
//                                     : mediaLoader(),
//                               ],
//                             ),
//                           )
//                         : mediaLoader(),
//                     Positioned(
//                       right: Insets.i20,
//                       bottom: 130,
//                       child: Container(
//                         height: Get.height * 0.2,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () async {
//                                 String textToShare =
//                                     "Usename:- ${homeFeedController.profilePostDetails.value.user?.username ?? ""}\n Post Detail:-${homeFeedController.profilePostDetails.value.caption}\n ";

//                                 if (Platform.isAndroid) {
//                                   homeFeedController.profilePostDetails.value
//                                                   .mediaData?.first.image ==
//                                               "" ||
//                                           homeFeedController.profilePostDetails
//                                               .value.mediaData!.isEmpty
//                                       ? Share.share(textToShare)
//                                       : homeFeedController
//                                           .downloadAndShareImage(
//                                           "${homeFeedController.profilePostDetails.value.mediaData!.first.image}",
//                                         );
//                                 } else {
//                                   Share.share(textToShare);
//                                 }
//                               },
//                               child: Column(
//                                 children: [
//                                   SvgPicture.asset(
//                                     MyImageURL.detailshare,
//                                     height: Insets.i25,
//                                     width: Insets.i25,
//                                   ),
//                                   SizedBox(
//                                     height: Insets.i10,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () async {
//                                 await homeFeedController
//                                     .getComment(
//                                         homeFeedController
//                                             .profilePostDetails.value.id,
//                                         true)
//                                     .whenComplete(() async {
//                                   homeFeedController.commentController.clear();
//                                   return await openCommentlistModel(
//                                     context,
//                                     homeFeedController
//                                         .profilePostDetails.value.id,
//                                     true,
//                                   );
//                                 });
//                                 setState(() {});
//                               },
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SvgPicture.asset(
//                                     MyImageURL.detailcomment,
//                                     height: Insets.i25,
//                                     width: Insets.i25,
//                                   ),
//                                   SizedBox(
//                                     height: Insets.i5,
//                                   ),
//                                   Obx(
//                                     () => MyText(
//                                       text_name: homeFeedController
//                                           .CommentCount.value
//                                           .toString(),
//                                       txtcolor: MyColors.whiteColor,
//                                       fontWeight: FontWeight.w500,
//                                       txtfontsize: FontSizes.s14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () async {
//                                 await homeFeedController
//                                     .reactionAPI(
//                                         homeFeedController
//                                             .profilePostDetails.value.id,
//                                         true)
//                                     .whenComplete(() {
//                                   setState(() {});
//                                 });
//                               },
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SvgPicture.asset(
//                                     MyImageURL.likecomment,
//                                     height: Insets.i25,
//                                     width: Insets.i25,
//                                     color: homeFeedController.profilePostDetails
//                                                 .value.myReaction !=
//                                             null
//                                         ? Colors.red
//                                         : Colors.white,
//                                   ),
//                                   const SizedBox(
//                                     height: Insets.i5,
//                                   ),
//                                   Obx(
//                                     () => MyText(
//                                       text_name: homeFeedController
//                                           .ReactionCount.value
//                                           .toString(),
//                                       txtcolor: MyColors.whiteColor,
//                                       fontWeight: FontWeight.w500,
//                                       txtfontsize: FontSizes.s14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: Insets.i20,
//                       bottom: Insets.i150,
//                       right: Insets.i60,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Obx(
//                             () => MyText(
//                               text_name: viewText(
//                                   homeFeedController
//                                       .profilePostDetails.value.caption
//                                       .toString(),
//                                   !isViewMore.value),
//                               txtcolor: MyColors.whiteColor,
//                               fontWeight: FontWeight.w500,
//                               txtfontsize: FontSizes.s14,
//                             ),
//                           ),
//                           homeFeedController.profilePostDetails.value.caption
//                                       .toString()
//                                       .length >
//                                   50
//                               ? Obx(() => InkWell(
//                                     onTap: () {
//                                       isViewMore.value = !isViewMore.value;
//                                     },
//                                     child: MyText(
//                                       text_name: !isViewMore.value
//                                           ? "View more"
//                                           : "View less",
//                                       fontWeight: FontWeight.bold,
//                                       txtfontsize: FontSizes.s14,
//                                       txtcolor: MyColors.whiteColor,
//                                       txtAlign: TextAlign.left,
//                                     ),
//                                   ))
//                               : Container(),
//                         ],
//                       ),
//                     ),
//                     Obx(
//                       () => isShowSlider.value == false
//                           ? SizedBox()
//                           : Positioned(
//                               left: Insets.i20,
//                               bottom: Insets.i40,
//                               right: Insets.i20,
//                               child: Column(
//                                 children: [
//                                   Obx(
//                                     () => _isPlaying.value == true
//                                         ? Slider.adaptive(
//                                             min: 0.0,
//                                             value: _controller.value.position
//                                                     .inMilliseconds /
//                                                 _controller.value.duration
//                                                     .inMilliseconds,
//                                             onChanged: (value) {
//                                               print(
//                                                   "Check ==> ${_controller.value.duration.inSeconds}");
//                                               _onSeek(value);
//                                             },
//                                           )
//                                         : SizedBox(),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       MyText(
//                                         text_name:
//                                             "${_controller.value.position.inHours}:${_controller.value.position.inMinutes}:${_controller.value.position.inSeconds}",
//                                         txtcolor: MyColors.whiteColor,
//                                       ),
//                                       Obx(
//                                         () => GestureDetector(
//                                           onTap: () async {
//                                             _togglePlaying();
//                                             setState(() {});
//                                           },
//                                           child: Center(
//                                             child: Container(
//                                               height: 48,
//                                               alignment: Alignment.center,
//                                               width: 48,
//                                               decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: MyColors.redColor),
//                                               child: _isPlaying.value
//                                                   ? Icon(
//                                                       Icons.pause,
//                                                       color:
//                                                           MyColors.whiteColor,
//                                                     )
//                                                   : SvgPicture.asset(
//                                                       MyImageURL.playIcon,
//                                                       color:
//                                                           MyColors.whiteColor,
//                                                     ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       MyText(
//                                         text_name:
//                                             "${_controller.value.duration.inHours}:${_controller.value.duration.inMinutes}:${_controller.value.duration.inSeconds}",
//                                         txtcolor: MyColors.whiteColor,
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               )),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   RxBool isViewMore = false.obs;
//   viewText(detail, isview) {
//     if (detail.length < 50) {
//       return detail;
//     } else if (detail.length > 50) {
//       if (isview) {
//         return "${detail.substring(0, 50)}";
//       } else {
//         return detail;
//       }
//     } else {
//       return detail;
//     }
//   }
// }

// class UnicornOutlineButton extends StatelessWidget {
//   final _GradientPainter _painter;
//   final Widget _child;
//   final VoidCallback _callback;
//   final double _radius;

//   UnicornOutlineButton({
//     required double strokeWidth,
//     required double radius,
//     required Gradient gradient,
//     required Widget child,
//     required VoidCallback onPressed,
//   })  : this._painter = _GradientPainter(
//             strokeWidth: strokeWidth, radius: radius, gradient: gradient),
//         this._child = child,
//         this._callback = onPressed,
//         this._radius = radius;

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _painter,
//       child: GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: _callback,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(_radius),
//           onTap: _callback,
//           child: Container(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 _child,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _GradientPainter extends CustomPainter {
//   final Paint _paint = Paint();
//   final double radius;
//   final double strokeWidth;
//   final Gradient gradient;

//   _GradientPainter(
//       {required double strokeWidth,
//       required double radius,
//       required Gradient gradient})
//       : this.strokeWidth = strokeWidth,
//         this.radius = radius,
//         this.gradient = gradient;

//   @override
//   void paint(Canvas canvas, Size size) {
//     // create outer rectangle equals size
//     Rect outerRect = Offset.zero & size;
//     var outerRRect =
//         RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

//     // create inner rectangle smaller by strokeWidth
//     Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
//         size.width - strokeWidth * 2, size.height - strokeWidth * 2);
//     var innerRRect = RRect.fromRectAndRadius(
//         innerRect, Radius.circular(radius - strokeWidth));

//     // apply gradient shader
//     _paint.shader = gradient.createShader(outerRect);

//     // create difference between outer and inner paths and draw it
//     Path path1 = Path()..addRRect(outerRRect);
//     Path path2 = Path()..addRRect(innerRRect);
//     var path = Path.combine(PathOperation.difference, path1, path2);
//     canvas.drawPath(path, _paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
// }
