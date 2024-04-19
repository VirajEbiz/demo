import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:watermel/app/Views/camera/camera_page.dart';
import 'package:watermel/app/Views/camera/camera_page_update.dart';
import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
import 'package:watermel/app/Views/draft/draftlist.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/Views/user_profile/widget/coming_soon.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';
import 'package:path/path.dart' as path;

class EditDraftScreen extends StatefulWidget {
  EditDraftScreen(
      {super.key,
      this.postType,
      this.index,
      this.mediaURL,
      this.draftList,
      this.caption,
      required this.fromVideoRecording,
      this.isPrivate,
      this.thumbnailURL});
  //! 0 = Read, 1 = watch, 2 = podcast

  int? postType, index;
  List? draftList = [];
  String? mediaURL, thumbnailURL, caption;
  bool? isPrivate, fromVideoRecording;

  @override
  State<EditDraftScreen> createState() => _EditDraftScreenState();
}

class _EditDraftScreenState extends State<EditDraftScreen> {
  CreateFeedController createFeedController = Get.put(CreateFeedController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });
  }

  setData() async {
    createFeedController.selectedIndex = widget.postType!;
    createFeedController.isSelectedtype.value = widget.postType == 0
        ? "read"
        : widget.postType == 1
            ? "watch"
            : "podcast";
    if (widget.postType == 1) {
      await createFeedController.generateThumbnail(widget.mediaURL!);
    }
    widget.mediaURL == null
        ? null
        : createFeedController.selectedFilePath.value = widget.mediaURL!;
    createFeedController.selectedThumbnailPath.value =
        widget.thumbnailURL ?? "";
    createFeedController.captionController.text = widget.caption ?? "";
  }

  @override
  Widget build(BuildContext context) {
    log("CHceck media url -==> ${createFeedController.generatedThumNail.value}");
    return Scaffold(
      appBar: appbarPreferredSize("Edit Post", true,
          isRightIcon: false, isRightText: true, backonTap: () {
        Get.offAll(() => UserdraftlistScreen(navKey: widget.postType));
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Insets.i20),
              child: DottedBorder(
                borderType: BorderType.RRect,
                dashPattern: [6, 0, 2, 3],
                color: Colors.black,
                strokeWidth: 1,
                borderPadding: const EdgeInsets.all(0),
                radius: const Radius.circular(5),
                strokeCap: StrokeCap.round,
                child: Container(
                  alignment: Alignment.center,
                  height: Get.height * 0.27,
                  width: Get.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Obx(
                    () => createFeedController.selectedFilePath.value != ""
                        ? SizedBox(
                            height: Get.height,
                            width: Get.width,
                            child: Stack(
                              fit: StackFit.expand,
                              clipBehavior: Clip.none,
                              children: [
                                createFeedController.selectedIndex == 1 ||
                                        createFeedController.selectedIndex == 2
                                    ? CustomImageView(
                                        isProfilePicture: false,
                                        fit: BoxFit.cover,
                                        radius: Insets.i5,
                                        imagePathOrUrl: createFeedController
                                            .generatedThumNail.value)
                                    : CustomImageView(
                                        isProfilePicture: false,
                                        fit: BoxFit.cover,
                                        fromDraftPodcast: true,
                                        radius: Insets.i5,
                                        imagePathOrUrl: createFeedController
                                                    .selectedIndex ==
                                                0
                                            ? createFeedController
                                                .selectedFilePath.value
                                            : "",
                                      ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: InkWell(
                                    onTap: () {
                                      createFeedController
                                          .selectedFilePath.value = "";
                                      createFeedController
                                          .generatedThumNail.value = "";
                                      createFeedController
                                          .selectedThumbnailPath.value = "";
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: Insets.i30,
                                      width: Insets.i30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: MyColors.lightGray),
                                      child: const Icon(Icons.close),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(MyImageURL.upload),
                              InkWell(
                                onTap: () {
                                  ShowMyBottomSheet(context,
                                      createFeedController.selectedIndex);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(Insets.i10),
                                  width: Get.width * 0.4,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: MyColors.greenColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Insets.i10),
                                    child: MyText(
                                      text_name: "Upload",
                                      txtcolor: MyColors.whiteColor,
                                      fontWeight: FontWeight.w500,
                                      txtfontsize: FontSizes.s12,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
            widget.postType != 0
                ? GestureDetector(
                    onTap: () {
                      createFeedController.pickFile(forThumbnail: true);
                    },
                    child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Insets.i20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: Get.height * 0.1,
                                width: Get.width * 0.2,

                                //margin: const EdgeInsets.all(Insets.i4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Obx(
                                  () => createFeedController
                                              .selectedThumbnailPath.value ==
                                          ""
                                      ? const Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: Icon(
                                              Icons.upload_file_outlined,
                                              size: Insets.i50),
                                        )
                                      : CustomImageView(
                                          isProfilePicture: false,
                                          radius: Insets.i10,
                                          fit: BoxFit.cover,
                                          imagePathOrUrl: createFeedController
                                              .selectedThumbnailPath.value),
                                )),
                            const SizedBox(width: Insets.i10),
                            Obx(
                              () => MyText(
                                txtAlign: TextAlign.center,
                                text_name: createFeedController
                                            .selectedThumbnailPath.value ==
                                        ""
                                    ? "Upload thumbnail"
                                    : "Update thumbnail",
                                // "If you think you are too small to make a difference...",
                                // homeFeedController.searchUserDataList[index].username,
                                fontWeight: FontWeight.w400,
                                txtcolor: MyColors.blackColor,
                                txtfontsize: FontSizes.s14,
                              ),
                            ),
                          ],
                        )),
                  )
                : SizedBox(),
            SizedBox(
              height: Insets.i20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.i20),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(10)),
                child: Theme(
                  data: ThemeData(primaryColor: MyColors.grayColor),
                  child: TextFormField(
                    // focusNode: myFocus,
                    cursorColor: Colors.black,
                    maxLines: 6,
                    controller: createFeedController.captionController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(Insets.i20),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.grayColor),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Post Description',
                        hintStyle: TextStyle(
                            color: MyColors.grayColor,
                            fontWeight: FontWeight.w400,
                            fontSize: FontSizes.s14),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.grayColor),
                            borderRadius: BorderRadius.circular(10))),
                    style: TextStyle(
                        color: MyColors.blackColor,
                        fontWeight: FontWeight.w400,
                        fontSize: FontSizes.s15),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Insets.i20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.i20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text_name: "Make Post Private",
                    txtcolor: MyColors.blackColor,
                    fontWeight: FontWeight.w500,
                    txtfontsize: FontSizes.s14,
                  ),
                  GestureDetector(
                    onTap: () {
                      createFeedController.isFeedPrivate.value =
                          !createFeedController.isFeedPrivate.value;
                    },
                    child: Obx(
                      () => SvgPicture.asset(
                        createFeedController.isFeedPrivate.value
                            ? MyImageURL.ontoggle
                            : MyImageURL.offtoggle,
                      ),
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                createFeedController.isSelectedtype.value = widget.postType == 0
                    ? "read"
                    : widget.postType == 1
                        ? "watch"
                        : "podcast";
                if (createFeedController.selectedIndex == 0) {
                  if (createFeedController.selectedIndex == 0 &&
                          createFeedController.captionController.text != "" ||
                      createFeedController.selectedFilePath.value != "") {
                    createFeedController.CreateNewFeed("draft", false)
                        .whenComplete(() async {
                      await deletePostOnDraft(true);

                      setState(() {});
                    });
                  } else {
                    Toaster().warning("Post Description is required");
                  }
                }
                if (createFeedController.selectedIndex == 1) {
                  if (createFeedController.selectedIndex != 0 &&
                      createFeedController.selectedFilePath.value == "") {
                    Toaster().warning("please select a file");
                  } else {
                    if (createFeedController.selectedThumbnailPath.value ==
                        "") {
                      Toaster().warning("Please select thumbnail");
                    } else {
                      createFeedController.CreateNewFeed("draft", false)
                          .whenComplete(() async {
                        await deletePostOnDraft(true);

                        setState(() {});
                      });
                    }
                  }
                }
                if (createFeedController.selectedIndex == 2) {
                  if (createFeedController.selectedIndex != 0 &&
                      createFeedController.selectedFilePath.value == "") {
                    Toaster().warning("please select a file");
                  } else {
                    if (createFeedController.selectedThumbnailPath.value ==
                        "") {
                      Toaster().warning("Please select thumbnail");
                    } else {
                      createFeedController.CreateNewFeed("draft", false)
                          .whenComplete(() async {
                        await deletePostOnDraft(true);

                        setState(() {});
                      });
                    }
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.all(Insets.i20),
                padding: const EdgeInsets.all(Insets.i5),
                width: Get.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyColors.greenColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.i10),
                  child: MyText(
                    text_name: "Post",
                    txtcolor: MyColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    txtfontsize: FontSizes.s16,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (createFeedController.selectedFilePath.value != "" ||
                    createFeedController.selectedThumbnailPath.value != "" ||
                    createFeedController.captionController.text != "") {
                  await deletePostOnDraft(false);
                  updateDraftMethod(widget.draftList).whenComplete(() {
                    setState(() {});
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: Insets.i20),
                padding: const EdgeInsets.all(Insets.i5),
                width: Get.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyColors.blackColor,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.i10),
                  child: MyText(
                    text_name: "Update as Draft",
                    txtcolor: MyColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    txtfontsize: FontSizes.s16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Insets.i30,
            ),
          ],
        ),
      ),
    );
  }

  List<String> draftlocallist = [];

  Future<void> updateDraftMethod(draftList) async {
    if (createFeedController.isSelectedtype.value.toLowerCase() == "read" ||
        widget.postType == 0) {
      // if (createFeedController.selectedFilePath.value != "") {
      createFeedController.update();
      // File _storedImage = File(createFeedController.selectedFilePath.value);
      // final fileName =
      //     path.basename(createFeedController.selectedFilePath.value);
      // final filetxt = fileName;
      // var savedImage =
      //     filetxt == "" ? "" : await copyImagevideo(_storedImage, filetxt);

      var a = {
        "image": createFeedController.selectedFilePath.value,
        // savedImage == null || savedImage == "" ? "" : savedImage.path ?? "",
        "detail": createFeedController.captionController.text,
        "isPrivate": createFeedController.isFeedPrivate.value,
      };
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      //clear storage and list
      /*  prefs.remove(MyStorage.draftreadlist);
        draftlist = [];*/

      final List<String> items1 =
          prefs.getStringList(MyStorage.draftreadlist) ?? [];

      draftList = items1;
      draftList.insert(widget.index!, json.encode(a));

      await prefs.setStringList(MyStorage.draftreadlist, draftList);

      createFeedController.selectedFilePath.value = "";
      createFeedController.captionController.clear();
      createFeedController.selectedFileFramePath.value = "";

      Get.offAll(() => UserdraftlistScreen(navKey: 0))!.whenComplete(() {
        setState(() {});
      });

      Toaster().warning("Post Updated in draft successfully");
    } else if (createFeedController.isSelectedtype.value.toLowerCase() ==
            "watch" ||
        widget.postType == 1) {
      // if (createFeedController.selectedFilePath.value != "") {

      // File _storedImage = File(createFeedController.selectedFilePath.value);

      // final fileName =
      //     path.basename(createFeedController.selectedFilePath.value);

      // final filext = fileName;
      // var savedImage = filext == "" || filext == null
      //     ? null
      //     : await copyImagevideo(_storedImage, filext);
      if (createFeedController.selectedFilePath.value == "") {
        var a = {
          "image": "",
          "videopath": createFeedController.selectedFilePath.value,
          "detail": createFeedController.captionController.text,
          "thumbnailURL": createFeedController.selectedThumbnailPath.value == ""
              ? createFeedController.generatedThumNail.value
              : createFeedController.selectedThumbnailPath.value,
          "isPrivate": createFeedController.isFeedPrivate.value,
        };

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final List<String>? items1 =
            prefs.getStringList(MyStorage.draftwatchlist) ?? [];

        draftlocallist = items1 != null ? items1 : [];

        draftlocallist.insert(widget.index!, json.encode(a));

        await prefs.setStringList(MyStorage.draftwatchlist, draftlocallist);

        createFeedController.selectedFilePath.value = "";
        createFeedController.captionController.clear();
        createFeedController.selectedFileFramePath.value = "";

        Get.offAll(() => UserdraftlistScreen(navKey: 1))!.whenComplete(() {
          setState(() {});
        });
        Toaster().warning("Post Updated in draft successfully");
      } else {
        await setFile(createFeedController.selectedFilePath.value);
      }

      // }
    } else if (createFeedController.isSelectedtype.value.toLowerCase() ==
            "podcast" ||
        widget.postType == 2) {
      draftlocallist = [];

      // File _storedImage = File(createFeedController.selectedFilePath.value);
      // final fileName =
      //     path.basename(createFeedController.selectedFilePath.value);
      // final filext = fileName;
      // var savedImage = filext == "" || filext == null
      //     ? null
      //     : await copyImagevideo(_storedImage, filext);

      var a = {
        "image": "",
        "audioPath": createFeedController.selectedFilePath.value,
        // savedImage == null || savedImage == "" ? "" : savedImage.path ?? "",
        "detail": createFeedController.captionController.text,
        "thumbnailURL": createFeedController.selectedThumbnailPath.value == ""
            ? createFeedController.generatedThumNail.value
            : createFeedController.selectedThumbnailPath.value,
        "isPrivate": createFeedController.isFeedPrivate.value,
      };

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      //clear storage and list
      // prefs.remove(MyStorage.draftpodcastlist);
      // draftlocallist = [];

      final List<String>? items1 =
          prefs.getStringList(MyStorage.draftpodcastlist);

      draftlocallist = items1 ?? [];
      draftlocallist.insert(widget.index!, json.encode(a));

      await prefs.setStringList(MyStorage.draftpodcastlist, draftlocallist);
      createFeedController.selectedFilePath.value = "";
      createFeedController.captionController.clear();
      createFeedController.selectedFileFramePath.value = "";

      Get.offAll(() => UserdraftlistScreen(navKey: 2))!.whenComplete(() {
        setState(() {});
      });
      Toaster().warning("Post Updated in draft successfully");
    }
  }

  Future deletePostOnDraft(backhome) async {
    if (widget.postType == 0) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var watchList = prefs.getStringList(MyStorage.draftreadlist);
      watchList!.removeAt(widget.index!);

      await prefs.setStringList(MyStorage.draftreadlist, watchList);
      var watchList1 = prefs.getStringList(MyStorage.draftreadlist);
      setState(() {});
      backhome == true
          ? Get.offAll(() => HomePage(
                pageIndex: 0,
              ))
          : null;
    }
    if (widget.postType == 1) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var watchList = prefs.getStringList(MyStorage.draftwatchlist);
      await watchList!.removeAt(widget.index!);
      await prefs.setStringList(MyStorage.draftwatchlist, watchList);
      var watchList1 = prefs.getStringList(MyStorage.draftwatchlist);
      setState(() {});
      backhome == true
          ? Get.offAll(() => HomePage(
                pageIndex: 0,
              ))
          : null;
    }
    if (widget.postType == 2) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var podcastList = prefs.getStringList(MyStorage.draftpodcastlist);
      podcastList!.removeAt(widget.index!);
      await prefs.setStringList(MyStorage.draftpodcastlist, podcastList);
      var podcastlist1 = prefs.getStringList(MyStorage.draftpodcastlist);
      setState(() {});
      backhome == true
          ? Get.offAll(() => HomePage(
                pageIndex: 0,
              ))
          : null;
    }
  }

  ShowMyBottomSheet(context, selectedInd) {
    CreateFeedController createFeedController =
        Get.find<CreateFeedController>();
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(Insets.i20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: MyColors.greenColor),
                      ),
                      const SizedBox(
                        width: Insets.i10,
                      ),
                      MyText(
                        fontWeight: FontWeight.w600,
                        txtfontsize: FontSizes.s18,
                        text_name: "Upload",
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Insets.i36,
                      width: Insets.i36,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: MyColors.lightGray),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: Insets.i25,
              ),
              createFeedController.selectedIndex == 2
                  ? InkWell(
                      onTap: () {
                        Get.back();
                        createFeedController.pickFile();
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(MyImageURL.imageIcon),
                          const SizedBox(
                            width: Insets.i10,
                          ),
                          MyText(
                            fontWeight: FontWeight.w400,
                            text_name: "Audio File",
                            txtfontsize: FontSizes.s14,
                            txtcolor: MyColors.grayColor,
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height:
                    createFeedController.selectedIndex == 2 ? Insets.i25 : 0,
              ),
              createFeedController.selectedIndex == 2
                  ? InkWell(
                      onTap: () {
                        Get.back(closeOverlays: true);
                        Get.to(() => ComingSoonWidget(fromHome: false));
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            MyImageURL.podcast,
                          ),
                          const SizedBox(
                            width: Insets.i10,
                          ),
                          MyText(
                            fontWeight: FontWeight.w400,
                            text_name: "Record Podcast",
                            txtfontsize: FontSizes.s14,
                            txtcolor: MyColors.grayColor,
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height:
                    createFeedController.selectedIndex == 2 ? Insets.i25 : 0,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                  createFeedController.pickFile(fromVideo: true);
                },
                child: Row(
                  children: [
                    SvgPicture.asset(MyImageURL.galary),
                    const SizedBox(
                      width: Insets.i10,
                    ),
                    MyText(
                      fontWeight: FontWeight.w400,
                      txtfontsize: FontSizes.s14,
                      text_name: "Library",
                      txtcolor: MyColors.grayColor,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: Insets.i25,
              ),
              InkWell(
                onTap: () {
                  if (createFeedController.selectedIndex == 0) {
                    createFeedController.cameraPick();
                  } else if (createFeedController.selectedIndex == 1 ||
                      createFeedController.selectedIndex == 2) {
                    Get.offAll(() => CameraPage(
                          isPrivate: widget.isPrivate,
                          caption: widget.caption,
                          thumbnailURL: widget.thumbnailURL ??
                              createFeedController.selectedThumbnailPath.value,
                          selectedType: widget.postType,
                          draftList: widget.draftList,
                          ind: widget.index,
                          fromEdit: true,
                        ));
                  } else if (createFeedController.selectedIndex == 2) {
                    Get.to(() => ComingSoonWidget(
                          fromHome: false,
                        ));
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(MyImageURL.camera),
                    const SizedBox(
                      width: Insets.i10,
                    ),
                    MyText(
                      fontWeight: FontWeight.w400,
                      text_name: "Camera",
                      txtfontsize: FontSizes.s14,
                      txtcolor: MyColors.grayColor,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: Insets.i25,
              ),
            ],
          ),
        );
      },
    );
  }

  late VideoPlayerController _controller;

  dynamic dd;
  Future setFile(mediaURL) async {
    try {
      _controller = await VideoPlayerController.file(File(mediaURL))
        ..initialize().then((_) async {
          dd =
              "${_controller.value.duration.inMinutes.toString()}:${_controller.value.duration.inSeconds.toString()}";
          var a;

          a = {
            "image": "",
            "videopath": createFeedController.selectedFilePath.value,
            "detail": createFeedController.captionController.text,
            "thumbnailURL":
                createFeedController.selectedThumbnailPath.value == ""
                    ? createFeedController.generatedThumNail.value
                    : createFeedController.selectedThumbnailPath.value,
            "duration": "$dd",
            "isPrivate": createFeedController.isFeedPrivate.value,
          };
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          final List<String>? items1 =
              prefs.getStringList(MyStorage.draftwatchlist) ?? [];

          draftlocallist = items1 != null ? items1 : [];

          draftlocallist.insert(widget.index!, json.encode(a));
          await prefs.setStringList(MyStorage.draftwatchlist, draftlocallist);

          createFeedController.selectedFilePath.value = "";
          createFeedController.captionController.clear();
          createFeedController.selectedFileFramePath.value = "";

          Get.offAll(() => UserdraftlistScreen(navKey: 1))!.whenComplete(() {
            setState(() {});
          });
          Toaster().warning("Post Updated in draft successfully");
        });
    } catch (e) {
      Toaster().warning(e.toString());
    }
  }
}
