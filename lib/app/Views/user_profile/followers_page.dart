import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Notification_Follow/follow_controller.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/Views/home_bottom_bar/homebottom_controller.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';

/// A page that displays the followers and following of a user profile.
class FollowersPage extends StatefulWidget {
  final bool fromProfile;
  final String username;
  final bool? isFollowers;

  /// Constructs a [FollowersPage] with the given [isFollowers] parameter.
  const FollowersPage({
    super.key,
    required this.fromProfile,
    required this.username,
    required this.isFollowers,
  });

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  UserProfileController userProfileController =
      Get.put(UserProfileController());
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    print("username ===> ${widget.username}");
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.isFollowers! ? 0 : 1);
    userProfileController.currentFollowersPage.value = 1;
    userProfileController.currentFollowingPage.value = 1;
    getData();
  }

  /// Fetches the followers and following data from the user profile controller.
  void getData() async {
    try {
      await userProfileController.getFollowersList();
      await userProfileController.getFollowingList();

      setState(() {});
    } on Exception catch (e) {
      print(e);
    }
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (_tabController.index == 0) {
          userProfileController.currentFollowersPage.value++;
          userProfileController.getFollowersList();
        } else {
          userProfileController.currentFollowingPage.value++;
          userProfileController.getFollowingList();
        }
      }
    }
    return true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.back();
        if (widget.fromProfile) {
          Get.offAll(
            () => HomePage(
              pageIndex: 3,
            ),
          );
        } else {
          String username = widget.username;
          Get.offAll(() => HomePage());
          Get.to(() => UserProfileScreenbackup(
                fromProfile: widget.fromProfile,
                userName: username,
              ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () {
              Get.back();
              if (widget.fromProfile) {
                Get.offAll(
                  () => HomePage(
                    pageIndex: 3,
                  ),
                );
              } else {
                String username = widget.username;
                Get.offAll(() => HomePage());
                Get.to(() => UserProfileScreenbackup(
                      fromProfile: widget.fromProfile,
                      userName: username,
                    ));
              }
            },
          ),
          title: Text(
            widget.username,
            style: TextStyle(
              color: MyColors.blackColor,
              fontSize: FontSizes.s16,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Followers Tab
            NotificationListener(
              onNotification: onNotification,
              child: ListView.builder(
                itemCount: userProfileController.followersList.length,
                itemBuilder: (context, index) {
                  final followerUser =
                      userProfileController.followersList[index];
                  return ListTile(
                    onTap: () {
                      Get.to(() => UserProfileScreenbackup(
                            fromProfile: false,
                            userName: followerUser.username,
                          ));
                    },
                    leading: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CustomImageView(
                        radius: 100,
                        imagePathOrUrl:
                            "$baseForImage${followerUser.profilePicture}",
                        isProfilePicture: true,
                      ),
                    ),
                    title: MyText(
                      txtAlign: TextAlign.start,
                      text_name: followerUser.displayName ?? "N/A",
                      fontWeight: FontWeight.w500,
                      txtcolor: MyColors.blackColor,
                      txtfontsize: FontSizes.s14,
                    ),
                    subtitle: MyText(
                      txtAlign: TextAlign.start,
                      text_name: "@${followerUser.username}",
                      fontWeight: FontWeight.w400,
                      txtcolor: MyColors.grayColor,
                      txtfontsize: FontSizes.s12,
                    ),
                    trailing: widget.fromProfile
                        ? TextButton(
                            child: const Text('Remove'),
                            onPressed: () async {
                              await confirmPopup(context, followerUser.id!);
                            },
                          )
                        : null,
                  );
                },
              ),
            ),
            // Following Tab
            NotificationListener(
              onNotification: onNotification,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userProfileController.followingList.length,
                  itemBuilder: (context, index) {
                    final followingUser =
                        userProfileController.followingList[index];
                    return ListTile(
                      onTap: () {
                        Get.to(() => UserProfileScreenbackup(
                              fromProfile: false,
                              userName: followingUser.username,
                            ));
                      },
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CustomImageView(
                          radius: 100,
                          imagePathOrUrl:
                              "$baseForImage${followingUser.profilePicture}",
                          isProfilePicture: true,
                        ),
                      ),
                      title: MyText(
                        txtAlign: TextAlign.start,
                        text_name: followingUser.displayName ?? "N/A",
                        fontWeight: FontWeight.w500,
                        txtcolor: MyColors.blackColor,
                        txtfontsize: FontSizes.s14,
                      ),
                      subtitle: MyText(
                        txtAlign: TextAlign.start,
                        text_name: "@${followingUser.username}",
                        fontWeight: FontWeight.w400,
                        txtcolor: MyColors.grayColor,
                        txtfontsize: FontSizes.s12,
                      ),
                      trailing: widget.fromProfile
                          ? TextButton(
                              child: const Text('Unfollow'),
                              onPressed: () async {
                                await confirmPopup(context, followingUser.id!);
                              },
                            )
                          : null,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  confirmPopup(BuildContext context, int id) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: MyText(
              text_name: "WaterMel App",
              fontWeight: FontWeight.w500,
              txtcolor: MyColors.blackColor,
              txtfontsize: FontSizes.s15,
            ),
            content: MyText(
              text_name: _tabController.index == 0
                  ? "Are you sure you want to remove this follower?"
                  : "Are you sure you want unfollow this user?",
              fontWeight: FontWeight.w400,
              txtcolor: MyColors.blackColor,
              txtfontsize: FontSizes.s14,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: MyText(
                  text_name: "No",
                  fontWeight: FontWeight.w600,
                  txtcolor: MyColors.blackColor,
                  txtfontsize: FontSizes.s16,
                ),
              ),
              TextButton(
                onPressed: _tabController.index == 0
                    ? () async {
                        final responseCode =
                            await userProfileController.removeFollower(id: id);
                        if (responseCode == 200) {
                          setState(() {
                            userProfileController.followersList
                                .removeWhere((element) => element.id == id);
                          });
                        }
                        Get.back();
                        Get.back();
                        userProfileController.update();
                      }
                    : () async {
                        FollowController followController =
                            Get.put(FollowController());
                        await followController
                            .rejectFollowReqAPI(id, false)
                            .whenComplete(() async {
                          Get.back();
                          Get.back();
                          userProfileController.update();
                          setState(() {
                            userProfileController.followingList
                                .removeWhere((element) => element.id == id);
                          });
                        });
                      },
                child: MyText(
                  text_name: "Yes",
                  fontWeight: FontWeight.w600,
                  txtcolor: MyColors.blackColor,
                  txtfontsize: FontSizes.s16,
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
