import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/repostFeed/repost_view.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/common_text.dart';

ShowShareBottomSheet(context, feedID, feedLink, caption, thumnail) {
  HomeFeedController homeFeedController = Get.put(HomeFeedController());
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
                      text_name: "Share",
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
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                // physics: userProfileController.screenScroll.value == true
                //     ? NeverScrollableScrollPhysics()
                //     : AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: 6,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisExtent: Get.height * 0.1),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      if (index == 0) {
                        //! PERFORM SOMETHING - ON MESSAGE
                        Toaster().warning("Coming Soon.");
                      }
                      if (index == 1) {
                        //! PERFORM SOMETHING - ON FEED
                        Get.back(closeOverlays: true);
                        Get.to(() => ReposTheFeedView(
                              caption: caption,
                              thumnailURL: thumnail,
                              feedID: feedID.toString(),
                            ));
                      }
                      if (index == 2) {
                        //! PERFORM SOMETHING - ON WTSP
                        SocialShare.shareWhatsapp(feedLink);
                      }
                      if (index == 3) {
                        //! PERFORM SOMETHING - ON COPY LINK

                        Clipboard.setData(ClipboardData(text: feedLink));

                        Toaster().warning("Copied: $feedLink");
                      }
                      if (index == 4) {
                        //! PERFORM SOMETHING - ON STORY
                        Toaster().warning("Coming Soon.");
                      }
                      if (index == 5) {
                        //! PERFORM SOMETHING - ON SMS
                        SocialShare.shareSms(feedLink);
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          shareTypeIcons[index]["image"]!,
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(
                          width: Insets.i10,
                        ),
                        MyText(
                          txtAlign: TextAlign.start,
                          text_name: shareTypeIcons[index]["name"],
                          fontWeight: FontWeight.w400,
                          txtcolor: MyColors.grayColor,
                          txtfontsize: FontSizes.s14,
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      );
    },
  );
}

List<Map<String, String>> shareTypeIcons = <Map<String, String>>[
  {"name": "Message", "image": MyImageURL.shareMessage},
  {"name": "Feed", "image": MyImageURL.shareFeed},
  {"name": "WhatsApp", "image": MyImageURL.shareWtsp},
  {"name": "Copy Link", "image": MyImageURL.shareCopyLink},
  {"name": "Story", "image": MyImageURL.shareStory},
  {"name": "SMS", "image": MyImageURL.shareSMS},
];
void navigateToMessengerWithText(String text) async {
  final url = 'fb-messenger://share?text=${Uri.encodeFull(text)}';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}
