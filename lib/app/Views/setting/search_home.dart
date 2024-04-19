import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/Views/user_profile/user_profile.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/main.dart';
import '../../utils/theme/colors.dart';
import '../../widgets/common_widget.dart';

class SearchHomeScreen extends StatefulWidget {
  const SearchHomeScreen({super.key});

  @override
  State<SearchHomeScreen> createState() => _SearchHomeScreenState();
}

class _SearchHomeScreenState extends State<SearchHomeScreen> {
  @override
  void initState() {
    super.initState();
    homeFeedController.page = 1;
    homeFeedController.searchNameController.clear();
    homeFeedController.searchUserDataList.clear();
  }

  HomeFeedController homeFeedController = Get.find<HomeFeedController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: appbarPreferredSize(
        "Settings",
        true,
      ),
      body: homeBody(),
    );
  }

/*  Headerbar */
  appbarPreferredSize(title, isBackArrow, {isRightIcon = false}) {
    return PreferredSize(
      preferredSize: Platform.isAndroid
          ? Size.fromHeight(Get.height * 0.12)
          : Size.fromHeight(Get.height * 0.08),
      child: Container(
        margin: const EdgeInsets.only(
            top: Insets.i30, left: Insets.i10, right: Insets.i20),
        child: AppBar(
            centerTitle: true,
            titleSpacing: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: MyColors.whiteColor,
            elevation: 0,
            title: Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isBackArrow
                      ? GestureDetector(
                          onTap: () {
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
                      child: TextField(
                    controller: homeFeedController.searchNameController,
                    autofocus: false,
                    style: TextStyle(
                        fontFamily: Fonts.poppins,
                        fontWeight: FontWeight.w400,
                        fontSize: FontSizes.s16,
                        color: MyColors.blackColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: MyColors.grayColor.withOpacity(0.10),
                      hintText: 'Username',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onChanged: (value) async {
                      homeFeedController.page = 1;
                      homeFeedController.searchUserDataList.clear();

                      await homeFeedController
                          .searchUsersName(value, true, false)
                          .whenComplete(() {
                        value == "" || value == null
                            ? homeFeedController.searchUserDataList.clear()
                            : null;
                        homeFeedController.searchUserDataList.refresh();
                      });
                    },
                  )),
                ],
              ),
            )),
      ),
    );
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        homeFeedController.page++;
        if (homeFeedController.currentPage.value <
            (homeFeedController.totalPage.value)) {
          homeFeedController.searchUsersName(
              homeFeedController.searchNameController.text, false, true);
        }
      }
    }
    return true;
  }

  homeBody() {
    return Container(
        margin: const EdgeInsets.only(
            top: Insets.i15, left: Insets.i25, right: Insets.i25),
        child: NotificationListener(
          onNotification: onNotification,
          child: Obx(
            () =>
                // homeFeedController.searchUserDataList.isEmpty ||
                //         homeFeedController.searchUserDataList == null
                //     ? MyNoRecord():
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    // physics: const BouncingScrollPhysics(),
                    //  controller: _scrollController,
                    itemCount: homeFeedController.searchUserDataList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => UserProfileScreenbackup(
                                fromProfile: homeFeedController
                                            .searchUserDataList[index]
                                            .username ==
                                        storage.read(MyStorage.userName)
                                    ? true
                                    : false,
                                userName: homeFeedController
                                    .searchUserDataList[index].username,
                              ));
                        },
                        child: Container(
                            padding: const EdgeInsets.only(bottom: Insets.i20),
                            color: MyColors.whiteColor,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomImageView(
                                        isProfilePicture: false,
                                        radius: 100,
                                        imagePathOrUrl:
                                            "$baseUrl${homeFeedController.searchUserDataList[index].userprofile?.profilePicture}"),
                                  )),
                                ),
                                const SizedBox(width: Insets.i10),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MyText(
                                        txtAlign: TextAlign.start,
                                        text_name: homeFeedController
                                                .searchUserDataList[index]
                                                .userprofile
                                                ?.displayName ??
                                            "N/A",
                                        fontWeight: FontWeight.w500,
                                        txtcolor: MyColors.blackColor,
                                        txtfontsize: FontSizes.s14,
                                      ),
                                      MyText(
                                        txtAlign: TextAlign.start,
                                        text_name:
                                            "@${homeFeedController.searchUserDataList[index].username}",
                                        fontWeight: FontWeight.w400,
                                        txtcolor: MyColors.grayColor,
                                        txtfontsize: FontSizes.s12,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      );
                    }),
          ),
        ));
  }
}
