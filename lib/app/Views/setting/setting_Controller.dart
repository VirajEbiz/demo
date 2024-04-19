import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/auth/login_page.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/models/About_privacy_model.dart';
import 'package:watermel/app/models/help_data_model.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/print.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/main.dart';

class SettingController extends GetxController {
  RxList<HelpDataModelList> helpDataModelList = <HelpDataModelList>[].obs;
  RxList<AboutAndPrivacyDataList> aboutAndPrivacyDataList =
      <AboutAndPrivacyDataList>[].obs;
  Future settingHelpAPI(fromHelp) async {
    helpDataModelList.clear();
    aboutAndPrivacyDataList.clear();

    //! HELP = 0
    //! ABOUT = 1
    //! Privacy = 2
    String myURL = fromHelp == 0
        ? "$baseUrl$terms"
        : fromHelp == 1
            ? "$baseUrl$aboutUS"
            : "$baseUrl$privacy";

    {
      try {
        showLoader();

        var response = await ApiManager().call(myURL, "", ApiType.get);

        if (response.status == "success") {
          if (response.data != null) {
            for (var i = 0; i < response.data.length; i++) {
              aboutAndPrivacyDataList
                  .add(AboutAndPrivacyDataList.fromJson(response.data[i]));
            }
          } else {
            Toaster().warning(response.message);
          }
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();
        // log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

  Future setNOtification() async {
    String myURL = "$baseUrl$notificationSwitch";

    {
      try {
        showLoader();

        var response = await ApiManager().call(myURL, "", ApiType.patch);

        if (response.status == "success") {
          response.message.contains("off")
              ? storage.write(MyStorage.notificationStatus, false)
              : storage.write(MyStorage.notificationStatus, true);
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();

        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

  Future logOutAPI() async {
    String myURL = "$baseUrl$logOut";

    {
      try {
        showLoader();

        var response = await ApiManager().call(myURL, "", ApiType.post);

        if (response.status == "success") {
          Toaster().warning(response.message);
        } else {
          Toaster().warning(response.message);
        }
      } catch (e) {
        hideLoader();
      }
    }
  }

  //! DELETE FEED API CALL
  Future deleteUserAccountAPI() async {
    String myUrl = "$baseUrl$deleteAccount${storage.read(MyStorage.userId)}/";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, "", ApiType.delete);
        if (response.status == "success") {
          Toaster().warning(response.message);
          Get.offAll(() => LoginPage());
          Toaster().warning(response.message);
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }
}
