import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/scroll_controller.dart';
import 'package:watermel/app/Views/top_influencers/top_influencers_page.dart';
import 'package:watermel/app/Views/create_new_feed/create_page.dart';
import 'package:watermel/app/Views/trendingDebates/trending_debates_page.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:watermel/app/core/theme/theme.dart';
import 'package:watermel/app/Views/create_new_feed/create_new_feed.dart';
import 'package:watermel/app/Views/Home%20Feed/feed_screen.dart';
import 'package:watermel/app/Views/user_profile/widget/coming_soon.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'homebottom_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.pageIndex});
  int? pageIndex;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    homeController.pageIndex.value = widget.pageIndex ?? 0;
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (mounted) {
      if (AppLifecycleState.resumed == state) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const FeedScreen(),
      // ComingSoonWidget(fromHome: true),
      const TopInfluencersPage(),
      // ComingSoonWidget(fromHome: true),
      const TrendingDebatesPage(),
      UserProfileScreenbackup(
        fromProfile: true,
      )
    ];
    return SafeArea(
      child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) => homeController.pageIndex.value == 0
              ? null
              : onWillPopAlert(context),
          child: Scaffold(
            //backgroundColor: MyColors.whiteColor,
            //extendBody: true,
            body: Stack(
              children: [
                Obx(() => pages[homeController.pageIndex.value]),
              ],
            ),
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: BottomAppBar(
              shadowColor: MyColors.blackColor,
              elevation: 0,
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Adjust spacing as needed
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              if (homeController.pageIndex.value == 0) {
                                Get.find<HomeScrollController>().scrollToTop();
                              }
                              homeController.pageIndex.value = 0;
                            },
                            child: BottomNavBarItem(
                              asset: MyImageURL.homeNew,
                              controller: homeController,
                              index: 0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              homeController.pageIndex.value = 1;
                            },
                            child: BottomNavBarItem(
                              asset: MyImageURL.billboardIcon,
                              controller: homeController,
                              index: 1,
                            ),
                          ),
                        ),
                        // Add SizedBox for spacing
                        const SizedBox(width: Insets.i40),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              homeController.pageIndex.value = 2;
                            },
                            child: BottomNavBarItem(
                              asset: MyImageURL.debatesIcon,
                              controller: homeController,
                              index: 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              homeController.pageIndex.value = 3;
                            },
                            child: BottomNavBarItem(
                              asset: MyImageURL.userAcconutIcon,
                              controller: homeController,
                              index: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            floatingActionButton: Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
              child: FloatingActionButton(
                onPressed: () {
                  // Get.to(() => CreateNewFeedScreen(
                  //       selectedType: 0,
                  //       fromVideoRecording: false,
                  //     ));
                  Get.to(() => const CreatePage());
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  Icons.add,
                  color: MyColors.whiteColor,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          )),
    );
  }

  Widget navBar() {
    return Positioned(
      bottom: 0,
      left: 10,
      right: 10,
      child: Stack(
        children: [
          Container(
            height: 110,
            width: Get.width,
            color: Colors.transparent,
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: primaryColor,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              // color: Colors.green,
              width: Get.width,
              height: 70,
              color: MyColors.lightYelloColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      homeController.pageIndex.value = 0;
                    },
                    child: BottomNavBarItem(
                      asset: "assets/navbar/home.svg",
                      controller: homeController,
                      index: 0,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      homeController.pageIndex.value = 1;
                    },
                    child: BottomNavBarItem(
                      asset: "assets/navbar/search.svg",
                      controller: homeController,
                      index: 1,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      homeController.pageIndex.value = 2;
                    },
                    child: BottomNavBarItem(
                      asset: "assets/navbar/debate.svg",
                      controller: homeController,
                      index: 2,
                    ),
                  ),
                  Container(
                    child: InkWell(
                      onTap: () {
                        homeController.pageIndex.value = 3;
                      },
                      child: BottomNavBarItem(
                        asset: "assets/images/account-3.svg",
                        controller: homeController,
                        index: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: -5,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 5,
                ),
              ),
              child: InkWell(
                onTap: () {
                  // Get.toNamed(HomeRoutes.cameraPage);
                },
                child: BottomNavBarItem(
                  asset: "assets/navbar/add.svg",
                  size: 30,
                  controller: homeController,
                  index: -1,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onWillPopAlert(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("WaterMel App"),
            content: Text("Are you sure You want close App?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        )) ??
        false;
  }
}

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem({
    super.key,
    required this.controller,
    required this.index,
    required this.asset,
    this.size = 25,
    this.color = Colors.white,
  });

  final HomeController controller;
  final int index;
  final String asset;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          controller.pageIndex.value == index
              ? Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: MyColors.greenColor),
                )
              : const SizedBox(
                  height: 8,
                  width: 8,
                ),
          const SizedBox(height: Insets.i10),
          index == 3
              ? Image.asset(
                  asset,
                  color: controller.pageIndex.value == index
                      ? MyColors.greenColor
                      : MyColors.grayColor,
                  height: 25,
                  width: 40,
                )
              : SvgPicture.asset(
                  asset,
                  color: controller.pageIndex.value == index
                      ? MyColors.greenColor
                      : MyColors.grayColor,
                  height: size,
                  width: size,
                ),
        ],
      ),
    );
  }
}
