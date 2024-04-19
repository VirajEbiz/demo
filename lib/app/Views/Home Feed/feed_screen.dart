import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/feed_detail_screen.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/scroll_controller.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/autoplayFeed_widget.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/widgets/content_button_widget.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/divider_widget.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/feed_appbar.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/readFeed_widget.dart';
import 'package:watermel/app/Views/setting/search_home.dart';
import 'package:watermel/app/Views/user_profile/widget/coming_soon.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_methods.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';
import '../Notification_Follow/notificationList.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with WidgetsBindingObserver {
  HomeFeedController homeFeedController = Get.put(HomeFeedController());
  final HomeScrollController _scrollController =
      Get.put(HomeScrollController());
  final Rx<int> _focusedIndex = Rx<int>(-1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeFeedController.selectedIndex = 0;
      homeFeedController.isSelected.value = true;
      homeFeedController.isSelectedtype.value = "Read";
      // Future.delayed(const Duration(milliseconds: 10));
      setState(() {});
      getData();
    });
  }

  Future getData() async {
    homeFeedController.page = 1;
    homeFeedController.peopleYouKnowDataPage = 1;
    homeFeedController.homeFeedList.clear();
    homeFeedController.homeFeedList.refresh();
    homeFeedController.peopleYouKnow(true);
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        homeFeedController.page++;
        homeFeedController.peopleYouKnowDataPage++;
        // if (homeFeedController.peopleCurrentPage.value <
        //     (homeFeedController.peopleTotalPage.value)) {
        //   homeFeedController.peopleYouKnow(false);
        // }
        if (homeFeedController.currentPage.value <
            (homeFeedController.totalPage.value)) {
          homeFeedController.getAllFeedData(false, true);
          // homeFeedController.page == homeFeedController.totalPage.value
          //     ? homeFeedController.noMoreFeeds.value = "No New Post!"
          //     : null;
        } else {
          homeFeedController.noMoreFeeds.value = "No New Post!";
        }
      }
    }
    return true;
  }

  bool onNotificationHr(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        homeFeedController.peopleYouKnowDataPage++;
        if (homeFeedController.peopleCurrentPage.value <
            (homeFeedController.peopleTotalPage.value)) {
          homeFeedController.peopleYouKnow(false);
        } else {}
      }
    }
    return true;
  }

  // int i = 0;
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     await ApiManager().setRefreshTokenAPI(fromMain: false);

  //     // await homeFeedController.getNotificationCountAPI(2);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NotificationListener(
        onNotification: onNotification,
        child: CustomScrollView(
          controller: _scrollController.scrollController,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true, // Add this line
          slivers: [
            /**
             * App bar
             */
            SliverAppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor: MyColors.whiteColor,
              expandedHeight: Get.height * 0.2,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                /**
                 * Main App Bar
                 */
                background: Column(
                  children: [
                    FeedAppBarWidget(
                      notificationTap: () async {
                        Get.to(() => NotificationListScreen(
                              fromMain: false,
                            ));
                      },
                      mesageTap: () {
                        // ApiManager().setRefreshTokenAPI();
                        Get.to(() => ComingSoonWidget(
                              fromHome: false,
                            ));
                      },
                      searchTap: () {
                        homeFeedController.isSearch.value = true;
                        Get.to(() => const SearchHomeScreen());
                      },
                    ),
                    MyCustomDivider(
                      sized: Insets.i5,
                    ),
                    /**
                     * Main Content Type Button
                     */
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Insets.i20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          homeFeedController.buttonList.length,
                          (index) => InkWell(
                            onTap: () async {
                              homeFeedController.homeFeedList.clear();
                              if (homeFeedController.selectedIndex != index) {
                                homeFeedController.selectedIndex = index;
                                if (homeFeedController.buttonList[index]
                                        ["IsSelected"] ==
                                    homeFeedController.selectedIndex) {
                                  homeFeedController.isSelected.value = true;
                                }
                                await getData();
                                setState(() {});
                              } else {
                                Get.find<HomeScrollController>().scrollToTop();
                              }
                            },
                            child: Padding(
                              padding: index == 1
                                  ? const EdgeInsets.symmetric(
                                      horizontal: Insets.i7)
                                  : const EdgeInsets.all(0),
                              child: MainContentTypeButtonWidget(
                                fromHome: true,
                                index: index,
                                buttonName: homeFeedController.buttonList[index]
                                    ["ButtonName"],
                                isSelected: homeFeedController.isSelected,
                                iconName: homeFeedController.buttonList[index]
                                    ["ButtonIcon"],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    MyCustomDivider2(
                      sized: Insets.i7,
                    ),
                  ],
                ),
              ),
            ),
            /**
             * Refresh Indicator
             */
            CupertinoSliverRefreshControl(
              onRefresh: () {
                homeFeedController.homeFeedList.clear();
                homeFeedController.homeFeedList.refresh();
                return getData();
              },
            ),
            /**
             * Main Content
             */
            SliverList(
              delegate: SliverChildListDelegate([
                Obx(() => homeFeedController.selectedIndex == 2
                    ? podcastView()
                    : feedistWidget())
              ]),
            ),
          ],
        ),
      ),
    );
  }

  feedistWidget() {
    if ((homeFeedController.homeFeedList.isEmpty ||
        homeFeedController.homeFeedList == null)) {
      return CommonMethod().venueListEffect(5);
    }
    return Obx(
      () => NotificationListener(
        onNotification: onNotificationHr,
        child: homeFeedController.homeFeedList.isEmpty ||
                homeFeedController.homeFeedList == null
            ? homeFeedController.homeFeedList.isEmpty ||
                    homeFeedController.homeFeedList == null
                ? const SizedBox()
                : SizedBox(height: Get.height * 0.5, child: MyNoRecord())
            : Column(
                children: [
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return index == 0 &&
                              homeFeedController
                                  .peopleYouKnowDataList.isNotEmpty
                          ? Container(
                              height: Get.height * 0.35,
                              width: Get.width,
                              color: MyColors.backGroudGray,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: Insets.i20,
                                        top: Insets.i5,
                                        bottom: Insets.i5),
                                    child: Text(
                                      "People you may know",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: FontSizes.s14),
                                    ),
                                  ),
                                  Expanded(
                                    child: Obx(
                                      () => homeFeedController
                                              .peopleYouKnowDataList.isEmpty
                                          ? SizedBox(
                                              height: Get.height * 0.5,
                                              child:
                                                  Center(child: MyNoRecord()))
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      left: index == 0
                                                          ? Insets.i20
                                                          : Insets.i5),
                                                  height: Get.height * 0.18,
                                                  width: Get.width * 0.4,
                                                  color: MyColors.whiteColor,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const SizedBox(
                                                        height: Insets.i10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              UserProfileScreenbackup(
                                                                peopelMayYouKnowIndex:
                                                                    index,
                                                                fromProfile:
                                                                    false,
                                                                userName: homeFeedController
                                                                    .peopleYouKnowDataList[
                                                                        index]
                                                                    .username,
                                                              ));
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height:
                                                                  Insets.i100,
                                                              width:
                                                                  Insets.i100,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle),
                                                              child: CustomImageView(
                                                                  isProfilePicture:
                                                                      true,
                                                                  radius: 200,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imagePathOrUrl: homeFeedController
                                                                              .peopleYouKnowDataList[index]
                                                                              .userprofile
                                                                              ?.profilePicture ==
                                                                          null
                                                                      ? ""
                                                                      : '${homeFeedController.peopleYouKnowDataList[index].userprofile?.profilePicture}'),
                                                            ),
                                                            const SizedBox(
                                                              height: Insets.i5,
                                                            ),
                                                            MyText(
                                                              text_name: homeFeedController
                                                                      .peopleYouKnowDataList[
                                                                          index]
                                                                      .userprofile
                                                                      ?.displayName ??
                                                                  "",
                                                              txtcolor: MyColors
                                                                  .blackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              txtfontsize:
                                                                  FontSizes.s12,
                                                            ),
                                                            MyText(
                                                              text_name: homeFeedController
                                                                      .peopleYouKnowDataList[
                                                                          index]
                                                                      .userprofile
                                                                      ?.displayName ??
                                                                  "",
                                                              txtcolor: MyColors
                                                                  .grayColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              txtfontsize:
                                                                  FontSizes.s11,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          homeFeedController
                                                              .FollowTheUsesr(
                                                                  homeFeedController
                                                                      .peopleYouKnowDataList[
                                                                          index]
                                                                      .username,
                                                                  index: index);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(
                                                                  Insets.i10),
                                                          width: Get.width,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color: MyColors
                                                                  .greenColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        Insets
                                                                            .i10),
                                                            child: MyText(
                                                              text_name: homeFeedController
                                                                          .peopleYouKnowDataList[
                                                                              index]
                                                                          .isFollowing ==
                                                                      true
                                                                  ? "Follow Back"
                                                                  : "Follow",
                                                              txtcolor: MyColors
                                                                  .whiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              txtfontsize:
                                                                  FontSizes.s12,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              itemCount: homeFeedController
                                                  .peopleYouKnowDataList.length,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Insets.i10,
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(bottom: Insets.i10),
                              child: Divider(
                                indent: 0,
                                height: 0,
                                color: MyColors.grayColor.withOpacity(.5),
                              ),
                            );
                    },
                    shrinkWrap: true,
                    controller: _scrollController.scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeFeedController.homeFeedList.length,
                    itemBuilder: (context, index) {
                      return VisibilityDetector(
                        key: Key(index.toString()),
                        onVisibilityChanged: (visibilityInfo) {
                          if (visibilityInfo.visibleFraction ==
                                  1 // Fully visible
                              ) {
                            if (homeFeedController.selectedIndex == 0 &&
                                homeFeedController.homeFeedList[index].id !=
                                    null) {
                              homeFeedController.viewedPost(
                                  homeFeedController.homeFeedList[index].id!);
                            } else if (homeFeedController.selectedIndex == 1) {
                              _focusedIndex.value = index;
                              setState(() {});
                            }
                          }
                        },
                        child: _focusedIndex.value == index &&
                                homeFeedController.selectedIndex == 1
                            ? AutoplayFeedWidget(
                                index: index,
                                displayName: homeFeedController
                                        .homeFeedList[index]
                                        .user
                                        ?.userprofile
                                        ?.displayName ??
                                    "",
                                feedID: homeFeedController
                                    .homeFeedList[index].id
                                    .toString(),
                                myStartTime: homeFeedController
                                    .homeFeedList[index].createdAt,
                                reactionCount: homeFeedController
                                        .homeFeedList[index].reactionsCount ??
                                    0,
                                commentCount: homeFeedController
                                        .homeFeedList[index].commentsCount ??
                                    0,
                                description: homeFeedController
                                    .homeFeedList[index].caption,
                                userName: homeFeedController
                                        .homeFeedList[index].user?.username ??
                                    "",
                                mainImageURL: homeFeedController
                                                .selectedIndex ==
                                            1 ||
                                        homeFeedController.selectedIndex == 2
                                    ? "$baseUrl${homeFeedController.homeFeedList[index].thumbnailURL}"
                                    : homeFeedController.homeFeedList[index]
                                                    .mediaData ==
                                                null ||
                                            homeFeedController
                                                .homeFeedList[index]
                                                .mediaData!
                                                .isEmpty
                                        ? ""
                                        : "$baseUrl${homeFeedController.homeFeedList[index].mediaData?[0].image ?? ""}",
                                userProfile: homeFeedController
                                                .homeFeedList[index]
                                                .user
                                                ?.userprofile!
                                                .profilePicture ==
                                            null ||
                                        homeFeedController
                                                .homeFeedList[index]
                                                .user
                                                ?.userprofile!
                                                .profilePicture ==
                                            ""
                                    ? ""
                                    : "$baseUrl${homeFeedController.homeFeedList[index].user?.userprofile!.profilePicture}",
                              )
                            : ReadFeedWidget(
                                shareURL: homeFeedController
                                    .homeFeedList[index].shareURL,
                                index: index,
                                displayName: homeFeedController
                                        .homeFeedList[index]
                                        .user
                                        ?.userprofile
                                        ?.displayName ??
                                    "",
                                feedID: homeFeedController
                                    .homeFeedList[index].id
                                    .toString(),
                                myStartTime: homeFeedController
                                    .homeFeedList[index].createdAt,
                                reactionCount: homeFeedController
                                        .homeFeedList[index].reactionsCount ??
                                    0,
                                commentCount: homeFeedController
                                        .homeFeedList[index].commentsCount ??
                                    0,
                                description: homeFeedController
                                    .homeFeedList[index].caption,
                                mainImageUrl: homeFeedController
                                                .selectedIndex ==
                                            1 ||
                                        homeFeedController.selectedIndex == 2
                                    ? "$baseUrl${homeFeedController.homeFeedList[index].thumbnailURL}"
                                    : homeFeedController.homeFeedList[index]
                                                    .mediaData ==
                                                null ||
                                            homeFeedController
                                                .homeFeedList[index]
                                                .mediaData!
                                                .isEmpty
                                        ? ""
                                        : "$baseUrl${homeFeedController.homeFeedList[index].mediaData?[0].image ?? ""}",
                                userName: homeFeedController
                                        .homeFeedList[index].user?.username ??
                                    "",
                                userProfile:
                                    "${homeFeedController.homeFeedList[index].user?.userprofile!.profilePicture}",
                              ),
                      );
                    },
                  ),
                  Obx(
                    () => homeFeedController.noMoreFeeds.value == ""
                        ? const CircularProgressIndicator(
                            strokeWidth: 1,
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => homeFeedController.noMoreFeeds.value != ""
                        ? Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: MyColors.greenColor,
                              ),
                              MyText(
                                txtAlign: TextAlign.start,
                                text_name: homeFeedController.noMoreFeeds.value,
                                fontWeight: FontWeight.w600,
                                txtcolor: MyColors.blackColor,
                                txtfontsize: FontSizes.s12,
                                maxline: 2,
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(
                    height: Insets.i30,
                  )
                ],
              ),
      ),
    );
  }

  void scrollToTop() {
    _scrollController.scrollController.animateTo(
      0.0, // Scroll to the top
      duration:
          const Duration(milliseconds: 500), // You can adjust the duration
      curve: Curves.easeInOut,
    );
  }

  podcastView() {
    if ((homeFeedController.homeFeedList.isEmpty ||
        homeFeedController.homeFeedList == null)) {
      return CommonMethod().venueListEffect(5);
    }
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Insets.i25, vertical: Insets.i10),
        child: homeFeedController.homeFeedList.isEmpty
            ? Container(
                height: Get.height * 0.4,
                child: MyNoRecord(),
              )
            : Column(
                children: [
                  GridView.builder(
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: homeFeedController.homeFeedList.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 30,
                          mainAxisExtent: Get.height * 0.27),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            homeFeedController.viewedPost(
                                homeFeedController.homeFeedList[index].id!);

                            Get.to(() => homeFeedController.tempList.any(
                                    (element) =>
                                        element ==
                                        homeFeedController.homeFeedList[index]
                                            .mediaData!.first.video
                                            ?.split('.')
                                            .last)
                                ? FeedDetailScreen(
                                    myReaction: homeFeedController
                                        .homeFeedList[index].myReaction,
                                    createTime: homeFeedController
                                        .homeFeedList[index].createdAt,
                                    shareURL: homeFeedController
                                        .homeFeedList[index].shareURL,
                                    feedID: homeFeedController
                                        .homeFeedList[index].id,
                                    commentCount: homeFeedController
                                        .homeFeedList[index].commentsCount,
                                    isBookmark: homeFeedController
                                        .homeFeedList[index].bookmark,
                                    likeCount: homeFeedController
                                        .homeFeedList[index].reactionsCount,
                                    thumbnail: homeFeedController
                                                .homeFeedList[index]
                                                .thumbnailURL ==
                                            null
                                        ? ""
                                        : "$baseUrl${homeFeedController.homeFeedList[index].thumbnailURL}",
                                    caption: homeFeedController
                                        .homeFeedList[index].caption,
                                    mediaURL:
                                        "$baseUrl${homeFeedController.homeFeedList[index].mediaData!.first.video}",
                                    mediaType: 1,
                                    index: index,
                                    userName: homeFeedController
                                        .homeFeedList[index].user!.username,
                                    displayname: homeFeedController
                                        .homeFeedList[index]
                                        .user!
                                        .userprofile!
                                        .displayName,
                                    userProfile: homeFeedController
                                                    .homeFeedList[index]
                                                    .user!
                                                    .userprofile!
                                                    .profilePicture ==
                                                null ||
                                            homeFeedController
                                                    .homeFeedList[index]
                                                    .user!
                                                    .userprofile!
                                                    .profilePicture ==
                                                ""
                                        ? ""
                                        : "$baseUrl${homeFeedController.homeFeedList[index].user!.userprofile!.profilePicture}",
                                  )
                                : FeedDetailScreen(
                                    myReaction: homeFeedController
                                        .homeFeedList[index].myReaction,
                                    createTime: homeFeedController
                                        .homeFeedList[index].createdAt,
                                    shareURL: homeFeedController
                                        .homeFeedList[index].shareURL,
                                    feedID: homeFeedController
                                        .homeFeedList[index].id,
                                    commentCount: homeFeedController
                                        .homeFeedList[index].commentsCount,
                                    isBookmark: homeFeedController
                                        .homeFeedList[index].bookmark,
                                    likeCount: homeFeedController
                                        .homeFeedList[index].reactionsCount,
                                    thumbnail: homeFeedController
                                                .homeFeedList[index]
                                                .thumbnailURL ==
                                            null
                                        ? ""
                                        : "$baseUrl${homeFeedController.homeFeedList[index].thumbnailURL}",
                                    caption: homeFeedController
                                        .homeFeedList[index].caption,
                                    mediaURL:
                                        "$baseUrl${homeFeedController.homeFeedList[index].mediaData!.first.audio}",
                                    mediaType: 2,
                                    index: index,
                                    userName: homeFeedController
                                        .homeFeedList[index].user!.username,
                                    displayname: homeFeedController
                                        .homeFeedList[index]
                                        .user!
                                        .userprofile!
                                        .displayName,
                                    userProfile:
                                        "$baseUrl${homeFeedController.homeFeedList[index].user!.userprofile!.profilePicture}",
                                  ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                // color: MyColors.borderColor,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: homeFeedController.tempList.any(
                                          (element) =>
                                              element ==
                                              homeFeedController
                                                  .homeFeedList[index]
                                                  .mediaData
                                                  ?.first
                                                  .video
                                                  ?.split('.')
                                                  .last)
                                      ? homeFeedController.homeFeedList[index]
                                                  .thumbnailURL ==
                                              null
                                          ? Image.asset(
                                              MyImageURL.dummyfeedImage,
                                              fit: BoxFit.cover,
                                              height: Get.height * 0.18,
                                            )
                                          : SizedBox(
                                              width: Get.width,
                                              height: Get.height * 0.18,
                                              child: CustomImageView(
                                                isProfilePicture: false,
                                                imagePathOrUrl:
                                                    "$baseUrl${homeFeedController.homeFeedList[index].thumbnailURL}",
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                      : homeFeedController.homeFeedList[index]
                                                  .thumbnailURL ==
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
                                                imagePathOrUrl:
                                                    "$baseUrl${homeFeedController.homeFeedList[index].thumbnailURL}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                ),
                              ),
                              const SizedBox(height: Insets.i10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: MyText(
                                      txtAlign: TextAlign.start,
                                      text_name: homeFeedController
                                          .homeFeedList[index].caption,
                                      fontWeight: FontWeight.w600,
                                      txtcolor: MyColors.blackColor,
                                      txtfontsize: FontSizes.s10,
                                      maxline: 2,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: SvgPicture.asset(
                                            MyImageURL.playvideo,
                                            height: Insets.i25,
                                          ))),
                                ],
                              ),
                              const SizedBox(height: Insets.i3),
                              Flexible(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  homeFeedController
                                              .homeFeedList[index].owner ==
                                          null
                                      ? const SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(
                                              txtAlign: TextAlign.start,
                                              text_name: homeFeedController
                                                      .homeFeedList[index]
                                                      .captionHistory
                                                      ?.first
                                                      .userName ??
                                                  "",
                                              fontWeight: FontWeight.w500,
                                              txtcolor: MyColors.grayColor,
                                              txtfontsize: FontSizes.s10,
                                            ),
                                            const SizedBox(
                                              width: Insets.i2,
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  MyImageURL.repostIcon,
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                const SizedBox(
                                                  width: Insets.i2,
                                                ),
                                                MyText(
                                                  text_name: "Reposted",
                                                  fontWeight: FontWeight.w500,
                                                  txtcolor: MyColors.grayColor,
                                                  txtfontsize: FontSizes.s10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  MyText(
                                    txtAlign: TextAlign.start,
                                    text_name: homeFeedController
                                            .homeFeedList[index]
                                            .user
                                            ?.userprofile
                                            ?.displayName ??
                                        "",
                                    fontWeight: FontWeight.w500,
                                    txtcolor: MyColors.grayColor,
                                    txtfontsize: FontSizes.s10,
                                  ),
                                ],
                              )),
                            ],
                          ),
                        );
                      }),
                  Obx(
                    () => homeFeedController.noMoreFeeds.value == ""
                        ? const CircularProgressIndicator(
                            strokeWidth: 1,
                          )
                        : const SizedBox(),
                  ),
                  Obx(
                    () => homeFeedController.noMoreFeeds.value != ""
                        ? Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: MyColors.greenColor,
                              ),
                              MyText(
                                txtAlign: TextAlign.start,
                                text_name: homeFeedController.noMoreFeeds.value,
                                fontWeight: FontWeight.w600,
                                txtcolor: MyColors.blackColor,
                                txtfontsize: FontSizes.s12,
                                maxline: 2,
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(
                    height: Insets.i30,
                  )
                ],
              ),
      ),
    );
  }
}
