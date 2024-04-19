import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/divider_widget.dart';
import 'package:watermel/app/Views/top_influencers/user_rank_page.dart';
import 'package:watermel/app/Views/top_influencers/widgets/top_influencers_card.dart';
import 'package:watermel/app/Views/top_influencers/controller/top_influencers_controller.dart';
import 'package:watermel/app/Views/top_influencers/widgets/user_influencers_card.dart';
import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/common_methods.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';

/// A page that displays a list of top influencers on a top influencers.
class TopInfluencersPage extends StatefulWidget {
  const TopInfluencersPage({Key? key}) : super(key: key);

  @override
  State<TopInfluencersPage> createState() => _TopInfluencersPageState();
}

class _TopInfluencersPageState extends State<TopInfluencersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TopInfluencersController topinfluencersController =
      Get.put(TopInfluencersController());

  @override
  void initState() {
    topinfluencersController.getTopInfluencersData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _tabController.animation!.addListener(_handleTabChange);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.animation!.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.index == 0) {
      if (topinfluencersController.topInfluencersList.isEmpty) {
        topinfluencersController.getTopInfluencersData();
      }
    } else {
      if (topinfluencersController.friendsList.isEmpty) {
        topinfluencersController.getFriendsData(false);
      }
    }
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        topinfluencersController.currentPage.value++;
        if (topinfluencersController.currentPage.value <
            topinfluencersController.totalPages.value) {
          topinfluencersController.getFriendsData(true);
        }
      }
    } else if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        topinfluencersController.currentPage.value++;
        if (topinfluencersController.currentPage.value <
            topinfluencersController.totalPages.value) {
          topinfluencersController.getFriendsData(true);
        }
      }
    } else if (notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        topinfluencersController.currentPage.value++;
        if (topinfluencersController.currentPage.value <
            topinfluencersController.totalPages.value) {
          topinfluencersController.getFriendsData(true);
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              surfaceTintColor: Colors.white,
              // title: Center(
              //   child: MyText(
              //     text_name: "Top Watermelers",
              //   ),
              // ),
              flexibleSpace: FlexibleSpaceBar(
                background: appbarPreferredSizeAction(
                    "Top Waterlmelers", false, "Trending Debates", () {}),
              ),
              pinned: true,
              floating: true,
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Global'),
                  Tab(text: 'Friends'),
                ],
              ),
            ),
          ];
        },
        body: Obx(
          () => TabBarView(
            controller: _tabController,
            children: [
              topinfluencersController.topInfluencersList.isEmpty
                  ? CommonMethod().venueListEffect(5)
                  : ListView.builder(
                      itemCount: topinfluencersController.userRank.value.rank !=
                                  null &&
                              topinfluencersController.userRank.value.rank! > 10
                          ? topinfluencersController.topInfluencersList.length +
                              1
                          : topinfluencersController.topInfluencersList.length,
                      itemBuilder: (context, index) {
                        if (index ==
                                topinfluencersController
                                    .topInfluencersList.length &&
                            topinfluencersController.userRank.value.rank !=
                                null &&
                            topinfluencersController.userRank.value.rank! >
                                10) {
                          return Column(
                            children: [
                              MyCustomDivider2(sized: Insets.i20),
                              MyText(
                                text_name: "My Rank",
                                txtfontsize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              OpenContainer(
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                closedBuilder: (context, action) {
                                  return UserInfluencersCard(
                                    userProfileData:
                                        topinfluencersController.userRank.value,
                                    rank: topinfluencersController
                                            .userRank.value.rank ??
                                        0,
                                    onClicked: () async {
                                      if (topinfluencersController
                                          .userList.isEmpty) {
                                        showLoader();
                                        await topinfluencersController
                                            .getUserData();
                                        hideLoader();
                                        if (topinfluencersController
                                            .userList.isNotEmpty) {
                                          action();
                                        } else {
                                          toaster.error("No data found");
                                        }
                                      } else {
                                        action();
                                      }
                                    },
                                  );
                                },
                                openBuilder: (context, action) =>
                                    UserRankPage(),
                              ),
                              const SizedBox(
                                height: Insets.i40,
                              ),
                            ],
                          );
                        } else {
                          return TopInfluencersCard(
                            userProfileData: topinfluencersController
                                .topInfluencersList[index],
                            rank: index + 1,
                            isSelf: topinfluencersController
                                    .topInfluencersList[index].username ==
                                topinfluencersController
                                    .userRank.value.username,
                            isFriends: false,
                          );
                        }
                      },
                    ),
              Obx(
                () => topinfluencersController.friendsList.isEmpty
                    ? CommonMethod().venueListEffect(5)
                    : NotificationListener(
                        onNotification: onNotification,
                        child: ListView.builder(
                          itemCount:
                              topinfluencersController.friendsList.length,
                          itemBuilder: (context, index) {
                            return TopInfluencersCard(
                              userProfileData:
                                  topinfluencersController.friendsList[index],
                              rank: index + 1,
                              isSelf: topinfluencersController
                                      .friendsList[index].username ==
                                  topinfluencersController
                                      .userRank.value.username,
                              isFriends: true,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
