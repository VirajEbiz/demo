// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../main.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/fonts.dart';

class CommonMethod {
/*custom loader method*/
  loadermethod() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45
      ..textColor = Colors.transparent
      ..radius = 20
      ..backgroundColor = Colors.transparent
      ..maskColor = Colors.white
      ..indicatorColor = Colors.black
      ..userInteractions = false
      ..dismissOnTap = false
      ..boxShadow = <BoxShadow>[]
      ..indicatorType = EasyLoadingIndicatorType.circle;
  }

  /*Local storage data clear*/
  Future clearData() async {
    await storage.remove('token');
    await storage.remove('userId');
    await storage.remove('email');
    await clearGetStorage();
  }

  clearData2() async {
    await storage.remove('token');
    await storage.remove('userId');
    await storage.remove('email');
    await clearGetStorage();
  }

  clearGetStorage() async {
    await storage.erase();
  }

  /* get device token method*/
  deviceToken() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    return deviceToken;
  }

  /*Venue list effect shimmer*/
  venueListEffect(length) {
    return SizedBox(
      child: ListView.builder(
          itemCount: length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
                baseColor: MyColors.lightGrayColor,
                highlightColor: MyColors.borderColor,
                child: Container(
                  width: Get.width * 0.9,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: MyColors
                        //       .borderColor, //                   <--- border color
                        // ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Get.width * 0.9,
                              height: Get.height * .04,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(06),
                                color: MyColors.lightGrayColor,
                              ),
                            ),
                            SizedBox(
                              height: Get.width * .02,
                            ),
                            Container(
                              height: Get.height * .15,
                              width: Get.width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(06),
                                color: MyColors.lightGrayColor,
                              ),
                            ),
                            SizedBox(
                              height: Get.width * .02,
                            ),
                            SizedBox(
                              height: Get.height * 0.03,
                              width: Get.width * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Insets.i7),
                                child: Container(
                                  height: Get.height * .02,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(06),
                                    color: MyColors.lightGrayColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ));
          }),
    );
  }

  textlength(detail, length) {
    if (detail.length > length) {
      return "${detail.substring(0, length)}....";
    } else {
      return detail;
    }
  }
}
