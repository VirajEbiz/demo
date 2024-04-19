import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:watermel/app/Views/auth/login_page.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/data/apis/friends.dart';
import 'package:watermel/app/data/models/loginModel.dart';
import 'package:watermel/app/data/models/user.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/theme/print.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/common_methods.dart';
import 'package:watermel/main.dart';
import '../../Views/home_bottom_bar/home_page.dart';
import '../../core/helpers/contants.dart';
import '../../utils/preference.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart' as fm;

class AuthMethods {
  Future SignUpUserAPI({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String file,
  }) async {
    try {
      storage.erase();

      showLoader();
      dio.FormData? formData1;
      Map<String, dynamic> jsonDB = {
        'email': email,
        'password': password,
        'username': username,
        'phone_number': phone,
        "device_token": await CommonMethod().deviceToken(),
      };
      jsonDB['file'] = [
        await fm.MultipartFile.fromFile(file, filename: 'profileImage.jpeg')
      ];
      log("request Param=====${jsonDB.toString()}");
      formData1 = dio.FormData.fromMap(jsonDB);
      var response =
          await ApiManager().call("$baseUrl$signUP", formData1, ApiType.post);
      hideLoader();
      if (response.status == "success") {
        // await responseStorage(response.data);
        Toaster().warning(response.message.toString());
        Get.offAll(() => LoginPage());
      } else {
        Toaster().warning(response.message.toString());
      }
    } catch (e) {
      hideLoader();
      MyPrint(tag: "catch", value: e.toString());
    }
  }

  Future logInUser({
    required String email,
    required String password,
  }) async {
    try {
      storage.erase();
      showLoader();
      dio.FormData? formData1;
      Map<String, dynamic> jsonDB = {
        'username_or_email': email,
        'password': password,
        "device_token": await CommonMethod().deviceToken(),
      };

      formData1 = dio.FormData.fromMap(jsonDB);
      MyPrint(tag: "login passing parms ==>", value: jsonDB.toString());
      var response = await ApiManager()
          .call("$baseUrl$userLogin", formData1, ApiType.post);
      hideLoader();
      if (response.status == "success") {
        await responseStorage(response.data);
      } else {
        Toaster().warning(response.message.toString());
      }
    } catch (e) {
      hideLoader();
      MyPrint(tag: "catch", value: e.toString());
    }
  }
}

bool _validateInput(
  String email,
  String password,
  String username,
  String phone,
  Uint8List file,
) {
  return email.isNotEmpty &&
      password.isNotEmpty &&
      username.isNotEmpty &&
      phone.isNotEmpty;
}

bool _validateLoginInput(String email, String password) {
  return email.isNotEmpty && password.isNotEmpty;
}

/*Common login, signup social login API response method */
UserLoginModel _loginModel = UserLoginModel();
responseStorage(response) async {
  _loginModel = await UserLoginModel.fromJson(response);

  if (_loginModel.token != null && _loginModel.token != '') {
    await storage.write(MyStorage.userId, _loginModel.userId.toString());
    await storage.write(MyStorage.email, _loginModel.email.toString());
    await storage.write(MyStorage.userName, _loginModel.username.toString());
    await storage.write(
        MyStorage.displayName, _loginModel.display_name.toString());

    await storage.write(MyStorage.userProfile, _loginModel.userProfile);
    await storage.write(
        MyStorage.notificationStatus, _loginModel.notificationStatus);
    await storage.write(MyStorage.token, _loginModel.token.toString());
    await storage.write(MyStorage.refreshToken, _loginModel.refreshToken);
    Get.offAll(() => HomePage());
  }
}
