import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';
import 'package:watermel/main.dart';

class PodcastViewWidget extends StatefulWidget {
  PodcastViewWidget(
      {super.key,
      required this.userName,
      required this.userProfile,
      required this.displayName});
  String? userName;
  String? userProfile;
  String? displayName;
  @override
  State<PodcastViewWidget> createState() => _PodcastViewWidgetState();
}

class _PodcastViewWidgetState extends State<PodcastViewWidget> {
  UserProfileController userProfileController =
      Get.find<UserProfileController>();

  @override
  Widget build(BuildContext context) {
    log("Check data length==> ${userProfileController.podcastFeedData.length}");
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: Insets.i25),
        child: userProfileController.podcastFeedData.isEmpty
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
                physics: NeverScrollableScrollPhysics(),
                // physics: userProfileController.screenScroll.value == true
                //     ? NeverScrollableScrollPhysics()
                //     : AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: userProfileController.podcastFeedData.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 30,
                    mainAxisExtent: Get.height * 0.27),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      // Get.to(()=> PostDetailScreen());
                      final ct = Get.put(HomeFeedController());
                      userProfileController
                                  .podcastFeedData[index].mediaData![0].video !=
                              null
                          ? ct.getUserPotDetailsAPI(
                              userProfileController.podcastFeedData[index].id,
                              2)
                          : ct.getUserPotDetailsAPI(
                              userProfileController.podcastFeedData[index].id,
                              3);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // color: MyColors.borderColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: userProfileController.podcastFeedData[index]
                                        .mediaData!.first.video !=
                                    null
                                ? SizedBox(
                                    width: Get.width,
                                    height: Get.height * 0.18,
                                    child: CustomImageView(
                                        isProfilePicture: false,
                                        fit: BoxFit.cover,
                                        imagePathOrUrl: userProfileController
                                                    .podcastFeedData[index]
                                                    .thumnailURL ==
                                                null
                                            ? ""
                                            : "$baseForImage${userProfileController.podcastFeedData[index].thumnailURL}"),
                                  )
                                : userProfileController.podcastFeedData[index]
                                            .thumnailURL ==
                                        null
                                    ? Image.asset(
                                        MyImageURL.audioImage,
                                        fit: BoxFit.cover,
                                        height: Get.height * 0.18,
                                      )
                                    : SizedBox(
                                        width: Get.width,
                                        height: Get.height * 0.18,
                                        child: CustomImageView(
                                            isProfilePicture: false,
                                            fit: BoxFit.cover,
                                            imagePathOrUrl:
                                                "$baseForImage${userProfileController.podcastFeedData[index].thumnailURL}"),
                                      ),
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8),
                        //       //  color: MyColors.borderColor,
                        //       border: Border.all(color: MyColors.whiteColor)),
                        //   alignment: Alignment.center,
                        //   height: Get.height * 0.17,
                        //   child:
                        //       Image.asset(MyImageURL.dummypodcast, fit: BoxFit.fill),
                        // ),
                        const SizedBox(height: Insets.i10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: MyText(
                                maxline: 2,
                                txtAlign: TextAlign.start,
                                text_name: userProfileController
                                        .podcastFeedData[index].caption ??
                                    "",
                                fontWeight: FontWeight.w600,
                                txtcolor: MyColors.blackColor,
                                txtfontsize: FontSizes.s10,
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: SvgPicture.asset(
                                      MyImageURL.playvideo,
                                      height: Insets.i20,
                                    ))),
                          ],
                        ),
                        const SizedBox(height: Insets.i3),
                        storage.read(MyStorage.userName) == widget.userName
                            ? SizedBox()
                            : Flexible(
                                child: MyText(
                                  txtAlign: TextAlign.start,
                                  text_name:
                                      storage.read(MyStorage.displayName),
                                  fontWeight: FontWeight.w500,
                                  txtcolor: MyColors.grayColor,
                                  txtfontsize: FontSizes.s10,
                                ),
                              ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
