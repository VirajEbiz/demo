import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_widget.dart';

import '../user_profile_controller.dart';

class WatchViewWidget extends StatefulWidget {
  WatchViewWidget(
      {super.key, required this.userName, required this.userProfile});
  String? userName;
  String? userProfile;
  @override
  State<WatchViewWidget> createState() => _WatchViewWidgetState();
}

class _WatchViewWidgetState extends State<WatchViewWidget> {
  UserProfileController userProfileController =
      Get.find<UserProfileController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userProfileController.getuserFeedData("watch");
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    log("Chek data ==> ${scrollController.position.pixels}");
    log("Chek data ==> ${scrollController.position.maxScrollExtent}");
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // User reached the end of the grid, load more data
    }
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => userProfileController.watchFeedData.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: Get.height * 0.15,
                ),
                MyNoPost(),
                SizedBox(
                  height: Get.height * 0.3,
                )
              ],
            )
          : GridView.builder(
              controller: scrollController,
              physics: NeverScrollableScrollPhysics(),
              // physics: userProfileController.screenScroll.value == true
              //     ? NeverScrollableScrollPhysics()
              //     : AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: userProfileController.watchFeedData.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    final ct = Get.put(HomeFeedController());
                    await ct.getUserPotDetailsAPI(
                        userProfileController.watchFeedData[index].id, 2);
                    // Get.to(() => VideoPostDetailScreen(
                    //       myDate: userProfileController
                    //           .watchFeedData[index].createdAt,
                    //       caption: userProfileController
                    //           .watchFeedData[index].caption,
                    //       commentCount: "",
                    //       likeCOunt: "",
                    //       userProfile: widget.userProfile,
                    //       isBookMark: false,
                    //       feedID: 0,
                    //       userName: widget.userName,
                    //       fromProfile: true,
                    //       index: index,
                    //       videoURL:
                    //           "$baseUrl${userProfileController.watchFeedData[index].mediaData![0].video!}",
                    //     ));
                    // Get.to(
                    //   () => VIdeoPlayerForURL(
                    //     videoUrl:
                    //         "$baseUrl${userProfileController.watchFeedData[index].mediaData![0].video!}",
                    //   ),
                    // );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: MyColors.borderColor,
                            border: Border.all(color: MyColors.whiteColor)),
                        alignment: Alignment.center,
                        // height: Get.width * 0.20,
                        child: SizedBox(
                            height: Get.height,
                            width: Get.width,
                            child: CustomImageView(
                                isProfilePicture: false,
                                fit: BoxFit.cover,
                                imagePathOrUrl: userProfileController
                                            .watchFeedData[index]
                                            .thumbnailURL ==
                                        null
                                    ? ""
                                    : "$baseForImage${userProfileController.watchFeedData[index].thumbnailURL}")),

                        // userProfileController
                        //         .watchFeedData[index].mediaData!.isNotEmpty
                        // ? Image.network(userProfileController
                        //     .watchFeedData[index].mediaData![0].video!)
                        //     : Image.asset(MyImageURL.dummyfeedImage,
                        //         fit: BoxFit.fill),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            MyImageURL.vedioplay,
                            height: Insets.i25,
                            // color: MyColors.whiteColor,
                          ))
                    ],
                  ),
                );
              }),
    );
  }
}
