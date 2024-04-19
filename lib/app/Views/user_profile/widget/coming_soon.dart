import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/home_bottom_bar/homebottom_controller.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';

import '../../../utils/theme/colors.dart';
import '../../../utils/theme/fonts.dart';

class ComingSoonWidget extends StatelessWidget {
  ComingSoonWidget({super.key, required this.fromHome});
  bool? fromHome;
  HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarPreferredSizeAction(
          "",
          true,
          isActionIcon: false,
          "",
          () {},
          backonTap: fromHome == false
              ? null
              : () {
                  log("IN SIDE THE BACK");
                  homeController.pageIndex.value = 0;
                  homeController.update();
                }),
      body: Center(
          child: MyText(
        fontWeight: FontWeight.w400,
        text_name: "Coming Soon",
        txtfontsize: FontSizes.s18,
        txtcolor: MyColors.blackColor,
      )),
    );
  }
}
