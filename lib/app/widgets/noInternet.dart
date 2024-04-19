import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/utils/network.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/common_text.dart';
import '../Views/home_bottom_bar/home_page.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start calling your function every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Call your function here
      checkConnection();
    });
  }

  checkConnection() async {
    bool isInternet = await commonUtil.isNetworkConnection();
    if (isInternet) {
      Get.offAll(() => HomePage());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyText(
        fontWeight: FontWeight.w400,
        text_name: "No Internet",
        txtfontsize: FontSizes.s18,
        txtcolor: MyColors.blackColor,
      ),
    );
  }
}
