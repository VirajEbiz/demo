import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watermel/app/Views/camera/camera_page.dart';
import 'package:watermel/app/Views/camera/camera_page_update.dart';
import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
import 'package:watermel/app/Views/draft/draftlist.dart';
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

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final createKey = GlobalKey<IntroductionScreenState>();
  CreateFeedController createFeedController = Get.put(CreateFeedController());
  int currentPage = 0;
  List<String> draftlist = [];
  List<String> draftlocallist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          currentPage == 2
              ? TextButton(
                  onPressed: () async {
                    if (createFeedController.selectedFilePath.value != "" ||
                        createFeedController.selectedThumbnailPath.value !=
                            "" ||
                        createFeedController.captionController.text != "") {
                      postAddDraftMethod();
                    } else {
                      Toaster().warning("Please add Some data");
                    }
                  },
                  child: const Text("Save as a draft"),
                )
              : const SizedBox(),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: IntroductionScreen(
            key: createKey,
            globalBackgroundColor: Colors.white,
            autoScrollDuration: null,
            freeze: true,
            showDoneButton: true,
            done: const Text("Post"),
            onDone: () async {
              log("Check pass data ==> ${createFeedController.isSelectedtype.value.toString().toLowerCase()}");
              if (createFeedController.selectedIndex == 0) {
                if (createFeedController.selectedIndex == 0 &&
                        createFeedController.captionController.text != "" ||
                    createFeedController.selectedFilePath.value != "") {
                  await createFeedController.CreateNewFeed("addNew", false);
                } else {
                  Toaster().warning("Image or Caption is required");
                }
              }
              if (createFeedController.selectedIndex == 1 ||
                  createFeedController.selectedIndex == 2) {
                if (createFeedController.selectedIndex != 0 &&
                    createFeedController.selectedFilePath.value == "") {
                  Toaster().warning("please select a file");
                } else {
                  if (createFeedController.selectedThumbnailPath.value == "") {
                    Toaster().warning("please select thumbnail");
                  } else {
                    await createFeedController.CreateNewFeed("addNew", false);
                  }
                }
              }
            },
            showBackButton: true,
            overrideBack: TextButton(
              onPressed: () {
                setState(() {
                  currentPage -= 1;
                });
                createKey.currentState?.animateScroll(currentPage);
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Icon(Icons.arrow_back),
            ),
            overrideNext: currentPage == 0
                ? const SizedBox(
                    height: 50,
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        currentPage += 1;
                      });
                      createKey.currentState?.animateScroll(currentPage);
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text("Next"),
                  ),
            showNextButton: true,
            curve: Curves.easeOutQuad,
            controlsMargin: const EdgeInsets.all(16),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Colors.black,
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            pages: [
              // Select the type of content to create
              PageViewModel(
                title: "What would you like to create?",
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w700,
                  ),
                  bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  pageColor: Colors.white,
                  imagePadding: EdgeInsets.zero,
                ),
                bodyWidget: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    for (var index = 0;
                        index < createFeedController.buttonList.length;
                        index++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              createFeedController.selectedIndex = index;
                              currentPage = 1;
                              createFeedController.selectedFilePath.value = "";
                              createFeedController.captionController.clear();
                            });
                            createKey.currentState?.animateScroll(1);
                          },
                          child: Container(
                            height: Get.height * 0.1,
                            // width: Get.width * 0.28,
                            decoration: BoxDecoration(
                              color: MyColors.greenColor,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  createFeedController.buttonList[index]
                                      ["ButtonIcon"],
                                  color: MyColors.whiteColor,
                                  height: Insets.i30,
                                  width: Insets.i30,
                                ),
                                const SizedBox(
                                  width: Insets.i5,
                                ),
                                MyText(
                                  text_name: createFeedController
                                      .buttonList[index]["ButtonName"],
                                  txtcolor: MyColors.whiteColor,
                                  fontWeight: FontWeight.w500,
                                  txtfontsize: FontSizes.s16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Upload a photo or video
              PageViewModel(
                title: createFeedController.selectedIndex == 0
                    ? "Do you want to upload a photo?"
                    : "Upload a video",
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w700,
                  ),
                  bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  pageColor: Colors.white,
                  imagePadding: EdgeInsets.zero,
                ),
                bodyWidget: Obx(
                  () => createFeedController.selectedFilePath.value == ""
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () => showMyBottomSheet(context, "",
                                    createFeedController.selectedIndex),
                                child: Container(
                                  height: Get.height * 0.1,
                                  // width: Get.width * 0.28,
                                  decoration: BoxDecoration(
                                    color: MyColors.greenColor,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        MyImageURL.upload,
                                        color: MyColors.whiteColor,
                                        height: Insets.i35,
                                        width: Insets.i35,
                                      ),
                                      const SizedBox(
                                        width: Insets.i5,
                                      ),
                                      MyText(
                                        text_name: "Upload",
                                        txtcolor: MyColors.whiteColor,
                                        fontWeight: FontWeight.w500,
                                        txtfontsize: FontSizes.s16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                dashPattern: const [6, 0, 2, 3],
                                color: Colors.black,
                                strokeWidth: 1,
                                borderPadding: const EdgeInsets.all(0),
                                radius: const Radius.circular(5),
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: Get.height * 0.27,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Obx(
                                    () => createFeedController
                                                .selectedFilePath.value !=
                                            ""
                                        ? SizedBox(
                                            height: Get.height,
                                            width: Get.width,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              clipBehavior: Clip.none,
                                              children: [
                                                createFeedController
                                                            .selectedIndex ==
                                                        1
                                                    ? CustomImageView(
                                                        isProfilePicture: false,
                                                        fit: BoxFit.cover,
                                                        radius: Insets.i5,
                                                        imagePathOrUrl:
                                                            createFeedController
                                                                .generatedThumNail
                                                                .value)
                                                    : CustomImageView(
                                                        isProfilePicture: false,
                                                        fit: BoxFit.cover,
                                                        fromDraftPodcast: true,
                                                        radius: Insets.i5,
                                                        imagePathOrUrl: createFeedController
                                                                    .selectedIndex ==
                                                                0
                                                            ? createFeedController
                                                                .selectedFilePath
                                                                .value
                                                            : "",
                                                      ),
                                                Positioned(
                                                  top: 5,
                                                  right: 5,
                                                  child: InkWell(
                                                    onTap: () {
                                                      createFeedController
                                                          .selectedFilePath
                                                          .value = "";
                                                      createFeedController
                                                          .generatedThumNail
                                                          .value = "";
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: Insets.i30,
                                                      width: Insets.i30,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: MyColors
                                                              .lightGray),
                                                      child: const Icon(
                                                          Icons.close),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : MyText(
                                            text_name: "No file selected",
                                            txtcolor: MyColors.grayColor,
                                            fontWeight: FontWeight.w400,
                                            txtfontsize: FontSizes.s14,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            if (createFeedController.selectedIndex != 0)
                              GestureDetector(
                                onTap: () {
                                  createFeedController.pickFile(
                                      forThumbnail: true);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: Get.height * 0.1,
                                      // width: Get.width * 0.28,
                                      decoration: BoxDecoration(
                                        color: MyColors.greenColor,
                                        border: Border.all(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Obx(
                                            () => createFeedController
                                                        .selectedThumbnailPath
                                                        .value ==
                                                    ""
                                                ? const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Icon(
                                                      Icons
                                                          .upload_file_outlined,
                                                      size: Insets.i35,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : CustomImageView(
                                                    isProfilePicture: false,
                                                    radius: Insets.i10,
                                                    fit: BoxFit.cover,
                                                    imagePathOrUrl:
                                                        createFeedController
                                                            .selectedThumbnailPath
                                                            .value),
                                          ),
                                          const SizedBox(width: Insets.i10),
                                          Obx(
                                            () => MyText(
                                              txtAlign: TextAlign.center,
                                              text_name: createFeedController
                                                          .selectedThumbnailPath
                                                          .value ==
                                                      ""
                                                  ? "Upload custom thumbnail"
                                                  : "Update thumbnail",
                                              // "If you think you are too small to make a difference...",
                                              // homeFeedController.searchUserDataList[index].username,
                                              fontWeight: FontWeight.w500,
                                              txtcolor: Colors.white,
                                              txtfontsize: FontSizes.s16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                          ],
                        ),
                ),
              ),
              PageViewModel(
                title: createFeedController.selectedFilePath.value == ""
                    ? "Add a description"
                    : "Do you want to add a description?",
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w700,
                  ),
                  bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  pageColor: Colors.white,
                  imagePadding: EdgeInsets.zero,
                ),
                bodyWidget: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                contentPadding:
                                    const EdgeInsets.all(Insets.i20),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: MyColors.grayColor),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'Post Description',
                                hintStyle: TextStyle(
                                    color: MyColors.grayColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: FontSizes.s14),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: MyColors.grayColor),
                                    borderRadius: BorderRadius.circular(10))),
                            style: TextStyle(
                                color: MyColors.blackColor,
                                fontWeight: FontWeight.w400,
                                fontSize: FontSizes.s15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showMyBottomSheet(context, image, selectedInd) {
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
                  : const SizedBox(),
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
                  : const SizedBox(),
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
                      text_name: createFeedController.selectedIndex == 2
                          ? "Gallery"
                          : "Library",
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
                    Get.to(() => CameraPage(
                          selectedType: createFeedController.selectedIndex,
                          fromEdit: false,
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

  Future<void> postAddDraftMethod() async {
    draftlist = [];
    if (createFeedController.isSelectedtype.value == "Read" ||
        createFeedController.isSelectedtype.value == "read") {
      // if (createFeedController.selectedFilePath.value != "") {
      createFeedController.update();
      File storedImage = File(createFeedController.selectedFilePath.value);
      final fileName =
          path.basename(createFeedController.selectedFilePath.value);
      final filetxt = fileName;
      var savedImage =
          filetxt == "" ? null : await copyImagevideo(storedImage, filetxt);

      var a = {
        "image": savedImage == null ? "" : savedImage.path ?? "",
        "detail": createFeedController.captionController.text
      };
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      //clear storage and list
      /*  prefs.remove(MyStorage.draftreadlist);
        draftlist = [];*/

      final List<String> items1 =
          prefs.getStringList(MyStorage.draftreadlist) ?? [];

      draftlist = items1;
      draftlist.add(json.encode(a));

      await prefs.setStringList(MyStorage.draftreadlist, draftlist);

      createFeedController.selectedFilePath.value = "";
      createFeedController.captionController.clear();
      createFeedController.selectedFileFramePath.value = "";

      Toaster().warning("Post added in draft successfully");
      Get.off(() => UserdraftlistScreen(
            navKey: 0,
          ));
      // }
    } else if (createFeedController.isSelectedtype.value == "Watch") {
      // if (createFeedController.selectedFilePath.value != "") {

      File storedImage = File(createFeedController.selectedFilePath.value);

      final fileName =
          path.basename(createFeedController.selectedFilePath.value);

      final filext = fileName;

      var savedImage =
          filext == "" ? null : await copyImagevideo(storedImage, filext);

      var a = {
        "image": "",
        "videopath": savedImage == null ? "" : savedImage.path ?? "",
        "detail": createFeedController.captionController.text,
        "thumbnailURL": createFeedController.selectedThumbnailPath.value,
      };

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String> items1 =
          prefs.getStringList(MyStorage.draftwatchlist) ?? [];

      draftlocallist = items1;

      draftlocallist.add(json.encode(a));

      await prefs.setStringList(MyStorage.draftwatchlist, draftlocallist);

      createFeedController.selectedFilePath.value = "";
      createFeedController.captionController.clear();
      createFeedController.selectedFileFramePath.value = "";

      Toaster().warning("Post added in draft successfully");
      Get.off(() => UserdraftlistScreen(
            navKey: 1,
          ));
      // }
    } else if (createFeedController.isSelectedtype.value == "Podcast") {
      draftlocallist = [];

      // if (createFeedController.selectedFilePath.value != "") {
      File storedImage = File(createFeedController.selectedFilePath.value);
      final fileName =
          path.basename(createFeedController.selectedFilePath.value);
      final filext = fileName;
      var savedImage =
          filext == "" ? null : await copyImagevideo(storedImage, filext);

      var data = {
        "image": "",
        "audioPath": savedImage == null ? "" : savedImage.path ?? "",
        "detail": createFeedController.captionController.text == ""
            ? ""
            : createFeedController.captionController.text,
        "thumbnailURL": createFeedController.selectedThumbnailPath.value,
      };

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String>? items1 =
          prefs.getStringList(MyStorage.draftpodcastlist);

      draftlocallist = items1 ?? [];
      draftlocallist.add(json.encode(data));

      await prefs.setStringList(MyStorage.draftpodcastlist, draftlocallist);
      createFeedController.selectedFilePath.value = "";
      createFeedController.captionController.clear();
      createFeedController.selectedFileFramePath.value = "";

      Toaster().warning("Post added in draft successfully");
      Get.off(() => UserdraftlistScreen(
            navKey: 2,
          ));
      // }
    }
  }
}
