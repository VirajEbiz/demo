import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/bookmark/bookmark_controller.dart';
import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
import 'package:watermel/app/Views/user_profile/widget/image_view.dart';
import 'package:watermel/app/Views/user_profile/widget/podcast_view.dart';
import 'package:watermel/app/Views/user_profile/widget/watch_view.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_methods.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';
import 'package:watermel/app/widgets/widget_extenstion.dart';
import 'package:watermel/main.dart';

class BookmarkListView extends StatefulWidget {
  const BookmarkListView({super.key});

  @override
  State<BookmarkListView> createState() => _BookmarkListViewState();
}

class _BookmarkListViewState extends State<BookmarkListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  BookmarkController bookmarkController = Get.put(BookmarkController());
  UserProfileController userProfileController =
      Get.put(UserProfileController());
  RxInt tabIndex = 0.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    bookmarkController.getBookmarkListAPI(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarPreferredSize(
        "Bookmarks",
        true,
        isRightIcon: false,
        isRightText: false,
        backonTap: () {
          Get.back();
        },
      ),
      body: NotificationListener(
        onNotification: onNotificationHr,
        child: ListView(
          children: [
            Column(children: [
              TabBar(
                  onTap: (value) async {
                    if (value == 0) {
                      bookmarkController.page = 1;
                      bookmarkController.bookmarkList.clear();
                      await bookmarkController.getBookmarkListAPI(0);
                      tabIndex.value = 0;
                    } else if (value == 1) {
                      bookmarkController.bookmarkList.clear();
                      bookmarkController.page = 1;
                      await bookmarkController.getBookmarkListAPI(1);
                      tabIndex.value = 1;
                    } else {
                      bookmarkController.bookmarkList.clear();
                      bookmarkController.page = 1;
                      await bookmarkController.getBookmarkListAPI(3);
                      tabIndex.value = 2;
                    }
                    setState(() {});
                  },
                  tabs: <Tab>[
                    Tab(
                        child: SvgPicture.asset(
                      MyImageURL.FrameImage,
                      height: Insets.i28,
                      color: MyColors.blackColor,
                    )),
                    Tab(
                        child: SvgPicture.asset(
                      MyImageURL.videoplay,
                      height: Insets.i30,
                      color: MyColors.grayColor,
                    )),
                    Tab(
                        child: SvgPicture.asset(
                      MyImageURL.readseedImage,
                      height: Insets.i28,
                      color: MyColors.grayColor,
                    )),
                  ],
                  indicatorColor: MyColors.blackColor,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab),
              Divider(
                height: 2,
                color: MyColors.lightGray,
              ),
              const SizedBox(height: Insets.i10),
              IndexedStack(
                index: tabIndex.value,
                children: <Widget>[
                  Obx(
                    () => Visibility(
                      maintainState: true,
                      visible: tabIndex.value == 0,
                      child: bookmarkController.isLoadingBookMark.value == true
                          ? shimmerEffectGridview()
                          : bookmarkImageView(),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                        maintainState: true,
                        visible: tabIndex.value == 1,
                        child:
                            bookmarkController.isLoadingBookMark.value == true
                                ? shimmerEffectGridview()
                                : bookmarkWatchView()),
                  ),
                  Obx(
                    () => Visibility(
                        maintainState: true,
                        visible: tabIndex.value == 2,
                        child: bookmarkController.isLoadingBookMark.value
                            ? shimmerEffectGridview()
                            : bookmarkPodcastView()),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  bool onNotificationHr(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        bookmarkController.page++;

        if (bookmarkController.current_page < (bookmarkController.total_page)) {
          bookmarkController.getBookmarkListAPI(tabIndex.value);
        } else {}
      }
    }
    return true;
  }

  bookmarkImageView() {
    return Obx(
      () => bookmarkController.bookmarkList.isEmpty &&
              bookmarkController.isLoadingBookMark.value == false
          ? Column(
              children: [
                SizedBox(
                  height: Get.height * 0.3,
                ),
                MyNoPost(),
                SizedBox(
                  height: Get.height * 0.3,
                )
              ],
            )
          : GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: bookmarkController.bookmarkList.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    await bookmarkController.getUserPotDetailsAPI(
                        bookmarkController.bookmarkList[index].seedId,
                        0,
                        index);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: MyColors.borderColor,
                          border: Border.all(color: MyColors.whiteColor)),
                      height: Get.width * 0.20,
                      child: CustomImageView(
                          isProfilePicture: false,
                          imagePathOrUrl: bookmarkController
                                  .bookmarkList[index].seedMediaData!.isEmpty
                              ? ""
                              : bookmarkController.bookmarkList[index]
                                              .seedMediaData!.first.image ==
                                          null ||
                                      bookmarkController.bookmarkList[index]
                                              .seedMediaData!.first.image ==
                                          ""
                                  ? ""
                                  : "$baseUrl${bookmarkController.bookmarkList[index].seedMediaData!.first.image}")),
                );
              },
            ),
    );
  }

  bookmarkWatchView() {
    return Obx(
      () => bookmarkController.bookmarkList.isEmpty &&
              bookmarkController.isLoadingBookMark.value == false
          ? Column(
              children: [
                SizedBox(
                  height: Get.height * 0.3,
                ),
                MyNoPost(),
                SizedBox(
                  height: Get.height * 0.3,
                )
              ],
            )
          : GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: bookmarkController.bookmarkList.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    await bookmarkController.getUserPotDetailsAPI(
                        bookmarkController.bookmarkList[index].seedId,
                        1,
                        index);
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
                                imagePathOrUrl: bookmarkController
                                                .bookmarkList[index]
                                                .seedThumbnailUrl ==
                                            "" ||
                                        bookmarkController.bookmarkList[index]
                                                .seedThumbnailUrl ==
                                            null
                                    ? ""
                                    : "$baseForImage${bookmarkController.bookmarkList[index].seedThumbnailUrl}")),
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
              },
            ),
    );
  }

  bookmarkPodcastView() {
    return Obx(
      () => bookmarkController.bookmarkList.isEmpty &&
              bookmarkController.isLoadingBookMark.value == false
          ? Column(
              children: [
                SizedBox(
                  height: Get.height * 0.3,
                ),
                MyNoPost(),
                SizedBox(
                  height: Get.height * 0.3,
                )
              ],
            )
          : GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: bookmarkController.bookmarkList.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    bookmarkController.bookmarkList[index].seedMediaData!.first
                                    .audio ==
                                null ||
                            bookmarkController.bookmarkList[index]
                                    .seedMediaData!.first.audio ==
                                ""
                        ? bookmarkController.getUserPotDetailsAPI(
                            bookmarkController.bookmarkList[index].seedId,
                            1,
                            index)
                        : bookmarkController.getUserPotDetailsAPI(
                            bookmarkController.bookmarkList[index].seedId,
                            2,
                            index);
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
                                imagePathOrUrl: bookmarkController
                                                .bookmarkList[index]
                                                .seedThumbnailUrl ==
                                            "" ||
                                        bookmarkController.bookmarkList[index]
                                                .seedThumbnailUrl ==
                                            null
                                    ? ""
                                    : "$baseForImage${bookmarkController.bookmarkList[index].seedThumbnailUrl}")),
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
              },
            ),
    );
  }
}
