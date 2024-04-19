import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';

class EditPostScreen extends StatefulWidget {
  EditPostScreen(
      {super.key,
      required this.postType,
      required this.feedId,
      this.mediaURL,
      this.caption,
      required this.isPrivate,
      this.thumbnailURL});
  //! 0 = Read, 1 = watch, 2 = podcast

  int postType, feedId;
  String? mediaURL, thumbnailURL, caption;
  bool isPrivate;

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  CreateFeedController createFeedController = Get.put(CreateFeedController());

  @override
  void initState() {
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
        Get.back();
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => createFeedController.selectedFilePath.value != ""
                ? Padding(
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: SizedBox(
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
                                      imagePathOrUrl:
                                          createFeedController.selectedIndex ==
                                                  0
                                              ? createFeedController
                                                  .selectedFilePath.value
                                              : "",
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox()),
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
                final postTypes = [
                  "read",
                  "watch",
                  "podcast",
                ];
                HomeFeedController homeFeedController =
                    Get.find<HomeFeedController>();
                await homeFeedController.editPost(
                    widget.feedId,
                    createFeedController.captionController.text,
                    postTypes[widget.postType],
                    widget.isPrivate);
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
            SizedBox(
              height: Insets.i30,
            ),
          ],
        ),
      ),
    );
  }
}
