import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watermel/app/Views/bookmark/bookmark_list.dart';
import 'package:watermel/app/Views/draft/draftlist.dart';
import 'package:watermel/app/Views/setting/about_us.dart';
import 'package:watermel/app/Views/setting/help.dart';
import 'package:watermel/app/Views/setting/privacy_policy.dart';
import 'package:watermel/app/Views/setting/setting_Controller.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/theme/print.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/common_methods.dart';
import 'package:watermel/app/widgets/common_popup.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/main.dart';
import '../../utils/theme/colors.dart';
import '../../widgets/common_widget.dart';
import '../auth/login_page.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notiStatus = true;
  @override
  void initState() {
    super.initState();

    notiStatus = storage.read(MyStorage.notificationStatus) ?? false;
  }

  SettingController settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      appBar: appbarPreferredSize(
        "Settings",
        true,
      ),
      body: homeBody(),
    );
  }

  homeBody() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
            top: Insets.i15, left: Insets.i25, right: Insets.i25),
        child: Column(
          children: [
            settingTile(
                MyImageURL.Notifications, MyImageURL.ontoggle, "Notification",
                () {
              if (notiStatus) {
                notiStatus = false;
                storage.write("Switch", notiStatus);
              } else {
                notiStatus = true;
                storage.write("Switch", notiStatus);
              }
              settingController.setNOtification();
              setState(() {});
              ();
            }),
            settingTile(MyImageURL.myDraft, "", "My Draft", () {
              Get.to(() => UserdraftlistScreen(
                    navKey: 0,
                  ));
            }),
            settingTile(MyImageURL.privacy, "", "Privacy", () {
              Get.to(() => const privacyPolicyScreen());
            }),
            settingTile(MyImageURL.help, "", "Help", () {
              Get.to(() => const HelpScreen());
            }),
            settingTile(MyImageURL.about, "", "About", () {
              Get.to(() => const aboutUsScreen());
            }),
            settingTile(MyImageURL.bookmark, "", "Bookmark List", () {
              Get.to(() => const BookmarkListView());
            }),
            settingTile(MyImageURL.deleteIcon, "", "Delete Account", () {
              commonDialog(
                context,
                "Delete Account",
                "Are you sure You want to Delete Your Account?",
                onTap: () async {
                  await settingController.deleteUserAccountAPI();
                },
              );
            }),
            settingTile(MyImageURL.logout, "", "Logout", () async {
              commonDialog(
                context,
                "Log out",
                "Are you sure You want to Log out?",
                onTap: () async {
                  await settingController.logOutAPI().whenComplete(() async {
                    /** Mark posts as viewed */
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    List<String> viewedPosts =
                        prefs.getStringList('viewedPosts') ?? [];
                    if (viewedPosts.isNotEmpty) {
                      var formData = {
                        'seed_ids': viewedPosts,
                      };
                      String myUrl = "$baseUrl$markAsSeen";
                      {
                        try {
                          showLoader();
                          var response = await ApiManager()
                              .call(myUrl, formData, ApiType.post);
                          if (response.status == "success") {
                            hideLoader();
                            viewedPosts.clear();
                            prefs.setStringList('viewedPosts', viewedPosts);
                          } else {
                            Toaster().warning(response.message);
                          }
                        } catch (e, f) {
                          hideLoader();
                          log("Chek data ==> $e, $f ");
                          MyPrint(tag: "catch", value: e.toString());
                        }
                      }
                    }

                    CommonMethod()
                        .clearData()
                        .whenComplete(() => Get.offAll(() => LoginPage()));
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /*Common setting widgets*/
  Widget settingTile(
      String asset, String asset1, String title, void Function() onTap,
      {bool isLineIcon = true}) {
    return Column(
      children: [
        InkWell(
          onTap: asset1 != "" ? null : onTap,
          child: Container(
              padding: EdgeInsets.only(
                  left: Get.width * .00,
                  bottom: Get.height * .015,
                  top: Get.height * .015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        asset,
                        color: MyColors.blackColor,
                      ),
                      SizedBox(width: Get.width * 0.06),
                      MyText(
                        txtAlign: TextAlign.center,
                        text_name: title,
                        txtcolor: MyColors.blackColor,
                        myFont: Fonts.poppins,
                        fontWeight: FontWeight.w400,
                        txtfontsize: FontSizes.s14,
                      ),
                    ],
                  ),
                  asset1 != ""
                      ? GestureDetector(
                          onTap: () async {
                            if (notiStatus) {
                              notiStatus = false;
                              storage.write("Switch", notiStatus);
                            } else {
                              notiStatus = true;
                              storage.write("Switch", notiStatus);
                            }
                            await settingController.setNOtification();
                            setState(() {});
                          },
                          child: SvgPicture.asset(
                            notiStatus ? asset1 : MyImageURL.offtoggle,
                          ),
                        )
                      : Container(),
                ],
              )),
        ),
        isLineIcon ? Divider(color: MyColors.lightGrayColor) : Container()
      ],
    );
  }
}
