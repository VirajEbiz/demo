import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/feed_detail_screen.dart';
import 'package:watermel/app/core/helpers/contants.dart';

/// A page that displays a scrollable feed of detail screens.
class ScrollFeedPage extends StatefulWidget {
  const ScrollFeedPage({super.key, required this.firstIndex});

  final int firstIndex;

  @override
  State<ScrollFeedPage> createState() => _ScrollFeedPageState();
}

class _ScrollFeedPageState extends State<ScrollFeedPage> {
  final HomeFeedController homeFeedController = Get.put(HomeFeedController());

  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.firstIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => PageView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          itemCount: homeFeedController.homeFeedList.length,
          onPageChanged: (value) {
            homeFeedController
                .viewedPost(homeFeedController.homeFeedList[value].id!);
          },
          itemBuilder: (context, index) {
            if (index >= homeFeedController.homeFeedList.length - 1) {
              homeFeedController.page++;
              if (homeFeedController.currentPage.value <
                  homeFeedController.totalPage.value) {
                homeFeedController.getAllFeedData(false, true);
              } else {
                homeFeedController.noMoreFeeds.value = "No New Posts!";
              }
            }
            print(
                "THIS IS THE NUMBER OF LIKES: ${homeFeedController.homeFeedList[index].reactionsCount}");
            return FeedDetailScreen(
              createTime: homeFeedController.homeFeedList[index].createdAt,
              shareURL: homeFeedController.homeFeedList[index].shareURL,
              commentCount:
                  homeFeedController.homeFeedList[index].commentsCount,
              isBookmark: homeFeedController.homeFeedList[index].bookmark,
              likeCount: homeFeedController.homeFeedList[index].reactionsCount,
              thumbnail: homeFeedController.homeFeedList[index].thumbnailURL ==
                      null
                  ? ""
                  : "$baseForImage${homeFeedController.homeFeedList[index].thumbnailURL}",
              caption: homeFeedController.homeFeedList[index].caption,
              feedID: homeFeedController.homeFeedList[index].id,
              mediaURL: homeFeedController.tempList.any((element) =>
                      element ==
                      homeFeedController
                          .homeFeedList[index].mediaData!.first.video
                          ?.split('.')
                          .last)
                  ? "$baseForImage${homeFeedController.homeFeedList[index].mediaData!.first.video}"
                  : homeFeedController
                      .homeFeedList[index].mediaData!.first.image,
              mediaType: homeFeedController.tempList.any((element) =>
                      element ==
                      homeFeedController
                          .homeFeedList[index].mediaData!.first.video
                          ?.split('.')
                          .last)
                  ? 1
                  : 0,
              index: index,
              userName: homeFeedController.homeFeedList[index].user!.username,
              displayname: homeFeedController
                  .homeFeedList[index].user!.userprofile!.displayName,
              userProfile:
                  "$baseForImage${homeFeedController.homeFeedList[index].user!.userprofile!.profilePicture}",
              myReaction: homeFeedController.homeFeedList[index].myReaction,
            );
          },
        ),
      ),
    );
  }
}
