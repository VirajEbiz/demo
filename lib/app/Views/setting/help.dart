import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/setting/setting_Controller.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/common_text.dart';
import '../../utils/theme/colors.dart';
import '../../widgets/common_widget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    settingController.settingHelpAPI(0);
  }

  SettingController settingController = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.whiteColor,
        appBar: appbarPreferredSize(
          "Terms",
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
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: settingController.aboutAndPrivacyDataList.length,
          itemBuilder: (context, index) {
            return Html(
                data:
                    "${settingController.aboutAndPrivacyDataList[index].content}");
          },
        ),
      ),
    );
  }
}
