import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/utils/theme/colors.dart';

class MyCustomDivider extends StatelessWidget {
  MyCustomDivider({super.key, required this.sized});
  double? sized;
  HomeFeedController homeFeedController = Get.find<HomeFeedController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: sized ?? 10.0,
        ),
        Divider(
          color: MyColors.grayColor.withOpacity(.5),
        ),
        // ),
        SizedBox(
          height: sized ?? 10.0,
        ),
      ],
    );
  }
}

class MyCustomDivider2 extends StatelessWidget {
  MyCustomDivider2({super.key, required this.sized});
  double? sized;
  HomeFeedController homeFeedController = Get.find<HomeFeedController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: sized ?? 10.0,
        ),
        Divider(
          color: MyColors.grayColor.withOpacity(.5),
        ),
        SizedBox(
          height: sized ?? 10.0,
        ),
      ],
    );
  }
}
