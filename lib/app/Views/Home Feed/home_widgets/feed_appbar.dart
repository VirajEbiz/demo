import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/scroll_controller.dart';
import 'package:watermel/app/Views/setting/setting.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/common_text.dart';

class FeedAppBarWidget extends StatelessWidget {
  FeedAppBarWidget(
      {super.key,
      required this.mesageTap,
      required this.notificationTap,
      required this.searchTap});
  void Function()? searchTap;
  void Function()? notificationTap;
  void Function()? mesageTap;

  HomeFeedController homeFeedController = Get.find<HomeFeedController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Insets.i20, vertical: Insets.i10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => SettingScreen(),
                      transition: Transition.leftToRight,
                      duration: Duration(milliseconds: 400));
                },
                child: Image.asset(
                  MyImageURL.homeMenu,
                  height: Insets.i28,
                  width: Insets.i28,
                ),
              ),
              const SizedBox(width: Insets.i10),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.find<HomeScrollController>().scrollToTop(),
                  child: SvgPicture.asset(MyImageURL.appMainIcon),
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: searchTap,
                child: SvgPicture.asset(
                  MyImageURL.searchGlass,
                  height: Insets.i21,
                  width: Insets.i21,
                ),
              ),
              const SizedBox(width: Insets.i20),
              GestureDetector(
                onTap: notificationTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      MyImageURL.notification,
                      height: Insets.i21,
                      width: Insets.i21,
                    ),
                    Obx(
                      () => homeFeedController.notificationCount.value == 0
                          ? SizedBox()
                          : Positioned(
                              bottom: Insets.i10,
                              left: Insets.i8,
                              child: Container(
                                height: Insets.i15,
                                width: Insets.i15,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: MyText(
                                  text_name: homeFeedController
                                      .notificationCount.value
                                      .toString(),
                                  txtcolor: MyColors.whiteColor,
                                  fontWeight: FontWeight.w400,
                                  txtfontsize: 7,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Insets.i20),
              // GestureDetector(
              //   onTap: mesageTap,
              //   child: SvgPicture.asset(
              //     // MyImageURL.message,
              //     MyImageURL.dummyfeedImage,
              //     height: Insets.i21,
              //     width: Insets.i21,
              //   ),
              // ),
              GestureDetector(
                onTap: mesageTap,
                child: Image.asset(
                  MyImageURL.dummyfeedImage,
                  height: Insets.i21,
                  width: Insets.i21,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
