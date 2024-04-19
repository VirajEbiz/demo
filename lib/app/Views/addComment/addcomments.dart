import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/main.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/fonts.dart';

openCommentlistModel(context, feedID, fromProfile, {ind}) {
  ScrollController _scrollController = ScrollController();

  HomeFeedController homeFeedController = Get.find<HomeFeedController>();
  homeFeedController.commentController.clear();

  bool onNotificationHr(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        homeFeedController.currentCommentPage++;

        if (homeFeedController.currentCommentPage.value <=
            (homeFeedController.totalCommentPage.value)) {
          homeFeedController.getComment(feedID).whenComplete(() async {
            homeFeedController.getCommentListDataModel.refresh();
          });
        } else {}
      }
    }
    return true;
  }

  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: MyColors.whiteColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: EdgeInsets.only(
                top: 0,
                right: 0,
                left: 0,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: NotificationListener(
              onNotification: onNotificationHr,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: Insets.i15,
                        bottom: Insets.i70,
                        left: Insets.i20,
                        right: Insets.i20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              //  authCtrl.forgotPasswordAPI(context);
                            },
                            child: Container(
                              width: Get.width * 0.2,
                              height: 3,
                              decoration: BoxDecoration(
                                  color: MyColors.blackColor,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Insets.i10,
                        ),
                        Container(
                          // color: Colors.red,
                          height: Get.height * 0.35,
                          child: Obx(
                            () => ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: ScrollPhysics(),
                                itemCount: homeFeedController
                                    .getCommentListDataModel.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 45,
                                              width: 45,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CustomImageView(
                                                    isProfilePicture: true,
                                                    imagePathOrUrl:
                                                        "${homeFeedController.getCommentListDataModel[index].user!.userprofile!.profilePicture}"
                                                                .contains(
                                                                    "null")
                                                            ? ""
                                                            : "${homeFeedController.getCommentListDataModel[index].user!.userprofile!.profilePicture}",
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: Insets.i10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    MyText(
                                                      text_name: homeFeedController
                                                              .getCommentListDataModel[
                                                                  index]
                                                              .user
                                                              ?.userprofile
                                                              ?.displayName ??
                                                          "",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      txtfontsize:
                                                          FontSizes.s13,
                                                    ),
                                                    MyText(
                                                      text_name:
                                                          "  ${homeFeedController.timeDiffrance(homeFeedController.getCommentListDataModel[index].createdAt)}",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      txtfontsize:
                                                          FontSizes.s12,
                                                      txtcolor:
                                                          MyColors.grayColor,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width * 0.6,
                                                        child: MyText(
                                                          txtAlign:
                                                              TextAlign.left,
                                                          text_name:
                                                              //  "skjfjk hakjfhkja haskfhjksh kjsahhbfhfksfhj",
                                                              "${homeFeedController.getCommentListDataModel[index].comment ?? ""}",
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          txtfontsize:
                                                              FontSizes.s13,
                                                        ),
                                                      ),
                                                      // MyText(
                                                      //   text_name: "Replay",
                                                      //   fontWeight: FontWeight.w400,
                                                      //   txtfontsize: FontSizes.s12,
                                                      //   txtcolor: MyColors.grayColor,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                homeFeedController
                                                    .commentReactionAPI(
                                                        homeFeedController
                                                            .getCommentListDataModel[
                                                                index]
                                                            .commentID,
                                                        index);
                                              },
                                              child: SizedBox(
                                                  height: Insets.i20,
                                                  width: Insets.i20,
                                                  child: SvgPicture.asset(
                                                      homeFeedController
                                                                  .getCommentListDataModel[
                                                                      index]
                                                                  .userReaction !=
                                                              null
                                                          ? MyImageURL
                                                              .LikedImage
                                                          : MyImageURL.like)),
                                            ),
                                            MyText(
                                              text_name:
                                                  "${homeFeedController.getCommentListDataModel[index].commentReactionCount} likes",
                                              fontWeight: FontWeight.w400,
                                              txtfontsize: FontSizes.s12,
                                              txtcolor: MyColors.grayColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: Insets.i12,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(Insets.i20),
                            child: TextFormField(
                              controller: homeFeedController.commentController,
                              autofocus: false,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                  fontFamily: Fonts.poppins,
                                  fontWeight: FontWeight.w400,
                                  fontSize: FontSizes.s16,
                                  color: MyColors.blackColor),
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(Insets.i15),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CustomImageView(
                                          isProfilePicture: true,
                                          imagePathOrUrl:
                                              "$baseUrl${storage.read(MyStorage.userProfile)}"
                                                      .contains("null")
                                                  ? ""
                                                  : "$baseUrl${storage.read(MyStorage.userProfile)}",
                                        )),
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xffEDEDED),
                                hintText: 'Add a comment...',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: Insets.i20),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: MyColors.grayColor),
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: MyColors.grayColor),
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: MyColors.grayColor),
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(19),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.linear,
                            );
                            homeFeedController.commentController.text == "" ||
                                    homeFeedController.commentController.text ==
                                        ""
                                ? Toaster().warning("Please add comment")
                                : homeFeedController.addComment(feedID,
                                    fromprofile: fromProfile,
                                    ind: ind,
                                    fromAddComment: true);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: Insets.i36,
                            width: Insets.i36,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.lightGray),
                            child: const Icon(Icons.send),
                          ),
                        ),
                        SizedBox(
                          width: Insets.i20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
      });
}
