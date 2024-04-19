import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/models/motification_Model.dart';
import '../../core/helpers/api_manager.dart';
import '../../core/helpers/contants.dart';
import 'package:dio/dio.dart' as fm;
import '../../utils/loader.dart';
import '../../utils/theme/print.dart';
import '../../utils/toast.dart';

class FollowController extends GetxController {
  Future acceptFollowReqAPI(userId, fromNotification) async {
    String myUrl = "$baseUrl$acceptFollowReq$userId/";
    {
      try {
        showLoader();
        var response = await ApiManager().call(myUrl, "", ApiType.put);
        if (response.status == "success") {
          fromNotification == true ? Get.back() : null;
          Toaster().warning(response.message);
          update();
        } else if (response.code == "000") {
          await acceptFollowReqAPI(userId, fromNotification);
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

  Future rejectFollowReqAPI(userId, fromNotification) async {
    String myUrl = "$baseUrl$acceptFollowReq$userId/";
    {
      try {
        showLoader();
        var response = await ApiManager().call(myUrl, "", ApiType.delete);
        if (response.status == "success") {
          fromNotification == true ? Get.back() : null;
          Toaster().warning(response.message);
          return true;
        } else if (response.code == "000") {
          await rejectFollowReqAPI(userId, fromNotification);
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

  Future FollowTheUsesr(
    userName,
  ) async {
    fm.FormData formData = fm.FormData.fromMap(
      {'username': userName},
    );
    String myUrl = "$baseUrl$follow";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          Toaster().warning(response.message);
        } else if (response.code == "000") {
          await FollowTheUsesr(userName);
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

  RxList<NotificationList> notificationListData = <NotificationList>[].obs;
  int pageNo = 1;
  int currentPage = 1;
  /*Notification list API*/
  getNotificationListAPI() async {
    String myUrl = "$baseUrl$notificationList$currentPage";
    {
      try {
        showLoader();
        var response = await ApiManager().call(myUrl, "", ApiType.get);
        if (response.status == "success") {
          pageNo = response.data["total_pages"];
          currentPage = response.data["current_page"];
          for (var i = 0; i < response.data["notifications"].length; i++) {
            notificationListData.add(
                NotificationList.fromJson(response.data["notifications"][i]));
          }
          final homefeedController = Get.put(HomeFeedController());
          homefeedController.getNotificationCountAPI(3);
          log("Notification Count ==> ${notificationList.length}");
        } else if (response.code == "000") {
          await getNotificationListAPI();
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
