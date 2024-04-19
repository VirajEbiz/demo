// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:watermel/app/core/helpers/contants.dart';
// import 'package:watermel/app/Views/home/homebottom_controller.dart';
// import 'package:watermel/app/Views/user_profile/edit_profile.dart';
// import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
// import 'package:watermel/app/Views/user_profile/widget/coming_soon.dart';
// import 'package:watermel/app/Views/user_profile/widget/image_view.dart';
// import 'package:watermel/app/Views/user_profile/widget/podcast_view.dart';
// import 'package:watermel/app/Views/user_profile/widget/watch_view.dart';
// import 'package:watermel/app/utils/preference.dart';
// import 'package:watermel/app/utils/theme/fonts.dart';
// import 'package:watermel/app/utils/theme/images.dart';
// import 'package:watermel/app/widgets/cache_image_widget.dart';
// import 'package:watermel/app/widgets/common_text.dart';
// import 'package:watermel/home_bottom_bar/home_page.dart';
// import 'package:watermel/main.dart';
// import '../../utils/theme/colors.dart';
// import '../../widgets/common_widget.dart';
// import '../Notification_Follow/follow_controller.dart';

// class UserProfileScreen extends StatefulWidget {
//   UserProfileScreen({super.key, required this.fromProfile, this.userName});
//   bool? fromProfile;
//   String? userName;
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen>
//     with SingleTickerProviderStateMixin {
//   UserProfileController userProfileController =
//       Get.put(UserProfileController());
//   HomeController homeController = Get.put(HomeController());
//   late TabController _tabController;
//   final _controller = ScrollController();

//   @override
//   void initState() {
//     _tabController = TabController(length: 3, vsync: this);
//     userProfileController.tabIndex = 0.obs;
//     userProfileController.getUserprofile(widget.fromProfile == true
//         ? storage.read(MyStorage.userName)
//         : widget.userName);
//     userProfileController.screenScroll.value = true;

//     _controller.addListener(() {
//       // Handle scroll events here
//       print("Scrolled: ${_controller.offset}");
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColors.whiteColor,
//       appBar: appbarPreferredSizeAction(
//           "", true, isActionIcon: false, "My Draft", () {}, backonTap: () {
//         widget.fromProfile == false
//             ? Get.back()
//             : homeController.pageIndex.value = 0;
//         homeController.update();
//         Get.back();
//       }),
//       body: GetBuilder<UserProfileController>(builder: (_) => homeBody()),
//     );
//   }

//   bool onNotification(ScrollNotification notification) {
//     print("in side the loader ==> ");

//     if (notification is ScrollUpdateNotification) {
//       if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
//         userProfileController.screenScroll.value = false;
//         userProfileController.page++;
//         if (userProfileController.page <=
//             (userProfileController.totalFeedPage)) {
//           print(
//               "80..............${userProfileController.tabIndex.value}......${userProfileController.page}.......${userProfileController.totalFeedPage}");
//           if (userProfileController.tabIndex.value == 0) {
//             userProfileController.getuserFeedData(
//                 widget.fromProfile == true
//                     ? storage.read(MyStorage.userName)
//                     : widget.userName,
//                 "read",
//                 false,
//                 true,
//                 userProfileController.page);
//           } else if (userProfileController.tabIndex.value == 1) {
//             userProfileController.getuserFeedData(
//                 widget.fromProfile == true
//                     ? storage.read(MyStorage.userName)
//                     : widget.userName,
//                 "watch",
//                 false,
//                 true,
//                 userProfileController.page);
//           } else if (userProfileController.tabIndex.value == 2) {
//             print("iiiii");
//             userProfileController.getuserFeedData(
//                 widget.fromProfile == true
//                     ? storage.read(MyStorage.userName)
//                     : widget.userName,
//                 "podcast",
//                 false,
//                 true,
//                 userProfileController.page);
//           }
//         }
//       } else if (notification.metrics.pixels ==
//           notification.metrics.minScrollExtent) {
//         userProfileController.screenScroll.value = true;
//         print("107.............");
//       }
//     }
//     return true;
//   }

//   homeBody() {
//     return NotificationListener(
//         onNotification: onNotification,
//         child: ListView(
//           controller: _controller,
//           shrinkWrap: true,
//           physics: const AlwaysScrollableScrollPhysics(),
//           children: [
//             Container(
//               // margin: EdgeInsets.only(bottom: 50),
//               width: double.infinity,
//               // height: double.infinity,
//               height: MediaQuery.of(context).size.height +
//                   MediaQuery.of(context).size.width * 0.3,
//               child: Column(
//                 // mainAxisSize: MainAxisSize.max,
//                 //  shrinkWrap: true,
//                 // scrollDirection: Axis.vertical,
//                 children: [
//                   Center(
//                     child: Obx(
//                       () => MyText(
//                         text_name: userProfileController
//                                     .userProfileData.value.username ==
//                                 null
//                             ? "N/A"
//                             : userProfileController
//                                     .userProfileData.value.username ??
//                                 "N/A",
//                         fontWeight: FontWeight.w600,
//                         txtcolor: MyColors.blackColor,
//                         txtfontsize: FontSizes.s16,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: Insets.i20),
//                   Container(
//                     height: 120,
//                     padding: const EdgeInsets.symmetric(horizontal: Insets.i20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               children: [
//                                 Obx(
//                                   () => MyText(
//                                     text_name: userProfileController
//                                                 .userProfileData
//                                                 .value
//                                                 .followers ==
//                                             null
//                                         ? "0"
//                                         : userProfileController
//                                             .userProfileData.value.followers
//                                             .toString(),
//                                     fontWeight: FontWeight.w600,
//                                     txtcolor: MyColors.blackColor,
//                                     txtfontsize: FontSizes.s18,
//                                   ),
//                                 ),
//                                 MyText(
//                                   text_name: "Followers",
//                                   fontWeight: FontWeight.w400,
//                                   txtcolor: MyColors.grayColor,
//                                   txtfontsize: FontSizes.s12,
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Obx(
//                                   () => MyText(
//                                     text_name: userProfileController
//                                                 .userProfileData
//                                                 .value
//                                                 .following ==
//                                             null
//                                         ? "0"
//                                         : userProfileController
//                                             .userProfileData.value.following
//                                             .toString(),
//                                     fontWeight: FontWeight.w600,
//                                     txtcolor: MyColors.blackColor,
//                                     txtfontsize: FontSizes.s18,
//                                   ),
//                                 ),
//                                 MyText(
//                                   text_name: "Following",
//                                   fontWeight: FontWeight.w400,
//                                   txtcolor: MyColors.grayColor,
//                                   txtfontsize: FontSizes.s12,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                             width: 120,
//                             height: 140,
//                             //color: MyColors.grayColor,
//                             child: Stack(
//                               children: <Widget>[
//                                 Container(
//                                   width: 120,
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     color: MyColors.grayColor,
//                                     shape: BoxShape.circle,

//                                     // image: DecorationImage(
//                                     //     image: (MyStorage.read(MyStorage.userProfile) !=
//                                     //         null &&
//                                     //         MyStorage.read(MyStorage.userProfile)  != "")
//                                     //         ? NetworkImage(
//                                     //       MyStorage.read(MyStorage.userProfile)!,
//                                     //     )
//                                     //         : const AssetImage(
//                                     //       MyImageURL.defaulfProfile,
//                                     //     ) as ImageProvider,
//                                     //     fit: BoxFit.fill  ),
//                                     // border: Border.all(
//                                     //   color: MyColors.redColor,
//                                     //   width: 7.0,
//                                     // ),
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius:
//                                         BorderRadius.circular(Insets.i100),
//                                     child: CustomImageView(
//                                         fit: BoxFit.cover,
//                                         radius: Insets.i1,
//                                         imagePathOrUrl:
//                                             "$baseForImage${userProfileController.userProfileData.value.profilePicture}"),
//                                   ),
//                                 ),
//                                 // Positioned(
//                                 //     bottom: 0,
//                                 //     right: 4,
//                                 //     child: SvgPicture.asset(
//                                 //       MyImageURL.watermelImage,
//                                 //       height: Insets.i25,
//                                 //       // color: MyColors.whiteColor,
//                                 //     ))
//                               ],
//                             )),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               children: [
//                                 Obx(
//                                   () => MyText(
//                                     text_name: userProfileController
//                                                 .userProfileData
//                                                 .value
//                                                 .totalSeeds ==
//                                             null
//                                         ? "0"
//                                         : userProfileController
//                                             .userProfileData.value.totalSeeds
//                                             .toString(),
//                                     fontWeight: FontWeight.w600,
//                                     txtcolor: MyColors.blackColor,
//                                     txtfontsize: FontSizes.s18,
//                                   ),
//                                 ),
//                                 MyText(
//                                   text_name: "Posts",
//                                   fontWeight: FontWeight.w400,
//                                   txtcolor: MyColors.grayColor,
//                                   txtfontsize: FontSizes.s12,
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Obx(
//                                   () => MyText(
//                                     text_name: userProfileController
//                                                 .userProfileData
//                                                 .value
//                                                 .noOfInfluencer ==
//                                             null
//                                         ? "0"
//                                         : userProfileController.userProfileData
//                                             .value.noOfInfluencer
//                                             .toString(),
//                                     fontWeight: FontWeight.w600,
//                                     txtcolor: MyColors.blackColor,
//                                     txtfontsize: FontSizes.s18,
//                                   ),
//                                 ),
//                                 MyText(
//                                   text_name: "No. of \n Influencers",
//                                   fontWeight: FontWeight.w400,
//                                   txtcolor: MyColors.grayColor,
//                                   txtfontsize: FontSizes.s12,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: Insets.i15),
//                   Center(
//                     child: Obx(
//                       () => SizedBox(
//                         width: Get.width * 0.5,
//                         child: MyText(
//                           maxline: 2,
//                           text_name: userProfileController
//                                   .userProfileData.value.displayName ??
//                               "N/A",
//                           fontWeight: FontWeight.w400,
//                           txtcolor: MyColors.grayColor,
//                           txtfontsize: FontSizes.s14,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: Insets.i20),
//                   widget.fromProfile == false ? otherUserProfile() : SizedBox(),
//                   const SizedBox(height: Insets.i20),
//                   widget.fromProfile == true ? personalProfile() : SizedBox(),
//                   const SizedBox(height: Insets.i30),
//                   Obx(() => userProfileController.userProfileData.value != null
//                       ? userProfileController
//                                   .userProfileData.value.specificUserPrivacy ==
//                               false
//                           ? userAcconutPublic()
//                           : userAcconutPrivate()
//                       : Container())
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }

//   userAcconutPrivate() {
//     return Container(
//       margin:
//           EdgeInsets.symmetric(horizontal: Insets.i20, vertical: Insets.i20),
//       child: Column(
//         children: [
//           Icon(Icons.lock, size: Insets.i60),
//           SizedBox(height: Insets.i5),
//           MyText(
//             text_name: "This Account is private",
//             fontWeight: FontWeight.w500,
//             txtcolor: MyColors.blackColor,
//             txtfontsize: FontSizes.s18,
//           ),
//           SizedBox(height: Insets.i5),
//           MyText(
//             text_name: "Follow this account to see their photos and videos.",
//             fontWeight: FontWeight.w400,
//             txtcolor: MyColors.blackColor,
//             txtfontsize: FontSizes.s14,
//           ),
//         ],
//       ),
//     );
//   }

//   userAcconutPublic() {
//     return Flexible(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 00.0),
//         child: Column(
//           // mainAxisSize: MainAxisSize.max,
//           children: [
//             DecoratedBox(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.0),
//                   border: Border(
//                       bottom:
//                           BorderSide(color: MyColors.blackColor, width: 0.9)),
//                 ),
//                 child: TabBar(
//                     isScrollable: false,
//                     onTap: (value) {
//                       userProfileController.tabIndex.value = value;
//                       if (value == 0) {
//                         userProfileController.page = 1;
//                         userProfileController.getuserFeedData(
//                             widget.fromProfile == true
//                                 ? storage.read(MyStorage.userName)
//                                 : widget.userName,
//                             "read",
//                             true,
//                             false,
//                             userProfileController.page);
//                       } else if (value == 1) {
//                         userProfileController.page = 1;
//                         userProfileController.getuserFeedData(
//                             widget.fromProfile == true
//                                 ? storage.read(MyStorage.userName)
//                                 : widget.userName,
//                             "watch",
//                             true,
//                             false,
//                             userProfileController.page);
//                       } else {
//                         userProfileController.page = 1;
//                         userProfileController.getuserFeedData(
//                             widget.fromProfile == true
//                                 ? storage.read(MyStorage.userName)
//                                 : widget.userName,
//                             "podcast",
//                             true,
//                             false,
//                             userProfileController.page);
//                       }
//                     },
//                     tabs: [
//                       Tab(
//                           child: SvgPicture.asset(
//                         MyImageURL.FrameImage,
//                         height: Insets.i28,
//                         color: MyColors.blackColor,
//                       )),
//                       Tab(
//                           child: SvgPicture.asset(
//                         MyImageURL.videoplay,
//                         height: Insets.i30,
//                         color: MyColors.grayColor,
//                       )),
//                       Tab(
//                           child: SvgPicture.asset(
//                         MyImageURL.readseedImage,
//                         height: Insets.i28,
//                         color: MyColors.grayColor,
//                       )),
//                     ],
//                     indicatorColor: MyColors.blackColor,
//                     controller: _tabController,
//                     indicatorSize: TabBarIndicatorSize.tab)),
//             const SizedBox(height: Insets.i30),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 0.0),
//                 child: SizedBox(
//                     // height: MediaQuery.of(context)
//                     //     .size
//                     //     .height, // or every other size ,
//                     child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     Container(
//                       // height: Get.height,
//                       child: ImageViewWidget(
//                         userProfile: userProfileController
//                             .userProfileData.value.profilePicture,
//                         userName: widget.fromProfile == true
//                             ? storage.read(MyStorage.userName)
//                             : widget.userName,
//                       ),
//                     ),
//                     WatchViewWidget(
//                       userProfile: userProfileController
//                           .userProfileData.value.profilePicture,
//                       userName: widget.fromProfile == true
//                           ? storage.read(MyStorage.userName)
//                           : widget.userName,
//                     ),
//                     PodcastViewWidget(
//                       displayName: widget.fromProfile == true
//                           ? storage.read(MyStorage.displayName)
//                           : userProfileController
//                               .userProfileData.value.displayName,
//                       userProfile: userProfileController
//                           .userProfileData.value.profilePicture,
//                       userName: widget.fromProfile == true
//                           ? storage.read(MyStorage.userName)
//                           : widget.userName,
//                     )
//                   ],
//                 )),
//               ),
//             ),
//             // const SizedBox(height: Insets.i30),
//           ],
//         ),
//       ),
//     );
//   }

//   personalProfile() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: Insets.i20),
//       child: Row(
//         children: [
//           Expanded(
//               flex: 8,
//               child: GestureDetector(
//                 onTap: () {
//                   String textToShare = userProfileController
//                           .userProfileData.value.shareProfileUrl ??
//                       "";
//                   Share.share(textToShare);
//                 },
//                 child: Container(
//                   height: Get.height * 0.05,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: MyColors.greenColor,
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: SvgPicture.asset(
//                             MyImageURL.share,
//                             height: Insets.i13,
//                             color: MyColors.whiteColor,
//                           )),
//                       MyText(
//                         text_name: "Share Profile",
//                         fontWeight: FontWeight.w400,
//                         txtcolor: MyColors.whiteColor,
//                         txtfontsize: FontSizes.s14,
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
//           const SizedBox(width: Insets.i10),
//           Expanded(
//               flex: 2,
//               child: GestureDetector(
//                 onTap: () {
//                   Get.to(() => EditProfileScreen(
//                         userName: userProfileController
//                             .userProfileData.value.displayName,
//                       ));
//                 },
//                 child: Container(
//                   height: Get.height * 0.05,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: MyColors.redColor,
//                   ),
//                   child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: SvgPicture.asset(
//                         MyImageURL.editProfile,

//                         //height: Insets.i15,
//                       )),
//                 ),
//               )),
//         ],
//       ),
//     );
//   }

//   otherUserProfile() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: Insets.i20),
//       child: Row(
//         children: [
//           Expanded(
//               flex: 5,
//               child: GestureDetector(
//                 onTap: () async {
//                   /*  FollowController followController =
//                       Get.put(FollowController());
//                   userProfileController.userProfileData.value.followStatus ==
//                           true
//                       ? await followController.rejectFollowReqAPI(2)
//                       : await userProfileController.FollowTheUsesr(
//                           widget.userName);*/
//                   manageFollowButtonEvent(
//                       userProfileController.userProfileData.value.followStatus,
//                       userProfileController
//                           .userProfileData.value.followRequestStatus);
//                 },
//                 child: Obx(
//                   () => Container(
//                     height: Get.height * 0.05,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       border: Border.all(
//                           color: userProfileController
//                                       .userProfileData.value.followStatus ==
//                                   true
//                               ? MyColors.greenColor
//                               : Colors.transparent),
//                       color: userProfileController
//                                   .userProfileData.value.followStatus ==
//                               true
//                           ? Colors.transparent
//                           : MyColors.greenColor,
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 5),
//                             child: SvgPicture.asset(
//                               MyImageURL.messageImage,
//                               height: Insets.i13,
//                               color: userProfileController
//                                           .userProfileData.value.followStatus ==
//                                       true
//                                   ? MyColors.greenColor
//                                   : MyColors.whiteColor,
//                             )),
//                         MyText(
//                           text_name: manageFollowButton(
//                               userProfileController
//                                   .userProfileData.value.specificUserPrivacy,
//                               userProfileController
//                                   .userProfileData.value.followStatus,
//                               userProfileController
//                                   .userProfileData.value.followRequestStatus),
//                           fontWeight: FontWeight.w400,
//                           txtcolor: userProfileController
//                                       .userProfileData.value.followStatus ==
//                                   true
//                               ? MyColors.greenColor
//                               : MyColors.whiteColor,
//                           txtfontsize: FontSizes.s14,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )),
//           SizedBox(width: Insets.i10),
//           Expanded(
//               flex: 5,
//               child: Container(
//                 height: Get.height * 0.05,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: MyColors.redColor,
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: GestureDetector(
//                   onTap: () {
//                     Get.to(() => ComingSoonWidget(
//                           fromHome: false,
//                         ));
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: SvgPicture.asset(
//                             MyImageURL.messageImage,
//                             height: Insets.i13,
//                             color: MyColors.whiteColor,
//                           )),
//                       MyText(
//                         text_name: "Message",
//                         fontWeight: FontWeight.w400,
//                         txtcolor: MyColors.whiteColor,
//                         txtfontsize: FontSizes.s14,
//                       ),
//                     ],
//                   ),
//                 ),
//               )),
//           const SizedBox(width: Insets.i10),
//           Expanded(
//               flex: 2,
//               child: GestureDetector(
//                 onTap: () {
//                   Get.offAll(() => HomePage());
//                 },
//                 child: Container(
//                   height: Get.height * 0.05,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: MyColors.borderColor,
//                   ),
//                   child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: SvgPicture.asset(
//                         MyImageURL.accountImage,
//                         height: Insets.i10,
//                       )),
//                 ),
//               )),
//         ],
//       ),
//     );
//   }

//   manageFollowButton(userprivacy, followStatus, followReqStatus) {
//     if (followStatus == true) {
//       return "Following";
//     } else if (followStatus == false && followReqStatus == true) {
//       return "Requested";
//     } else {
//       return "Follow";
//     }
//   }

//   manageFollowButtonEvent(followStatus, followReqStatus) async {
//     if (followStatus == true) {
//       return ShowMyBottomSheet(context);
//     } else if (followStatus == false && followReqStatus == true) {
//       return "";
//     } else {
//       await userProfileController.FollowTheUsesr(widget.userName);
//     }
//   }

//   ShowMyBottomSheet(context) {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(Insets.i20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         height: 20,
//                         width: 4,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(100),
//                             color: MyColors.greenColor),
//                       ),
//                       const SizedBox(
//                         width: Insets.i10,
//                       ),
//                       MyText(
//                         fontWeight: FontWeight.w600,
//                         txtfontsize: FontSizes.s18,
//                         text_name: userProfileController
//                                 .userProfileData.value.displayName ??
//                             "N/A",
//                       ),
//                     ],
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: Insets.i36,
//                       width: Insets.i36,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle, color: MyColors.lightGray),
//                       child: const Icon(Icons.close),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: Insets.i10,
//               ),
//               InkWell(
//                 onTap: () async {
//                   confirmPopup(context);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       MyText(
//                         fontWeight: FontWeight.w400,
//                         txtfontsize: FontSizes.s15,
//                         text_name: "Unfollow",
//                         txtcolor: MyColors.blackColor,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               (userProfileController.userProfileData.value.followReqBack ==
//                           true &&
//                       userProfileController
//                               .userProfileData.value.followRequestStatus ==
//                           false &&
//                       userProfileController
//                               .userProfileData.value.followReqBack ==
//                           true)
//                   ? InkWell(
//                       onTap: () async {
//                         Get.back();

//                         FollowController followController =
//                             Get.put(FollowController());
//                         await followController.acceptFollowReqAPI(
//                             userProfileController.userProfileData.value.userId,
//                             false);
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             MyText(
//                               fontWeight: FontWeight.w400,
//                               txtfontsize: FontSizes.s15,
//                               text_name: "Follow back",
//                               txtcolor: MyColors.blackColor,
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   confirmPopup(BuildContext context) async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: MyText(
//               text_name: "WaterMel App",
//               fontWeight: FontWeight.w500,
//               txtcolor: MyColors.blackColor,
//               txtfontsize: FontSizes.s15,
//             ),
//             content: MyText(
//               text_name: "Are you sure You want unfollow this user?",
//               fontWeight: FontWeight.w400,
//               txtcolor: MyColors.blackColor,
//               txtfontsize: FontSizes.s14,
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Get.back();
//                   Get.back();
//                 },
//                 child: MyText(
//                   text_name: "No",
//                   fontWeight: FontWeight.w600,
//                   txtcolor: MyColors.blackColor,
//                   txtfontsize: FontSizes.s16,
//                 ),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   Get.back();

//                   FollowController followController =
//                       Get.put(FollowController());
//                   await followController
//                       .rejectFollowReqAPI(
//                           userProfileController.userProfileData.value.userId,
//                           false)
//                       .then((value) {
//                     print("value......>>$value");
//                     if (value == true) {
//                       print("value......>>$value");
//                       userProfileController.userProfileData.value.followStatus =
//                           false;
//                       userProfileController.getUserprofile(
//                           userProfileController.userProfileData.value.username);
//                       userProfileController.update();
//                     }
//                   });
//                   Get.back();
//                 },
//                 child: MyText(
//                   text_name: "Yes",
//                   fontWeight: FontWeight.w600,
//                   txtcolor: MyColors.blackColor,
//                   txtfontsize: FontSizes.s16,
//                 ),
//               ),
//             ],
//           ),
//         )) ??
//         false;
//   }
// }
