import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';

class ReposTheFeedView extends StatelessWidget {
  ReposTheFeedView(
      {super.key,
      required this.thumnailURL,
      required this.caption,
      required this.feedID});
  String? thumnailURL;
  String? caption;
  String? feedID;
  final repostKey = GlobalKey<FormState>();
  FocusNode repostFocus = FocusNode();
  TextEditingController repostCaptionController = TextEditingController();
  HomeFeedController homeFeedController = Get.put(HomeFeedController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appbarPreferredSize(
        "Repost The Feed",
        true,
        isRightIcon: false,
        isRightText: true,
        backonTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                    child: SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: CustomImageView(
                            isProfilePicture: false,
                            fit: BoxFit.cover,
                            radius: Insets.i5,
                            imagePathOrUrl: thumnailURL))),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Insets.i20),
              alignment: Alignment.centerLeft,
              child: MyText(
                text_name: caption,
                txtcolor: MyColors.grayColor,
                fontWeight: FontWeight.w500,
                txtfontsize: FontSizes.s12,
                txtAlign: TextAlign.left,
              ),
            ),
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
                    focusNode: repostFocus,
                    cursorColor: Colors.black,
                    maxLines: 6,
                    controller: repostCaptionController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(Insets.i20),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.grayColor),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Re-Post Description',
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
            InkWell(
              onTap: () async {
                repostFocus.unfocus();
                homeFeedController.repostTheFeedAPI(
                    feedID, repostCaptionController.text);
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
                    text_name: "Re-Post",
                    txtcolor: MyColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    txtfontsize: FontSizes.s16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
