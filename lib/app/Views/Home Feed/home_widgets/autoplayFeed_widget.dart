/// FILEPATH: /Users/feder/Development/watermel-flutter/lib/app/Views/Home Feed/home_widgets/autoplayFeed_widget.dart
///
/// This file contains the implementation of the `AutoplayFeedWidget` class, which is a stateful widget used to display an autoplay feed item in the home feed.
///
/// The `AutoplayFeedWidget` class extends the `StatefulWidget` class and overrides the `createState` method to create an instance of the `_AutoplayFeedWidgetState` class.
///
/// The `_AutoplayFeedWidgetState` class is the state class for the `AutoplayFeedWidget` widget. It extends the `State` class and contains the logic and state management for the widget.
///
/// The `AutoplayFeedWidget` class has the following properties:
/// - `userProfile`: A string representing the user profile image URL.
/// - `feedID`: A string representing the feed ID.
/// - `index`: An integer representing the index of the feed item.
/// - `myStartTime`: A `DateTime` object representing the start time of the feed item.
/// - `reactionCount`: An integer representing the count of reactions on the feed item.
/// - `commentCount`: An integer representing the count of comments on the feed item.
/// - `displayName`: A string representing the display name of the user.
/// - `userName`: A string representing the username of the user.
/// - `description`: A string representing the description of the feed item.
///
/// The `AutoplayFeedWidget` widget initializes a `VideoPlayerController` and sets up the video player to play the video associated with the feed item.
///
/// The `AutoplayFeedWidget` widget also includes UI elements such as user profile image, display name, timestamp, description, and options menu.
///
/// The `AutoplayFeedWidget` widget is used in the home feed to display autoplay feed items.
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hashtagable_v3/widgets/hashtag_text.dart';
import 'package:video_player/video_player.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/Home%20Feed/scroll_feed_page.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/share_bottom_sheet.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_popup.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';
import 'package:watermel/main.dart';

import '../../addComment/addcomments.dart';

class AutoplayFeedWidget extends StatefulWidget {
  const AutoplayFeedWidget({
    super.key,
    required this.index,
    required this.feedID,
    required this.userProfile,
    required this.userName,
    required this.displayName,
    required this.description,
    required this.reactionCount,
    required this.commentCount,
    required this.myStartTime,
    required this.mainImageURL,
  });
  final String? userProfile;
  final String? feedID;
  final int? index;
  final DateTime? myStartTime;
  final int? reactionCount;
  final int? commentCount;
  final String? displayName;
  final String? userName;
  final String? description;
  final String? mainImageURL;

  @override
  State<AutoplayFeedWidget> createState() => _AutoplayFeedWidgetState();
}

class _AutoplayFeedWidgetState extends State<AutoplayFeedWidget> {
  VideoPlayerController? videoPlayerController;
  HomeFeedController homeFeedController = Get.find<HomeFeedController>();
  RxBool isBookMarked = false.obs;
  RxInt ind = 0.obs;
  double volume = 0.0;

  @override
  void initState() {
    super.initState();
    isBookMarked.value =
        homeFeedController.homeFeedList[widget.index ?? 0].bookmark!;
    ind.value = widget.index ?? 0;
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        "$baseForImage${homeFeedController.homeFeedList[widget.index ?? 0].mediaData![0].video!}"))
      ..initialize().then((_) {
        videoPlayerController!.setVolume(0);
        videoPlayerController!.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeFeedController>(
        builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Insets.i20, vertical: Insets.i5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      storage.read(MyStorage.userName) ==
                              homeFeedController
                                  .homeFeedList[widget.index!].user!.username
                          ? Get.to(() => UserProfileScreenbackup(
                                fromProfile: true,
                                userName: storage.read(MyStorage.userName),
                              ))
                          : Get.to(() => UserProfileScreenbackup(
                                fromProfile: false,
                                userName: homeFeedController
                                        .homeFeedList[widget.index!]
                                        .user
                                        ?.username ??
                                    "",
                              ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileImageNameWidget(widget.userProfile,
                            widget.userName, widget.myStartTime, true),
                        PopupMenuButton<String>(
                            padding: const EdgeInsets.only(left: Insets.i35),
                            icon: SvgPicture.asset(MyImageURL.more),
                            onSelected: (String result) {
                              result == "report"
                                  ? commonDialog(
                                      context,
                                      "Report",
                                      "Are you sure You want to report this Post?",
                                      onTap: () async {
                                        Get.back();
                                        await homeFeedController
                                            .reportTheSeed(widget.feedID);
                                      },
                                    )
                                  : homeFeedController.bookMarkTheFeed(
                                      widget.feedID,
                                      ind: widget.index,
                                      bookmarkValue: homeFeedController
                                          .homeFeedList[ind.value].bookmark);
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'report',
                                    child: ListTile(
                                      leading: Icon(Icons.report),
                                      title: Text('Report'),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'bookmark',
                                    child: ListTile(
                                      leading: Icon(homeFeedController
                                                  .homeFeedList[ind.value]
                                                  .bookmark ==
                                              true
                                          ? Icons.bookmark_add_rounded
                                          : Icons.bookmark_add_outlined),
                                      title: Text(homeFeedController
                                                  .homeFeedList[ind.value]
                                                  .bookmark ==
                                              true
                                          ? 'bookmarked'
                                          : 'Bookmark'),
                                    ),
                                  ),
                                ])
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: Insets.i5,
                  ),
                  Obx(
                    // () => MyText(
                    //   text_name: viewText(
                    //       widget.description,
                    //       homeFeedController
                    //           .homeFeedList[widget.index!].isMore!.value),
                    //   fontWeight: FontWeight.w400,
                    //   txtfontsize: FontSizes.s14,
                    //   txtcolor: MyColors.grayColor,
                    //   txtAlign: TextAlign.left,
                    // ),
                    () => HashTagText(
                      text: viewText(
                          widget.description,
                          homeFeedController
                              .homeFeedList[widget.index!].isMore!.value),
                      basicStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: FontSizes.s14,
                        color: MyColors.grayColor,
                      ),
                      decoratedStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: FontSizes.s14,
                        color: MyColors.greenColor,
                      ),
                      onTap: (text) {
                        homeFeedController.selectedTopic.value =
                            text.replaceAll('#', '');
                        homeFeedController.getSeedsByTopic(true);
                        setState(() {});
                      },
                    ),
                  ),
                  widget.description!.length > 50
                      ? Obx(() => InkWell(
                            onTap: () {
                              if (homeFeedController.homeFeedList[widget.index!]
                                      .isMore!.value ==
                                  true) {
                                homeFeedController.homeFeedList[widget.index!]
                                    .isMore!.value = false;
                              } else {
                                homeFeedController.homeFeedList[widget.index!]
                                    .isMore!.value = true;
                              }

                              homeFeedController.update();
                              // viewText(widget.description, widget.isMore);
                            },
                            child: MyText(
                              text_name: homeFeedController
                                      .homeFeedList[widget.index!].isMore!.value
                                  ? "View more"
                                  : "View less",
                              fontWeight: FontWeight.w500,
                              txtfontsize: FontSizes.s14,
                              txtcolor: MyColors.blackColor,
                              txtAlign: TextAlign.left,
                            ),
                          ))
                      : Container(),
                  homeFeedController.homeFeedList[widget.index!].owner == null
                      ? SizedBox()
                      : Divider(
                          color: MyColors.grayColor.withOpacity(.5),
                        ),
                  const SizedBox(
                    height: Insets.i5,
                  ),
                  homeFeedController.homeFeedList[widget.index!].owner == null
                      ? SizedBox()
                      : ProfileImageNameWidget(
                          "$baseForImage${homeFeedController.homeFeedList[widget.index!].captionHistory!.first.userProfileUrl}",
                          homeFeedController.homeFeedList[widget.index!]
                                  .captionHistory!.first.userName ??
                              "N/A",
                          homeFeedController.homeFeedList[widget.index!]
                              .captionHistory!.first.createdAt,
                          false),
                  const SizedBox(
                    height: Insets.i10,
                  ),
                  homeFeedController.homeFeedList[widget.index!].owner == null
                      ? SizedBox()
                      : Obx(() => MyText(
                            text_name: viewText(
                                homeFeedController.homeFeedList[widget.index!]
                                    .captionHistory!.first.userPostCaption,
                                homeFeedController
                                    .homeFeedList[widget.index!].isMore!.value),
                            fontWeight: FontWeight.w400,
                            txtfontsize: FontSizes.s14,
                            txtcolor: MyColors.grayColor,
                            txtAlign: TextAlign.left,
                          )),
                  homeFeedController.homeFeedList[widget.index!].owner == null
                      ? SizedBox()
                      : homeFeedController
                                  .homeFeedList[widget.index!]
                                  .captionHistory!
                                  .first
                                  .userPostCaption!
                                  .length >
                              50
                          ? Obx(() => InkWell(
                                onTap: () {
                                  if (homeFeedController
                                          .homeFeedList[widget.index!]
                                          .isMore!
                                          .value ==
                                      true) {
                                    homeFeedController
                                        .homeFeedList[widget.index!]
                                        .isMore!
                                        .value = false;
                                  } else {
                                    homeFeedController
                                        .homeFeedList[widget.index!]
                                        .isMore!
                                        .value = true;
                                  }

                                  homeFeedController.update();
                                  // viewText(widget.description, widget.isMore);
                                },
                                child: MyText(
                                  text_name: homeFeedController
                                          .homeFeedList[widget.index!]
                                          .isMore!
                                          .value
                                      ? "View more"
                                      : "View less",
                                  fontWeight: FontWeight.w500,
                                  txtfontsize: FontSizes.s14,
                                  txtcolor: MyColors.blackColor,
                                  txtAlign: TextAlign.left,
                                ),
                              ))
                          : Container(),
                  //! AUTO PLAY VIDEO WIDGET
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          homeFeedController.viewedPost(homeFeedController
                              .homeFeedList[widget.index!].id!);
                          Get.to(
                              () => ScrollFeedPage(firstIndex: widget.index!));
                        },
                        child: Container(
                          height: Get.height * 0.28,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Insets.i12),
                            color: MyColors.blackColor,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                                height:
                                    videoPlayerController!.value.size.height,
                                width: videoPlayerController!.value.size.width,
                                child: VideoPlayer(videoPlayerController!)),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            if (videoPlayerController!.value.volume == 0) {
                              setState(() {
                                videoPlayerController!.setVolume(1);
                              });
                            } else {
                              setState(() {
                                videoPlayerController!.setVolume(0);
                              });
                            }
                          },
                          child: Container(
                            height: Insets.i40,
                            width: Insets.i40,
                            decoration: BoxDecoration(
                              color: MyColors.blackColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(Insets.i12),
                            ),
                            child: Center(
                              child: Icon(
                                videoPlayerController!.value.volume == 0
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                                color: MyColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Insets.i10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      blankDottWidget(),
                      MyText(
                        text_name:
                            "${homeFeedController.homeFeedList[widget.index!].viewCount ?? 0} views",
                        fontWeight: FontWeight.w400,
                        txtfontsize: FontSizes.s12,
                        txtcolor: MyColors.grayColor,
                        txtAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Divider(
                    color: MyColors.grayColor.withOpacity(.5),
                  ),
                  const SizedBox(
                    height: Insets.i6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                homeFeedController.reactionAPI(
                                    homeFeedController
                                        .homeFeedList[widget.index!].id,
                                    false,
                                    true,
                                    ind: widget.index);
                              },
                              child: SizedBox(
                                  height: Insets.i20,
                                  width: Insets.i20,
                                  child: SvgPicture.asset(homeFeedController
                                              .homeFeedList[widget.index!]
                                              .myReaction !=
                                          null
                                      ? MyImageURL.LikedImage
                                      : MyImageURL.like))),
                          const SizedBox(
                            width: Insets.i5,
                          ),
                          MyText(
                            text_name: widget.reactionCount.toString(),
                            txtcolor: MyColors.grayColor,
                            fontWeight: FontWeight.w400,
                            txtfontsize: FontSizes.s12,
                          ),
                          const SizedBox(
                            width: Insets.i10,
                          ),
                          InkWell(
                            onTap: () {
                              homeFeedController
                                  .getComment(
                                homeFeedController
                                    .homeFeedList[widget.index!].id,
                              )
                                  .whenComplete(() async {
                                homeFeedController.commentController.clear();
                                return await openCommentlistModel(
                                    context,
                                    homeFeedController
                                        .homeFeedList[widget.index!].id,
                                    false,
                                    ind: widget.index);
                              });
                            },
                            child: SizedBox(
                              height: Insets.i20,
                              width: Insets.i20,
                              child: SvgPicture.asset(MyImageURL.cmt),
                            ),
                          ),
                          const SizedBox(
                            width: Insets.i5,
                          ),
                          MyText(
                            text_name: widget.commentCount.toString(),
                            txtcolor: MyColors.grayColor,
                            fontWeight: FontWeight.w400,
                            txtfontsize: FontSizes.s12,
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () async {
                            ShowShareBottomSheet(
                                context,
                                widget.feedID,
                                homeFeedController
                                    .homeFeedList[widget.index!].shareURL,
                                homeFeedController
                                    .homeFeedList[widget.index!].caption,
                                widget.mainImageURL);
                          },
                          child: SvgPicture.asset(MyImageURL.sharePost)),
                    ],
                  ),
                  const SizedBox(
                    height: Insets.i10,
                  ),
                ],
              ),
            ));
  }

  viewText(detail, isview) {
    if (detail.length < 50) {
      return detail;
    } else if (detail.length > 50) {
      if (isview) {
        return "${detail.substring(0, 50)}";
      } else {
        return detail;
      }
    } else {
      return detail;
    }
  }

  Widget ProfileImageNameWidget(
      userProfileImage, userName, postTime, isReposted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: Insets.i40,
          width: Insets.i40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Insets.i12),
          ),
          child: CustomImageView(
              isProfilePicture: true,
              imagePathOrUrl: userProfileImage,
              radius: 100),
        ),
        const SizedBox(
          width: Insets.i8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width * 0.63,
              child: Row(
                children: [
                  MyText(
                    txtAlign: TextAlign.left,
                    maxline: 2,
                    text_name: userName,
                    txtcolor: MyColors.blackColor,
                    fontWeight: FontWeight.w500,
                    txtfontsize: FontSizes.s14,
                  ),
                  const SizedBox(
                    width: Insets.i10,
                  ),
                  homeFeedController.homeFeedList[widget.index!].owner ==
                              null ||
                          isReposted == false
                      ? const SizedBox()
                      : Row(
                          children: [
                            SvgPicture.asset(MyImageURL.repostIcon),
                            const SizedBox(
                              width: Insets.i5,
                            ),
                            MyText(
                              text_name: "Reposted",
                              txtcolor: MyColors.grayColor,
                              fontWeight: FontWeight.w400,
                              txtfontsize: FontSizes.s12,
                            ),
                          ],
                        )
                ],
              ),
            ),
            MyText(
              text_name: homeFeedController.timeDiffrance(postTime),
              txtcolor: MyColors.grayColor,
              fontWeight: FontWeight.w400,
              txtfontsize: FontSizes.s12,
            ),
          ],
        )
      ],
    );
  }
}
