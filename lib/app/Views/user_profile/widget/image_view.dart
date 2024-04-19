import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_widget.dart';

class ImageViewWidget extends StatefulWidget {
  ImageViewWidget(
      {super.key, required this.userName, required this.userProfile});
  String? userName;
  String? userProfile;
  @override
  State<ImageViewWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget> {
  ScrollController scrollController = ScrollController();
  UserProfileController userProfileController =
      Get.find<UserProfileController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => userProfileController.imageFeedData.isEmpty
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
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // physics: userProfileController.screenScroll.value == true
              //     ? NeverScrollableScrollPhysics()
              //     : AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: userProfileController.imageFeedData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // childAspectRatio: 3/2,
                //childAspectRatio: Get.height / 600,
                // mainAxisSpacing: 0.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    final homeFeedController = Get.put(HomeFeedController());
                    await homeFeedController.getUserPotDetailsAPI(
                        userProfileController.imageFeedData[index].id, 1);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: MyColors.borderColor,
                          border: Border.all(color: MyColors.whiteColor)),
                      height: Get.width * 0.20,
                      child: userProfileController
                              .imageFeedData[index].mediaData!.isEmpty
                          ? const CustomImageView(
                              imagePathOrUrl: "",
                              isProfilePicture: false,
                            )
                          : CustomImageView(
                              isProfilePicture: false,
                              imagePathOrUrl:
                                  "$baseUrl${userProfileController.imageFeedData[index].mediaData![0].image}")),
                );
              },
            ),
    );
  }
}
