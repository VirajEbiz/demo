import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/auth/login_page.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/main.dart';
import 'package:dio/dio.dart' as refreshData;
import 'package:dio/dio.dart' as fm;
import '../../utils/loader.dart';
import '../../utils/network.dart';
import '../../utils/theme/print.dart';
import '../../utils/toast.dart';
import '../../widgets/common_methods.dart';
import 'package:dio/dio.dart' as dd;
import 'api_response.dart';
import 'contants.dart';

Dio dio = Dio();

enum ApiType { get, post, put, delete, getWithBody, patch }

class ApiManager {
  Future get(String endpoint) async {
    try {
      dynamic response = await dio.get(endpoint);
      return response.data;
    } catch (e) {
      // log(e.toString());
    }
  }

  ApiManager() {
    dio.options
      ..baseUrl = baseUrl
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {
        'Accept': 'application/json',
        if (storage.read(MyStorage.token) != null)
          'Authorization': "Bearer ${storage.read(MyStorage.token)}",
        'content-type': 'application/json'
      };
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.next(options),
        onResponse: (response, handler) => handler.next(response),
        onError: (DioError e, handler) {
          if (kDebugMode) {}
          _errorThrow(e);
          return handler.next(e);
        },
      ),
    );
  }

  // ignore: missing_return
  Future<APIResponse> call(String apiName, body, type) async {
    APIResponse? apiData = APIResponse(
        code: 1,
        message: "Something went wrong, Please wait".tr,
        status: "error",
        data: null);

    try {
      bool isInternet = await commonUtil.isNetworkConnection();
      log("API name........${apiName}");
      if (isInternet) {
        try {
          String? token = await MyStorage.read(MyStorage.token);

          dio.options.headers["Content-Type"] = "application/json";

          dynamic response;
          switch (type) {
            case ApiType.post:
              response = await dio.post(apiName, data: body);
              break;
            case ApiType.delete:
              response = await dio.delete(apiName, data: body);
              break;
            case ApiType.get:
              response = await dio.get(
                apiName,
              );
              break;
            case ApiType.patch:
              response = await dio.patch(apiName);
            case ApiType.getWithBody:
              response = await dio.get(apiName, data: body);
            case ApiType.put:
              response = await dio.put(apiName, data: body);
              break;
          }
          apiData = await checkStatus(response, apiName);
          return apiData!;
        } catch (e) {
          hideLoader();

          // toaster.success("Something went wrong!");
          return apiData!;
        }
      } else {
        hideLoader();

        // toaster.success("Something went wrong!");
        return apiData;
      }
    } on SocketException catch (e) {
      onSocketException(e);
      return apiData!;
    } on Exception catch (e) {
      onException(e);
      return apiData!;
    } catch (e) {
      hideLoader();

      // toaster.success("Something went wrong!");
      return apiData!;
    }
  }

  int temp = 0;

  //#region functions
  Future<APIResponse?> checkStatus(response, apiName) async {
    log("response ${response.toString()}");
    MyPrint(
        tag: "statusCode =111=> ${apiName}",
        value: "${response.statusCode.toString()}");

    hideLoader();
    // appCtrl.hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data["code"] == 422 ||
          response.data["code"] == 400 ||
          response.data["code"] == 401 ||
          response.data["code"] == 500 ||
          response.data["code"] == 404) {
        if (response.data['message'] == "unauthorized") {
          await setRefreshTokenAPI();
        } else {
          return APIResponse(
            code: response.data['code'],
            status: response.data['status'],
            message: response.data['message'],
            data: response.data['data'],
            total_pages: response.data['total_pages'],
            notificationCount: response.data["notif_unread_count"],
          );
        }
      } else {
        return APIResponse(
          code: response.data['code'],
          status: response.data['status'],
          notificationCount: response.data["notif_unread_count"],
          message: response.data['message'],
          data: response.data['data'],
          total_pages: response.data['total_pages'],
        );
      }
    } else if (response.statusCode == 413) {
      Toaster().warning("File size issue! something went wrong...");
    } else if (response.data["code"] == 422 ||
        response.data["code"] == 400 ||
        response.data["code"] == 401 ||
        response.data["code"] == 500 ||
        response.data["code"] == 404) {
      if (response.data['message'] == "unauthorized") {
        await setRefreshTokenAPI();
      } else {
        return APIResponse(
          code: response.data['code'],
          status: response.data['status'],
          notificationCount: response.data["notif_unread_count"],
          message: response.data['message'],
          data: response.data['data'],
          total_pages: response.data['total_pages'],
        );
      }
    } else {
      return APIResponse(
        code: response.data['code'],
        status: response.data['status'],
        notificationCount: response.data["notif_unread_count"],
        message: response.data['message'],
        data: response.data['data'],
        total_pages: response.data['total_pages'],
      );
    }
  }

  Future setRefreshTokenAPI({fromMain}) async {
    storage.write(MyStorage.token, null);
    String refreshToeken = await storage.read(MyStorage.refreshToken);
    print("Passing refresh token check ==> ${refreshToeken}");
    print(
        "Passing refresh token check ==> storage ${await storage.read(MyStorage.refreshToken)}");
    refreshData.FormData? formData1;
    Map<String, dynamic> jsonDB = {
      'refresh':
          refreshToeken == null || refreshToeken == "" ? "" : refreshToeken,
    };
    formData1 = refreshData.FormData.fromMap(jsonDB);

    String myUrl = "$baseUrl$setRefreshToken";

    try {
      var response = await ApiManager().call(myUrl, formData1, ApiType.post);

      if (response.status == "success") {
        await storage.write(MyStorage.token, response.data["access_token"]);
        await storage.write(
            MyStorage.refreshToken, response.data["refresh_token"]);
        var token = await MyStorage.read(MyStorage.token);
        var refresh = await MyStorage.read(MyStorage.refreshToken);
        if (token != null && refresh != null && token != "" && refresh != "") {
          Get.offAll(() => HomePage());
        } else {
          CommonMethod().clearGetStorage();
          Get.offAll(() => LoginPage());
        }
      } else {
        CommonMethod().clearGetStorage();
        Get.offAll(() => LoginPage());
      }
    } catch (e) {
      MyPrint(tag: "CHCECK ERROR", value: "$e");
    }
  }

  onSocketException(e) => log("API : SocketException - ${e.toString()}");

  onException(e) => log("API : Exception - ${e.toString()}");

  _errorThrow(DioError err) async {
    var errorShow = {
      "StatusMessage": err.response!.statusMessage,
      "Status": err.response!.statusCode,
      "Api": err.response!.realUri,
    };
    throw Exception(errorShow);
  }

  _errorShow(response, apiName) async {
    var errorShow = {
      "StatusMessage": response.statusMessage,
      "Status": response.statusCode,
      "Api": "${baseUrl}$apiName",
    };
    if (response != null &&
        errorShow["Status"] != null &&
        errorShow["Status"] == 401) {}
  }
}
