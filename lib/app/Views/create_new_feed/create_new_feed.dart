import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/camera/camera_page.dart';
import 'package:watermel/app/Views/camera/camera_page_update.dart';
import 'package:watermel/app/widgets/content_button_widget.dart';
import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
import 'package:watermel/app/Views/user_profile/widget/coming_soon.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';
import 'package:path/path.dart' as path;
import 'package:watermel/main.dart';
import '../../Views/home_bottom_bar/home_page.dart';
import '../../utils/preference.dart';
import '../draft/draftlist.dart';

class CreateNewFeedScreen extends StatefulWidget {
  CreateNewFeedScreen(
      {super.key,
      this.videoPath,
      required this.fromVideoRecording,
      this.thumbnailURl,
      this.caption,
      required this.selectedType});
  String? videoPath, thumbnailURl, caption;
  bool? fromVideoRecording;
  int? selectedType;
  @override
  State<CreateNewFeedScreen> createState() => _CreateNewFeedScreenState();
}

class _CreateNewFeedScreenState extends State<CreateNewFeedScreen> {
  HomeFeedController homeFeedController = Get.put(HomeFeedController());
  File? _image;
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
    if (widget.fromVideoRecording == true) {
      await createFeedController.generateThumbnail(widget.videoPath!);
    }
    if (widget.fromVideoRecording == false) {
      createFeedController.selectedIndex = widget.selectedType ?? 0;

      createFeedController.selectedFilePath.value = "";
      createFeedController.captionController.clear();
      createFeedController.selectedFileFramePath.value = "";
      createFeedController.isSelected.value = true;
      createFeedController.isSelectedtype.value = "Read";
      Future.delayed(Duration(milliseconds: 10));
      setState(() {});
    } else {
      if (widget.selectedType == 1) {
        createFeedController.selectedIndex = widget.selectedType ?? 0;

        createFeedController.selectedFilePath.value = widget.videoPath!;
        createFeedController.captionController.clear();
        createFeedController.selectedFileFramePath.value = "";
        createFeedController.isSelected.value = true;
        createFeedController.isSelectedtype.value = "Watch";
        createFeedController.generatedThumNail.value =
            widget.thumbnailURl ?? "";
        createFeedController.captionController.text = widget.caption ?? "";

        Future.delayed(Duration(milliseconds: 10));
        setState(() {});
      } else {
        createFeedController.selectedIndex = widget.selectedType ?? 0;

        createFeedController.selectedFilePath.value = widget.videoPath!;
        createFeedController.generatedThumNail.value =
            widget.thumbnailURl ?? "";
        createFeedController.captionController.text = widget.caption ?? "";
        createFeedController.captionController.clear();
        createFeedController.selectedFileFramePath.value = "";
        createFeedController.isSelected.value = true;
        createFeedController.isSelectedtype.value = "Podcast";
        Future.delayed(Duration(milliseconds: 10));
        setState(() {});
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  FocusNode myFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (v) {
        Get.offAll(() => HomePage(
              pageIndex: 0,
            ));
      },
      child: Scaffold(
        //  resizeToAvoidBottomInset: false,
        appBar: appbarPreferredSize(
          "Create Post",
          true,
          isRightIcon: false,
          isRightText: true,
          backonTap: () {
            Get.offAll(() => HomePage(),
                transition: Transition.leftToRight,
                duration: Duration(milliseconds: 400));
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.i20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    homeFeedController.buttonList.length,
                    (index) => InkWell(
                      onTap: () async {
                        myFocus.unfocus();
                        createFeedController.selectedFilePath.value = "";
                        createFeedController.generatedThumNail.value = "";
                        createFeedController.selectedThumbnailPath.value = "";
                        createFeedController.captionController.clear();

                        createFeedController.selectedIndex = index;
                        log("Selected index ==> ${createFeedController.selectedIndex}");
                        createFeedController.selectedIndex == 0
                            ? createFeedController.isSelectedtype.value = "Read"
                            : createFeedController.selectedIndex == 1
                                ? createFeedController.isSelectedtype.value =
                                    "Watch"
                                : createFeedController.isSelectedtype.value =
                                    "Podcast";
                        log("Selected index ==> ${createFeedController.isSelectedtype.value}");

                        if (createFeedController.buttonList[index]
                                ["IsSelected"] ==
                            createFeedController.selectedIndex) {
                          createFeedController.isSelected.value = true;
                        }

                        myFocus.unfocus();

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
              ),
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
                                          createFeedController.selectedIndex ==
                                              2
                                      ? CustomImageView(
                                          isProfilePicture: false,
                                          fit: BoxFit.cover,
                                          radius: Insets.i5,
                                          imagePathOrUrl: createFeedController
                                              .generatedThumNail.value
                                              .toString())
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
                                    ShowMyBottomSheet(context, _image,
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
              createFeedController.selectedIndex != 0
                  ? GestureDetector(
                      onTap: () {
                        createFeedController.pickFile(forThumbnail: true);
                      },
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Insets.i20),
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
                      focusNode: myFocus,
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
                  myFocus.unfocus();
                  log("Check pass data ==> ${createFeedController.isSelectedtype.value.toString().toLowerCase()}");
                  if (createFeedController.selectedIndex == 0) {
                    if (createFeedController.selectedIndex == 0 &&
                            createFeedController.captionController.text != "" ||
                        createFeedController.selectedFilePath.value != "") {
                      await createFeedController.CreateNewFeed("addNew", true);
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
                      if (createFeedController.selectedThumbnailPath.value ==
                              "" &&
                          createFeedController.generatedThumNail.value == "") {
                        Toaster().warning("please select thumbnail");
                      } else {
                        await createFeedController.CreateNewFeed(
                            "addNew", true);
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
                  myFocus.unfocus();

                  if (createFeedController.selectedFilePath.value != "" ||
                      createFeedController.selectedThumbnailPath.value != "" ||
                      createFeedController.captionController.text != "") {
                    postAddDraftMethod();
                  } else {
                    Toaster().warning("Please add Some data");
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: Insets.i20, vertical: Insets.i10),
                  padding: const EdgeInsets.all(Insets.i5),
                  width: Get.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: MyColors.blackColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Insets.i10),
                    child: MyText(
                      text_name: "Save as Draft",
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
      ),
    );
  }

  ShowMyBottomSheet(context, _image, selectedInd) {
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
                    Get.back();
                    createFeedController.cameraPick();
                  } else if (createFeedController.selectedIndex == 1 ||
                      createFeedController.selectedIndex == 2) {
                    Get.offAll(() => CameraPage(
                          mediaURL: createFeedController.selectedFilePath.value,
                          caption: createFeedController.captionController.text,
                          thumbnailURL:
                              createFeedController.selectedThumbnailPath.value,
                          selectedType: createFeedController.selectedIndex ?? 1,
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

  Future<void> getImage(_image) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Get.back();
    }
  }

  //Add post in draft
  List<String> draftlist = [];
  List<String> draftlocallist = [];

  Future<void> postAddDraftMethod() async {
    draftlist = [];
    if (createFeedController.isSelectedtype.value == "Read" ||
        createFeedController.isSelectedtype.value == "read") {
      // if (createFeedController.selectedFilePath.value != "") {
      createFeedController.update();

      var a = {
        "image": createFeedController.selectedFilePath.value,
        "detail": createFeedController.captionController.text,
        "isPrivate": createFeedController.isFeedPrivate.value,
      };
      final SharedPreferences prefs = await SharedPreferences.getInstance();

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
      if (createFeedController.selectedFilePath.value == "") {
        var a;

        a = {
          "image": "",
          "videopath": createFeedController.selectedFilePath.value,
          "detail": createFeedController.captionController.text,
          "thumbnailURL": createFeedController.selectedThumbnailPath.value == ""
              ? createFeedController.generatedThumNail.value
              : createFeedController.selectedThumbnailPath.value,
          "duration": "0:0",
          "isPrivate": createFeedController.isFeedPrivate.value,
          // "${_controller.value.duration.inHours}:${_controller.value.duration.inMinutes}:${_controller.value.duration.inSeconds}",
        };
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final List<String>? items1 =
            prefs.getStringList(MyStorage.draftwatchlist) ?? [];

        draftlocallist = items1 != null ? items1 : [];

        draftlocallist.add(json.encode(a));

        await prefs.setStringList(MyStorage.draftwatchlist, draftlocallist);

        createFeedController.selectedFilePath.value = "";
        createFeedController.captionController.clear();
        createFeedController.selectedFileFramePath.value = "";

        Toaster().warning("Post added in draft successfully");
        Get.off(() => UserdraftlistScreen(
              navKey: 1,
            ));
      } else {
        await setFile(createFeedController.selectedFilePath.value);
      }

      // }
    } else if (createFeedController.isSelectedtype.value == "Podcast") {
      draftlocallist = [];

      var data = {
        "image": "",
        "audioPath": createFeedController.selectedFilePath.value,
        "detail": createFeedController.captionController.text == ""
            ? ""
            : createFeedController.captionController.text,
        "thumbnailURL": createFeedController.selectedThumbnailPath.value == ""
            ? createFeedController.generatedThumNail.value
            : createFeedController.selectedThumbnailPath.value,
        "isPrivate": createFeedController.isFeedPrivate.value,
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

  copyImagevideo(file, filename) async {
    final appDir = await getApplicationDocumentsDirectory();
    final savedImage = await file.copy('${appDir.path}/$filename');
    return savedImage;
  }

  @override
  void dispose() {
    createFeedController.selectedFilePath.value = "";
    createFeedController.captionController.clear();
    createFeedController.selectedFileFramePath.value = "";
    super.dispose();
  }

  late VideoPlayerController _controller;
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = (hours < 10) ? '0$hours' : '$hours';
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr =
        (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';

    return '$hoursStr:$minutesStr:$secondsStr';
  }

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
            "duration": formatTime(_controller.value.duration.inSeconds),
            "isPrivate": createFeedController.isFeedPrivate.value,
            // "${_controller.value.duration.inHours}:${_controller.value.duration.inMinutes}:${_controller.value.duration.inSeconds}",
          };
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          final List<String>? items1 =
              prefs.getStringList(MyStorage.draftwatchlist) ?? [];

          draftlocallist = items1 != null ? items1 : [];

          draftlocallist.add(json.encode(a));

          await prefs.setStringList(MyStorage.draftwatchlist, draftlocallist);

          createFeedController.selectedFilePath.value = "";
          createFeedController.captionController.clear();
          createFeedController.selectedFileFramePath.value = "";

          Toaster().warning("Post added in draft successfully");
          Get.off(() => UserdraftlistScreen(
                navKey: 1,
              ));
        });
    } catch (e) {
      Toaster().warning(e.toString());
    }
  }
}
