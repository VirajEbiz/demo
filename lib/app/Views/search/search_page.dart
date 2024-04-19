import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/home_bottom_bar/homebottom_controller.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  HomeFeedController homeFeedController = Get.find<HomeFeedController>();

  String hashtag = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    homeFeedController.page = 1;
    homeFeedController.searchNameController.clear();
    homeFeedController.searchUserDataList.clear();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      print("inside the data ++> ");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Search',
          style: TextStyle(
            color: MyColors.blackColor,
            fontSize: FontSizes.s16,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Profiles'),
            Tab(text: 'Hashtags'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Profile Search Tab
          Column(
            children: [
              searchProfileBar("", false),
              profilesSearchBody(),
            ],
          ),
          // Hashtag Search Tab
          Column(
            children: [
              searchHashtagBar("", false),
              hashtagsSearchBody(),
            ],
          ),
        ],
      ),
    );
  }

  searchProfileBar(title, isBackArrow, {isRightIcon = false}) {
    return PreferredSize(
      preferredSize: Platform.isAndroid
          ? Size.fromHeight(Get.height * 0.12)
          : Size.fromHeight(Get.height * 0.08),
      child: Container(
          margin: const EdgeInsets.only(
              top: Insets.i30, left: Insets.i10, right: Insets.i20),
          child: Container(
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
                    hintText: 'Username or Display Name',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                      value == ""
                          ? homeFeedController.searchUserDataList.clear()
                          : null;
                      homeFeedController.searchUserDataList.refresh();
                    });
                  },
                )),
              ],
            ),
          )),
    );
  }

  searchHashtagBar(title, isBackArrow, {isRightIcon = false}) {
    return PreferredSize(
      preferredSize: Platform.isAndroid
          ? Size.fromHeight(Get.height * 0.12)
          : Size.fromHeight(Get.height * 0.08),
      child: Container(
          margin: const EdgeInsets.only(
              top: Insets.i30, left: Insets.i10, right: Insets.i20),
          child: Container(
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
                  autofocus: false,
                  style: TextStyle(
                      fontFamily: Fonts.poppins,
                      fontWeight: FontWeight.w400,
                      fontSize: FontSizes.s16,
                      color: MyColors.blackColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.grayColor.withOpacity(0.10),
                    hintText: "Hashtag",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                    hashtag = value.startsWith("#")
                        ? value.removeAllWhitespace
                        : "#${value.removeAllWhitespace}";
                    await homeFeedController.getSuggestedHashtags(hashtag);
                    setState(() {});
                  },
                )),
              ],
            ),
          )),
    );
  }

  profilesSearchBody() {
    return Expanded(
      child: Container(
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
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomImageView(
                                      radius: 100,
                                      imagePathOrUrl:
                                          "$baseForImage${homeFeedController.searchUserDataList[index].userprofile?.profilePicture}",
                                      isProfilePicture: true,
                                    ),
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
        ),
      ),
    );
  }

  hashtagsSearchBody() {
    return hashtag == "" || hashtag == "#"
        ? const SizedBox()
        : Expanded(
            child: Container(
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
                          itemCount:
                              homeFeedController.suggestedHashtagsList.length +
                                  1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    bottom: Insets.i20, top: Insets.i20),
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
                                          color: MyColors.greenColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: MyText(
                                            txtAlign: TextAlign.center,
                                            text_name: "#",
                                            fontWeight: FontWeight.w500,
                                            txtcolor: MyColors.whiteColor,
                                            txtfontsize: FontSizes.s20,
                                          ),
                                        ),
                                      )),
                                    ),
                                    const SizedBox(width: Insets.i10),
                                    Expanded(
                                      flex: 8,
                                      child: MyText(
                                        txtAlign: TextAlign.start,
                                        text_name: hashtag.startsWith('#')
                                            ? hashtag
                                            : hashtag.replaceAll('#', ''),
                                        fontWeight: FontWeight.w500,
                                        txtcolor: MyColors.blackColor,
                                        txtfontsize: FontSizes.s14,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                homeFeedController.selectedTopic.value =
                                    homeFeedController
                                        .suggestedHashtagsList[index - 1].name
                                        .replaceAll('#', '');
                                homeFeedController.getSeedsByTopic(true);
                                HomeController homeController =
                                    Get.put(HomeController());
                                homeController.pageIndex.value = 0;
                                Get.back();
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.only(bottom: Insets.i20),
                                  color: MyColors.whiteColor,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: MyColors.greenColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: MyText(
                                              txtAlign: TextAlign.center,
                                              text_name: "#",
                                              fontWeight: FontWeight.w500,
                                              txtcolor: MyColors.whiteColor,
                                              txtfontsize: FontSizes.s20,
                                            ),
                                          ),
                                        )),
                                      ),
                                      const SizedBox(width: Insets.i10),
                                      Expanded(
                                        flex: 8,
                                        child: MyText(
                                          txtAlign: TextAlign.start,
                                          text_name: homeFeedController
                                              .suggestedHashtagsList[index - 1]
                                              .name,
                                          fontWeight: FontWeight.w500,
                                          txtcolor: MyColors.blackColor,
                                          txtfontsize: FontSizes.s14,
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          }),
                ),
              ),
            ),
          );
  }
}
