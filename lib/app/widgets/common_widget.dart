import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/widget_extenstion.dart';
import '../utils/theme/images.dart';

class CommonWidget {}

/*Common screen Header*/
appbarPreferredSize(title, isBackArrow,
    {isRightIcon = false, isRightText, void Function()? backonTap}) {
  return PreferredSize(
    preferredSize: Platform.isAndroid
        ? Size.fromHeight(Get.height * 0.09)
        : Size.fromHeight(Get.height * 0.08),
    child: AppBar(
      scrolledUnderElevation: 0,
      centerTitle: isRightText == true ? false : true,
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: MyColors.whiteColor,
      elevation: 0,
      title: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
            top: Insets.i15, left: Insets.i10, right: Insets.i20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isBackArrow
                ? InkWell(
                    focusColor: MyColors.whiteColor,
                    hoverColor: MyColors.whiteColor,
                    onTap: backonTap ??
                        () {
                          Get.back();
                        },
                    child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          size: Insets.i23,
                        )),
                  )
                : const SizedBox(),
            Expanded(
              child: MyText(
                text_name: title,
                txtcolor: MyColors.blackColor,
                txtAlign:
                    isRightText == true ? TextAlign.left : TextAlign.center,
                fontWeight:
                    Platform.isAndroid ? FontWeight.w500 : FontWeight.w600,
                txtfontsize: FontSizes.s17,
              ),
            ),
            isRightIcon
                ? Row(
                    children: [
                      GestureDetector(
                        child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SvgPicture.asset(
                              MyImageURL.dotImage,
                              height: Insets.i20,
                              color: MyColors.blackColor,
                            )),
                      ),
                    ],
                  )
                : const SizedBox(width: 16),
          ],
        ),
      ),
    ),
  );
}

appbarPreferredSizeAction(
    title, isBackArrow, actionTitle, void Function() onTap,
    {isActionIcon = false, void Function()? backonTap}) {
  return PreferredSize(
    preferredSize: Platform.isAndroid
        ? Size.fromHeight(Get.height * 0.09)
        : Size.fromHeight(Get.height * 0.08),
    child: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.whiteColor,
        elevation: 0,
        title: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
              top: Insets.i15, left: Insets.i10, right: Insets.i20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isBackArrow
                  ? InkWell(
                      onTap: backonTap ??
                          () {
                            Get.back();
                          },
                      child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.arrow_back_ios_new_sharp,
                            size: Insets.i23,
                          )),
                    )
                  : const SizedBox(),
              Expanded(
                child: MyText(
                  text_name: title,
                  txtcolor: MyColors.blackColor,
                  txtAlign: TextAlign.center,
                  fontWeight:
                      Platform.isAndroid ? FontWeight.w500 : FontWeight.w600,
                  txtfontsize: FontSizes.s17,
                ),
              ),
            ],
          ),
        ),
        actions: isActionIcon
            ? [
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.black, size: 30),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: InkWell(
                        onTap: onTap,
                        child: MyText(
                          text_name: actionTitle,
                          txtcolor: MyColors.blackColor,
                          txtAlign: TextAlign.center,
                          fontWeight: Platform.isAndroid
                              ? FontWeight.w500
                              : FontWeight.w600,
                          txtfontsize: FontSizes.s17,
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            : []),
  );
}

/*Common screen Header*/
appbarPreferredSize1(title, isBackArrow, onTapp) {
  return PreferredSize(
    preferredSize: Platform.isAndroid
        ? Size.fromHeight(Get.height * 0.09)
        : Size.fromHeight(Get.height * 0.08),
    child: AppBar(
      scrolledUnderElevation: 0,
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: MyColors.whiteColor,
      elevation: 0,
      title: Container(
        //alignment: Alignment.center,
        margin: const EdgeInsets.only(
            top: Insets.i15, left: Insets.i10, right: Insets.i20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isBackArrow
                ? InkWell(
                    focusColor: MyColors.whiteColor,
                    hoverColor: MyColors.whiteColor,
                    onTap: onTapp,
                    child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          size: Insets.i23,
                        )),
                  )
                : const SizedBox(),
            Expanded(
              child: MyText(
                text_name: title,
                txtcolor: MyColors.blackColor,
                txtAlign: TextAlign.left,
                fontWeight:
                    Platform.isAndroid ? FontWeight.w500 : FontWeight.w600,
                txtfontsize: FontSizes.s17,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/*Data not available*/
Widget MyNoRecord() {
  return Container(
    child: Center(
      child: MyText(
        text_name: "Data Not Found!",
        txtcolor: MyColors.blackColor,
        txtAlign: TextAlign.center,
        fontWeight: Platform.isAndroid ? FontWeight.w500 : FontWeight.w600,
        txtfontsize: FontSizes.s20,
      ),
    ),
  );
}

Widget blankDottWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: Insets.i5),
    child: Container(
      height: 5,
      width: 5,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: MyColors.grayColor.withOpacity(.5)),
    ),
  );
}

Widget MyNoNotification() {
  return Container(
    child: Center(
      child: MyText(
        text_name: "No Notification",
        txtcolor: MyColors.blackColor,
        txtAlign: TextAlign.center,
        fontWeight: Platform.isAndroid ? FontWeight.w500 : FontWeight.w600,
        txtfontsize: FontSizes.s20,
      ),
    ),
  );
}

Widget MyNoPost() {
  return Container(
    child: Center(
      child: MyText(
        text_name: "No Posts",
        txtcolor: MyColors.blackColor,
        txtAlign: TextAlign.center,
        fontWeight: Platform.isAndroid ? FontWeight.w500 : FontWeight.w600,
        txtfontsize: FontSizes.s20,
      ),
    ),
  );
}

Widget PrivateAccount() {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.lock_outline_rounded,
        size: Insets.i30,
      ),
      Center(child: Text("This Account is Private")),
    ],
  );
}

Widget mediaLoader() {
  return SizedBox(
    height: Insets.i50,
    width: Insets.i50,
    child: Center(
      child: CircularProgressIndicator(
        strokeWidth: 1,
        color: MyColors.whiteColor,
      ),
    ),
  );
}

copyImagevideo(file, filename) async {
  final appDir = await getApplicationDocumentsDirectory();
  final savedImage = await file.copy('${appDir.path}/$filename');
  return savedImage;
}

Widget shimmerEffectGridview() {
  return GridView.builder(
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemCount: 30,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
    ),
    itemBuilder: (BuildContext context, int index) {
      return Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: MyColors.borderColor,
            border: Border.all(color: MyColors.whiteColor)),
        height: Get.width * 0.20,
      ).shimmer();
    },
  );
}

Widget shimeerEffectFeedListView() {
  return Expanded(
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: Get.height * 0.2,
          width: Get.width,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                  ).shimmer(),
                  Column(
                    children: [
                      Container(
                        height: 10,
                        width: 40,
                      ).shimmer(),
                      SizedBox(
                        height: Insets.i5,
                      ),
                      Container(
                        height: 10,
                        width: 30,
                      ).shimmer(),
                    ],
                  )
                ],
              ).shimmer(),
            ],
          ),
        );
      },
    ),
  );
}
