import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:watermel/app/Views/draft/draft_detail_screen.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/widgets/content_button_widget.dart';
import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
import 'package:watermel/app/Views/draft/edit_draft-screen.dart';
import '../../Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/main.dart';
import 'dart:math';
import '../../utils/theme/colors.dart';
import '../../widgets/common_methods.dart';
import '../../widgets/common_widget.dart';
import 'package:just_audio/just_audio.dart';

class UserdraftlistScreen extends StatefulWidget {
  UserdraftlistScreen({super.key, required this.navKey});
  int? navKey;
  @override
  State<UserdraftlistScreen> createState() => _UserdraftlistScreenState();
}

class _UserdraftlistScreenState extends State<UserdraftlistScreen>
    with SingleTickerProviderStateMixin {
  final UserProfileController userProfileController =
      Get.put(UserProfileController());
  CreateFeedController createFeedController = Get.put(CreateFeedController());

  final _player = AudioPlayer();
  late TabController _tabController;

  // List<String>? jsonitems = [];
  List readList = [];
  List watchList = [];
  List podcastList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createFeedController.selectedIndex = widget.navKey!;
      createFeedController.selectedFilePath.value = "";
      createFeedController.captionController.clear();
      createFeedController.selectedFileFramePath.value = "";
      createFeedController.isSelected.value = true;
      createFeedController.isSelectedtype.value = "Read";
      Future.delayed(Duration(milliseconds: 10));
      setState(() {});
    });

    _tabController = TabController(length: 3, vsync: this);
    onload();
    onwatchTab();
    onAudioTab();

    super.initState();
  }

  onload() async {
    readList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var items1 = prefs.getStringList(MyStorage.draftreadlist);
    if (items1 != null) {
      for (int i = 0; i < items1.length; i++) {
        var item2 = jsonDecode(items1[i]);

        readList.add(item2);
      }
    }
    setState(() {});
  }

  getFilesizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  onwatchTab() async {
    watchList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var items1 = prefs.getStringList(MyStorage.draftwatchlist);
    for (int i = 0; i < items1!.length; i++) {
      var item2 = jsonDecode(items1[i]);

      watchList.add(item2);
    }
    setState(() {});
  }

  onAudioTab() async {
    podcastList = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var items1 = prefs.getStringList(MyStorage.draftpodcastlist);
    if (items1 != null) {
      for (int i = 0; i < items1!.length; i++) {
        var item2 = jsonDecode(items1[i]);
        podcastList.add(item2);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: appbarPreferredSize1("My Drafts", true, () {
        Get.offAll(() => HomePage());
      }),
      body: GetBuilder<UserProfileController>(builder: (_) => homeBody()),
    );
  }

  homeBody() {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
                // border: Border(bottom: BorderSide(color: MyColors.blackColor, width: 0.9)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.i10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    createFeedController.buttonList.length,
                    (index) => InkWell(
                      onTap: () async {
                        createFeedController.selectedIndex = index;
                        createFeedController.isSelected.value = true;
                        if (createFeedController.selectedIndex == 0) {
                          createFeedController.isSelectedtype.value = "Read";
                        } else if (createFeedController.selectedIndex == 1) {
                          createFeedController.isSelectedtype.value = "Watch";
                        } else if (createFeedController.selectedIndex == 2) {
                          createFeedController.isSelectedtype.value = "Podcast";
                        }
                        // createFeedController.selectedFilePath.value = "";
                        // createFeedController.captionController.clear();
                        //
                        // createFeedController.selectedIndex = index;
                        // log("Selected index ==> ${createFeedController.selectedIndex}");
                        // createFeedController.selectedIndex == 0
                        //     ? createFeedController.isSelectedtype.value = "Read"
                        //     : createFeedController.selectedIndex == 1
                        //     ? createFeedController.isSelectedtype.value =
                        // "Watch"
                        //     : createFeedController.isSelectedtype.value =
                        // "Podcast";
                        // log("Selected index ==> ${createFeedController.isSelectedtype.value}");
                        //
                        // if (createFeedController.buttonList[index]
                        // ["IsSelected"] ==
                        //     createFeedController.selectedIndex) {
                        //   createFeedController.isSelected.value = true;
                        // }
                        //
                        // myFocus.unfocus();
                        //
                        setState(() {});
                      },
                      child: Padding(
                        padding: index == 1
                            ? const EdgeInsets.symmetric(horizontal: Insets.i7)
                            : const EdgeInsets.all(0),
                        child: MainContentTypeButtonWidget2(
                          fromHome: false,
                          index: index,
                          buttonName: createFeedController.buttonList[index]
                              ["ButtonName"],
                          isSelected: createFeedController.isSelected,
                          iconName: createFeedController.buttonList[index]
                              ["ButtonIcon"],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Insets.i20, vertical: Insets.i20),
            child: showtabView(),
          ),
          // child: TabBar(
          //     onTap: (index) {
          //       if (index == 0) {
          //         onload();
          //       } else if (index == 1) {
          //         onwatchTab();
          //       } else {
          //         onAudioTab();
          //       }
          //     },
          //     //current tab index
          //     tabs: [
          //       Tab(
          //           child: SvgPicture.asset(
          //         MyImageURL.FrameImage,
          //         height: Insets.i28,
          //         color: MyColors.blackColor,
          //       )),
          //       Tab(
          //           child: SvgPicture.asset(
          //         MyImageURL.videoplay,
          //         height: Insets.i30,
          //         color: MyColors.grayColor,
          //       )),
          //       Tab(
          //           child: SvgPicture.asset(
          //         MyImageURL.readseedImage,
          //         height: Insets.i28,
          //         color: MyColors.grayColor,
          //       )),
          //     ],
          //     indicatorColor: MyColors.blackColor,
          //     controller: _tabController,
          //     indicatorSize: TabBarIndicatorSize.tab)
          // ),
          // const SizedBox(height: Insets.i30),
          // Expanded(
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: Insets.i15),
          //     child: TabBarView(
          //       controller: _tabController,
          //       children: [
          //         // first tab bar view widget
          //         buildGridView(),
          //         // second tab bar viiew widget
          //         watchGridView(),
          //         podcastView()
          //       ],
          //     ),
          //   ),
        ),
      ],
    );
  }

  showtabView() {
    if (createFeedController.selectedIndex == 0) {
      return buildGridView();
    } else if (createFeedController.selectedIndex == 1) {
      return watchGridView();
    } else if (createFeedController.selectedIndex == 2) {
      return podcastView();
    }
  }

  buildGridView() {
    if (readList.length == 0) {
      return MyNoPost();
    }
    return ListView.builder(
        itemCount: readList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Get.to(() => DraftDetailScreen(
                    caption: readList[index]["detail"],
                    mediaURL: readList[index]["image"],
                    mediaType: 0,
                    index: index,
                    userName: storage.read(MyStorage.userName),
                    displayname: storage.read(MyStorage.displayName),
                    userProfile:
                        "$baseUrl${storage.read(MyStorage.userProfile)}",
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom:
                        BorderSide(color: MyColors.lightGrayColor, width: 1)),
              ),
              padding: const EdgeInsets.symmetric(vertical: Insets.i10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: Get.width * 0.20,
                          margin: const EdgeInsets.all(Insets.i4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: CustomImageView(
                              isProfilePicture: false,
                              radius: 8,
                              fit: BoxFit.cover,
                              imagePathOrUrl: readList[index]["image"]),
                        ),
                      ),
                      const SizedBox(width: Insets.i10),
                      Expanded(
                          flex: 6,
                          child: MyText(
                            txtAlign: TextAlign.start,
                            text_name: readList[index]["detail"] == null ||
                                    readList[index]["detail"] == ""
                                ? "N/A"
                                : CommonMethod().textlength(
                                    readList[index]["detail"] ?? "N/A", 80),
                            fontWeight: FontWeight.w400,
                            txtcolor: MyColors.blackColor,
                            txtfontsize: FontSizes.s14,
                          )),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                createFeedController.selectedFilePath.value =
                                    readList[index]["image"];
                                createFeedController.captionController.text =
                                    readList[index]["detail"];
                                createFeedController.isFeedPrivate.value =
                                    readList[index]["isPrivate"];
                                createFeedController.isSelectedtype.value =
                                    "read";
                                Get.to(() => EditDraftScreen(
                                      fromVideoRecording: false,
                                      caption: createFeedController
                                          .captionController.text,
                                      isPrivate: createFeedController
                                          .isFeedPrivate.value,
                                      postType: 0,
                                      index: index,
                                      draftList: readList,
                                      mediaURL: createFeedController
                                          .selectedFilePath.value,
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SvgPicture.asset(MyImageURL.editIcon,
                                    height: Insets.i22),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                deletedraft(context, "delete", "Read", index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: SvgPicture.asset(MyImageURL.deleteIcon,
                                    height: Insets.i22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  genThumbnailFile(String path) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: path,
      // "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      //imageFormat: ImageFormat.PNG,
      maxHeight: 64,

      quality: 75,
    );
    return fileName.toString();
  }

  watchGridView() {
    if (watchList.length == 0) {
      return MyNoPost();
    }

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: watchList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          // getDuration(watchList[index]["videopath"]);
          return InkWell(
            onTap: () {
              Get.to(() => DraftDetailScreen(
                    displayname: storage.read(MyStorage.displayName),
                    caption: watchList[index]["detail"],
                    mediaURL: watchList[index]["videopath"],
                    mediaType: 1,
                    thumbnail: watchList[index]["thumbnailURL"],
                    index: index,
                    userName: storage.read(MyStorage.userName),
                    userProfile:
                        "$baseUrl${storage.read(MyStorage.userProfile)}",
                  ));
            },
            child: Container(
              // height: Get.width * 0.26,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom:
                        BorderSide(color: MyColors.lightGrayColor, width: 1)),
              ),
              padding: const EdgeInsets.symmetric(vertical: Insets.i10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: Get.width * 0.2,
                              height: Get.height * 0.1,
                              child: CustomImageView(
                                isProfilePicture: false,
                                radius: 8,
                                fit: BoxFit.cover,
                                imagePathOrUrl: watchList[index]
                                    ["thumbnailURL"],
                              ),
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
                      ),
                      const SizedBox(width: Insets.i10),
                      Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyText(
                                txtAlign: TextAlign.start,
                                text_name: watchList[index]["detail"].length <
                                        50
                                    ? watchList[index]["detail"] == "" ||
                                            watchList[index]["detail"] == null
                                        ? "N/A"
                                        : watchList[index]["detail"]
                                    : watchList[index]["detail"] == "" ||
                                            watchList[index]["detail"] == null
                                        ? "N/A"
                                        : "${watchList[index]["detail"].substring(0, 40)}...",
                                //  watchList[index]["detail"].substring(0, 50),
                                //textOverflow: TextOverflow.ellipsis,
                                // "If you think you are too small to make a difference...",
                                // homeFeedController.searchUserDataList[index].username,
                                fontWeight: FontWeight.w400,
                                txtcolor: MyColors.blackColor,
                                txtfontsize: FontSizes.s14,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  color: MyColors.blackColor,
                                  border:
                                      Border.all(color: MyColors.blackColor),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: MyText(
                                    text_name:
                                        "${watchList[index]["duration"]}",
                                    txtcolor: MyColors.whiteColor,
                                    fontWeight: FontWeight.w500,
                                    txtfontsize: FontSizes.s10,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                createFeedController.selectedFilePath.value =
                                    watchList[index]["videopath"];

                                createFeedController.selectedThumbnailPath
                                    .value = watchList[index]["thumbnailURL"];
                                createFeedController.captionController.text =
                                    watchList[index]["detail"];
                                createFeedController.isSelectedtype.value =
                                    "watch";
                                createFeedController.isFeedPrivate.value =
                                    watchList[index]["isPrivate"];
                                Get.to(() => EditDraftScreen(
                                      fromVideoRecording: false,
                                      isPrivate: createFeedController
                                          .isFeedPrivate.value,
                                      postType: 1,
                                      index: index,
                                      mediaURL: createFeedController
                                          .selectedFilePath.value,
                                      draftList: watchList,
                                      thumbnailURL: createFeedController
                                          .selectedThumbnailPath.value,
                                      caption: createFeedController
                                          .captionController.text,
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SvgPicture.asset(MyImageURL.editIcon,
                                    height: Insets.i22),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                deletedraft(context, "delete", "Watch", index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: SvgPicture.asset(MyImageURL.deleteIcon,
                                    height: Insets.i22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  podcastView() {
    if (podcastList.length == 0) {
      return MyNoPost();
    }
    List tempList = ['mp4', 'avi', 'mkv', 'mov', "MOV", "MP4", "AVI", "MKV"];

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: podcastList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              tempList.any((element) =>
                      element ==
                      podcastList[index]["audioPath"]
                          .split('.')
                          .last
                          .toLowerCase())
                  ? Get.to(() => DraftDetailScreen(
                        displayname: storage.read(MyStorage.displayName),
                        caption: podcastList[index]["detail"],
                        mediaURL: podcastList[index]["audioPath"],
                        thumbnail: podcastList[index]["thumbnailURL"],
                        mediaType: 1,
                        index: index,
                        userName: storage.read(MyStorage.userName),
                        userProfile:
                            "$baseUrl${storage.read(MyStorage.userProfile)}",
                      ))?.then((value) {
                      if (value == true) {
                        onwatchTab();
                      }
                    })
                  : Get.to(() => DraftDetailScreen(
                        displayname: storage.read(MyStorage.displayName),
                        caption: podcastList[index]["detail"],
                        mediaURL: podcastList[index]["audioPath"],
                        thumbnail: podcastList[index]["thumbnailURL"],
                        mediaType: 2,
                        index: index,
                        userName: storage.read(MyStorage.userName),
                        userProfile:
                            "$baseUrl${storage.read(MyStorage.userProfile)}",
                      ));
            },
            child: Container(
              // padding: const EdgeInsets.only(bottom: Insets.i25),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom:
                        BorderSide(color: MyColors.lightGrayColor, width: 1)),
              ),

              padding: const EdgeInsets.symmetric(vertical: Insets.i10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: Get.width * 0.2,
                              height: Get.height * 0.1,
                              child: CustomImageView(
                                isProfilePicture: false,
                                radius: 8,
                                fit: BoxFit.cover,
                                imagePathOrUrl: podcastList[index]
                                    ["thumbnailURL"],
                              ),
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
                      ),
                      const SizedBox(width: Insets.i10),
                      Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: MyText(
                              txtAlign: TextAlign.start,
                              text_name: podcastList[index]["detail"] == "" ||
                                      podcastList[index]["detail"] == null
                                  ? "N/A"
                                  : podcastList[index]["detail"],
                              maxline: 2,
                              fontWeight: FontWeight.w400,
                              txtcolor: MyColors.blackColor,
                              txtfontsize: FontSizes.s14,
                            ),
                          )),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  createFeedController.selectedFilePath.value =
                                      podcastList[index]["audioPath"];

                                  createFeedController.captionController.text =
                                      podcastList[index]["detail"];
                                  createFeedController
                                          .selectedThumbnailPath.value =
                                      podcastList[index]["thumbnailURL"];
                                  createFeedController.isSelectedtype.value =
                                      "podcast";
                                  createFeedController.isFeedPrivate.value =
                                      podcastList[index]["isPrivate"];

                                  Get.to(() => EditDraftScreen(
                                      fromVideoRecording: false,
                                      isPrivate: createFeedController
                                          .isFeedPrivate.value,
                                      postType: 2,
                                      index: index,
                                      draftList: podcastList,
                                      mediaURL: createFeedController
                                          .selectedFilePath.value,
                                      thumbnailURL: createFeedController
                                          .selectedThumbnailPath.value,
                                      caption: createFeedController
                                          .captionController.text));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: SvgPicture.asset(MyImageURL.editIcon,
                                      height: Insets.i22),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  deletedraft(
                                      context, "delete", "Podcast", index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: SvgPicture.asset(MyImageURL.deleteIcon,
                                      height: Insets.i22),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  /*Logout App confirm popup*/
  deletedraft(BuildContext context, type, postType, index) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: MyColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: SvgPicture.asset(MyImageURL.deletedraft,
                      height: Insets.i60),
                ),
                SizedBox(height: Insets.i10),
                MyText(
                  txtAlign: TextAlign.center,
                  text_name:
                      type == "delete" ? "Delete Draft Post" : "Upload Post",
                  txtcolor: MyColors.redColor,
                  fontWeight: FontWeight.w500,
                  txtfontsize: FontSizes.s18,
                ),
              ],
            ),
            content: MyText(
              txtAlign: TextAlign.left,
              text_name: type == "delete"
                  ? "Are you sure to delete this post?"
                  : "Are you sure you want to Upload Post?",
              txtcolor: MyColors.grayColor,
              fontWeight: FontWeight.w400,
              txtfontsize: FontSizes.s15,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: Get.width * 0.25,
                      decoration: BoxDecoration(
                        color: MyColors.grayColor,
                        border: Border.all(color: MyColors.grayColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Insets.i15, horizontal: 0),
                        child: MyText(
                          text_name: "No",
                          txtcolor: MyColors.whiteColor,
                          fontWeight: FontWeight.w500,
                          txtfontsize: FontSizes.s13,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      deletePostOnDraft(postType, index);
                    },
                    child: Container(
                      width: Get.width * 0.25,
                      decoration: BoxDecoration(
                        color: MyColors.redColor,
                        border: Border.all(color: MyColors.redColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Insets.i15, horizontal: 0),
                        child: MyText(
                          text_name: "Delete",
                          txtcolor: MyColors.whiteColor,
                          fontWeight: FontWeight.w500,
                          txtfontsize: FontSizes.s13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // TextButton(
              //   onPressed: () => Navigator.of(context).pop(false),
              //   child: MyText(
              //     txtAlign: TextAlign.center,
              //     text_name: "No",
              //     txtcolor: MyColors.grayColor,
              //     fontWeight: FontWeight.w500,
              //     txtfontsize: FontSizes.s17,
              //   ),
              // ),
              // TextButton(
              //   onPressed: () {
              //     // Get.back();
              //     // if (type == "delete") {
              //     //   deletePostOnDraft();
              //     // } else {
              //     //   createFeedController.selectedFilePath.value = url;
              //     //   createFeedController.captionController.text =
              //     //       createFeedController.captionController.text;
              //     //   createFeedController.isSelectedtype.value = postType;
              //     //   createFeedController.CreateNewFeed("draft").then((value) {
              //     //     if (value == true) {
              //     //      // deletePostOnDraft(backhome: true);
              //     //     }
              //     //   });
              //     //
              //     //   //uploadPost();
              //     // }
              //   },
              //   child: MyText(
              //     txtAlign: TextAlign.center,
              //     text_name: "Yes",
              //     txtcolor: MyColors.greenColor,
              //     fontWeight: FontWeight.w500,
              //     txtfontsize: FontSizes.s17,
              //   ),
              // ),
            ],
          ),
        )) ??
        false;
  }

  //Delete draft posts
  deletePostOnDraft(postType, postIndex) async {
    if (postType == "Read") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var watchList = prefs.getStringList(MyStorage.draftreadlist);

      watchList!.removeAt(postIndex);

      await prefs.setStringList(MyStorage.draftreadlist, watchList);
      var watchList1 = prefs.getStringList(MyStorage.draftreadlist);

      onload();
      Get.back();
    } else if (postType == "Watch") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var watchList = prefs.getStringList(MyStorage.draftwatchlist);

      watchList!.removeAt(postIndex);
      await prefs.setStringList(MyStorage.draftwatchlist, watchList);
      onwatchTab();
      Get.back();
      // var watchList1 = prefs.getStringList(MyStorage.draftwatchlist);
      // if (backhome == true) {
      //   Get.offAll(HomePage());
      // } else {
      //   Get.back(result: true);
      // }
    }
    if (postType == "Podcast") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var podcastList = prefs.getStringList(MyStorage.draftpodcastlist);
      podcastList!.removeAt(postIndex);
      await prefs.setStringList(MyStorage.draftpodcastlist, podcastList);
      var podcastlist1 = prefs.getStringList(MyStorage.draftpodcastlist);

      onAudioTab();
      Get.back();
      // if (backhome == true) {
      //   Get.offAll(HomePage());
      // } else {
      //   Get.back(result: true);
      // }
    }
  }
}
