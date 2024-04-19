import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watermel/app/Views/setting/setting_Controller.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import '../../utils/theme/colors.dart';
import '../../widgets/common_widget.dart';

class privacyPolicyScreen extends StatefulWidget {
  const privacyPolicyScreen({super.key});

  @override
  State<privacyPolicyScreen> createState() => _privacyPolicyScreenState();
}

class _privacyPolicyScreenState extends State<privacyPolicyScreen> {
  var _scrollController = ScrollController();
  SettingController settingController = Get.find<SettingController>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    settingController.aboutAndPrivacyDataList.clear();
    await settingController.settingHelpAPI(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.whiteColor,
        appBar: appbarPreferredSize(
          "Privacy Policy",
          true,
        ),
        body: Obx(
          () => settingController.aboutAndPrivacyDataList.isEmpty ||
                  settingController.aboutAndPrivacyDataList == null
              ? MyNoRecord()
              : SingleChildScrollView(
                  child: homeBody(),
                ),
        ));
  }

  homeBody() {
    return Container(
      margin: const EdgeInsets.only(
          top: Insets.i15, left: Insets.i25, right: Insets.i25),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        itemCount: settingController.aboutAndPrivacyDataList.length,
        itemBuilder: (context, index) {
          return Html(
              onAnchorTap: (url, attributes, element) async {
                if (!await launchUrl(Uri.parse(url!))) {
                  throw Exception('Could not launch $url');
                }
              },
              data:
                  "${settingController.aboutAndPrivacyDataList[index].content}");
        },
      ),
    );
  }
}
