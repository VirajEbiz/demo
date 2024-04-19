import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/common_text.dart';
import '../Views/Home Feed/controllers/feed_home_controller.dart';
import '../Views/create_new_feed/create_feed_controller.dart';

class MainContentTypeButtonWidget extends StatelessWidget {
  MainContentTypeButtonWidget(
      {super.key,
      required this.buttonName,
      required this.iconName,
      required this.index,
      this.fromDraft,
      required this.fromHome,
      required this.isSelected});

  String? iconName;
  String? buttonName;
  bool? fromHome;
  bool? fromDraft;
  int index = 0;

  RxBool isSelected = false.obs;

  HomeFeedController homeFeedController = Get.put(HomeFeedController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: Get.height * 0.065,
        width: Get.width * 0.28,
        decoration: BoxDecoration(
          color: isSelected.value == true &&
                  index == homeFeedController.selectedIndex
              ? MyColors.greenColor
              : Colors.transparent,
          border: isSelected.value == true &&
                  index == homeFeedController.selectedIndex
              ? Border.all(color: Colors.transparent)
              : Border.all(color: MyColors.grayColor),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconName ?? "",
              color: isSelected.value == true &&
                      index == homeFeedController.selectedIndex
                  ? MyColors.whiteColor
                  : MyColors.grayColor,
              height: Insets.i20,
              width: Insets.i20,
            ),
            const SizedBox(
              width: Insets.i5,
            ),
            MyText(
              text_name: buttonName ?? "",
              txtcolor: isSelected.value == true &&
                      index == homeFeedController.selectedIndex
                  ? MyColors.whiteColor
                  : MyColors.grayColor,
              fontWeight: isSelected.value == true &&
                      index == homeFeedController.selectedIndex
                  ? FontWeight.w500
                  : FontWeight.w400,
              txtfontsize: FontSizes.s14,
            ),
          ],
        ),
      ),
    );
  }
}

class MainContentTypeButtonWidget2 extends StatelessWidget {
  MainContentTypeButtonWidget2(
      {super.key,
      required this.buttonName,
      required this.iconName,
      required this.index,
      this.fromDraft,
      required this.fromHome,
      required this.isSelected});

  String? iconName;
  String? buttonName;
  bool? fromHome;
  bool? fromDraft;
  int index = 0;

  RxBool isSelected = false.obs;

  CreateFeedController createFeedController = Get.put(CreateFeedController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: Get.height * 0.065,
        width: Get.width * 0.28,
        decoration: BoxDecoration(
          color: isSelected.value == true &&
                  index == createFeedController.selectedIndex
              ? MyColors.greenColor
              : Colors.transparent,
          border: isSelected.value == true &&
                  index == createFeedController.selectedIndex
              ? Border.all(color: Colors.transparent)
              : Border.all(color: MyColors.grayColor),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconName ?? "",
              color: isSelected.value == true &&
                      index == createFeedController.selectedIndex
                  ? MyColors.whiteColor
                  : MyColors.grayColor,
              height: Insets.i20,
              width: Insets.i20,
            ),
            const SizedBox(
              width: Insets.i5,
            ),
            MyText(
              text_name: buttonName ?? "",
              txtcolor: isSelected.value == true &&
                      index == createFeedController.selectedIndex
                  ? MyColors.whiteColor
                  : MyColors.grayColor,
              fontWeight: isSelected.value == true &&
                      index == createFeedController.selectedIndex
                  ? FontWeight.w500
                  : FontWeight.w400,
              txtfontsize: FontSizes.s14,
            ),
          ],
        ),
      ),
    );
  }
}
