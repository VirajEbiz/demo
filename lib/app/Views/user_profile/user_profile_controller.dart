import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as fm;
import 'package:dio/dio.dart' as dio;
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:watermel/app/models/getCommentList_model.dart';
import 'package:watermel/app/models/user_feed_data_model.dart';
import 'package:watermel/app/models/user_feed_podcast_data_model.dart';
import 'package:watermel/app/models/user_feed_watch_data_model.dart';
import 'package:watermel/app/models/user_profile_model.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/main.dart';

import '../../core/helpers/api_manager.dart';
import '../../core/helpers/contants.dart';
import '../../utils/loader.dart';
import '../../utils/theme/print.dart';

class UserProfileController extends GetxController {
  dynamic videourl;
  dynamic playtype;
  RxInt tabIndex = 0.obs;
  RxBool screenScroll = false.obs;

  @override
  void onInit() async {
    tabIndex = 0.obs;
    super.onInit();
    imageFeedData.clear();
    watchFeedData.clear();
    podcastFeedData.clear();
  }

  // Rx<GetUserProfileModule> getUserProfileModel = GetUserProfileModule().obs;
  Rx<UserProfileData> userProfileData = UserProfileData().obs;

  Future getUserprofile(name) async {
    {
      try {
        page = 1;
        showLoader();
        var response = await ApiManager()
            .call('${baseUrl}auth/profile/$name/', "", ApiType.get);
        if (response.status == "success") {
          print("userProfileData............${response.data}");
          userProfileData.value = UserProfileData.fromJson(response.data);
          if (storage.read(MyStorage.userName) == name) {
            storage.write(MyStorage.userProfile,
                "${userProfileData.value.profilePicture}");
            storage.write(
                MyStorage.displayName, userProfileData.value.displayName);
            storage.write(MyStorage.bio, userProfileData.value.bio);
          }

          page = 1;

          userProfileData.value.specificUserPrivacy == false
              ? await getuserFeedData(
                  userProfileData.value.username, "read", true, false, page)
              : null;
          update();
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();

        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

  int page = 1;

  RxList<SeedListData> imageFeedData = <SeedListData>[].obs;
  RxList<WatchSeedDataList> watchFeedData = <WatchSeedDataList>[].obs;
  RxList<PodcastSeedDataList> podcastFeedData = <PodcastSeedDataList>[].obs;
  int totalFeedPage = 0;
  int currentFeedPage = 0;
  Rx<int> currentFollowersPage = 1.obs;
  Rx<int> totalFollowersPage = 1.obs;
  Rx<int> currentFollowingPage = 1.obs;
  Rx<int> totalFollowingPage = 1.obs;
  RxList<UserProfileData> followersList = <UserProfileData>[].obs;
  RxList<UserProfileData> followingList = <UserProfileData>[].obs;

  Future getuserFeedData(
      userName, type, fromFirstTime, fromPagination, page) async {
    showLoader();
    if (fromFirstTime == true) {
      imageFeedData.value = [];
      watchFeedData.value = [];
      podcastFeedData.value = [];
      imageFeedData.refresh();
      watchFeedData.refresh();
      podcastFeedData.refresh();
    }
    // var data = FormData();

    // fm.FormData formData = fm.FormData.fromMap(
    //   {'username': userName, "type": type, 'page': page},
    // );
    var jsonDB = {'username': userName, "type": type, 'page': page};
    dio.FormData formData1 = dio.FormData.fromMap(jsonDB);

    {
      print("request param........${type}.....${jsonDB}");
      try {
        showLoader();

        var response = await ApiManager()
            .call('$baseUrl$userFeed', formData1, ApiType.post);
        log("chel data ==> ${response.status}");
        if (response.status == "success") {
          totalFeedPage = response.data["total_pages"];
          currentFeedPage = response.data["current_page"];
          if (type == "read") {
            for (var i = 0; i < response.data["seeds"].length; i++) {
              imageFeedData
                  .add(SeedListData.fromJson(response.data["seeds"][i]));
            }
            imageFeedData.refresh();
          } else if (type == "watch") {
            for (var i = 0; i < response.data["seeds"].length; i++) {
              watchFeedData
                  .add(WatchSeedDataList.fromJson(response.data["seeds"][i]));
            }
            watchFeedData.refresh();
            update();
            hideLoader();
          } else {
            for (var i = 0; i < response.data["seeds"].length; i++) {
              podcastFeedData
                  .add(PodcastSeedDataList.fromJson(response.data["seeds"][i]));
            }

            hideLoader();
          }
          podcastFeedData.refresh();
          print(
              "imageFeedData............${watchFeedData.length}..>${imageFeedData.length}");
          update();
          // Toaster().warning(response.message);
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

  RxString selectedFilePath = "".obs;

  TextEditingController displayNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  RxBool isPrivate = false.obs;

  final picker = ImagePicker();
  selectImage() async {
    var result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      // Get.back();
      selectedFilePath.value = result.path;
      isImageSelect = true;
    }
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'jpeg', 'png'],
    // );

    //  selectedFilePath.value = result!.files.single.path!;
  }

  bool isImageSelect = false;

  Future EditProfile() async {
    log("IN SIDE THE EDIT PROFILE ");
    try {
      showLoader();
      dio.FormData? formData1;
      if (selectedFilePath.value != "") {
        Map<String, dynamic> jsonDB = {
          'display_name': displayNameController.text,
          'bio': bioController.text,
          'is_private': isPrivate.value,
        };
        jsonDB['profile_picture'] = [
          await fm.MultipartFile.fromFile(selectedFilePath.value,
              filename: 'profileImage.jpeg')
        ];
        log("request Param=====${jsonDB.toString()}");
        formData1 = dio.FormData.fromMap(jsonDB);
      } else {
        Map<String, dynamic> jsonDB = {
          'display_name': displayNameController.text,
          'bio': bioController.text,
          'is_private': isPrivate.value,
        };

        log("request Param=====${jsonDB.toString()}");
        formData1 = dio.FormData.fromMap(jsonDB);
      }

      var response = await ApiManager()
          .call("$baseUrl$userProfile", formData1, ApiType.put);
      hideLoader();
      if (response.status == "success") {
        storage.write(MyStorage.Accout_IsPrivate, response.data["is_private"]);
        storage.write(MyStorage.displayName, response.data["display_name"]);
        storage.write(MyStorage.userProfile, response.data["profile_picture"]);
        storage.write(MyStorage.bio, response.data["bio"]);
        isPrivate.value = response.data["is_private"];
        await getUserprofile(storage.read(MyStorage.userName));
        Get.back(closeOverlays: true);
        // Toaster().warning(response.message.toString());
      } else {
        Toaster().warning(response.message.toString());
      }
    } catch (e) {
      hideLoader();
      MyPrint(tag: "catch", value: e.toString());
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
          await getUserprofile(userName);
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

  Future bookMarkTheFeed(feedID, ind) async {
    log("");
    fm.FormData formData = fm.FormData.fromMap(
      {'seed': feedID, 'is_bookmarked': true},
    );

    log("Check passing data==> ${formData.fields.first.value}");
    log("Check passing data==> ${formData.fields[1].value}");
    String myUrl = "$baseUrl$bookMarkFeed";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          if (tabIndex.value == 0) {
            // imageFeedData[ind].s =
            //             homeFeedList[ind].bookmark == true ? false : true;
            //         homeFeedList.refresh();
          }
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

  TextEditingController commentController = TextEditingController();

  Future addComment(feedID, ind) async {
    fm.FormData formData = fm.FormData.fromMap(
      {'seed': feedID, 'comment': commentController.text},
    );
    String myUrl = "$baseUrl$addComent";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          // int temp = homeFeedList[ind].commentsCount ?? 0;
          // temp++;
          // homeFeedList[ind].commentsCount = temp;
          // homeFeedList.refresh();
          // commentController.clear();
          await getComment(feedID, false);
          hideLoader();
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

  RxList<GetCommentListDataModel> getCommentListDataModel =
      <GetCommentListDataModel>[].obs;

  Future getComment(feedID, fromMain) async {
    if (fromMain) {
      getCommentListDataModel.clear();
      getCommentListDataModel.refresh();
    }
    String myUrl = "$baseUrl$getCommentEndPoint$feedID/";
    print("My URL ==> ${myUrl}");
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, "", ApiType.get);
        if (response.status == "success") {
          getCommentListDataModel.clear();

          for (var i = 0; i < response.data["comments"].length; i++) {
            getCommentListDataModel.add(
                GetCommentListDataModel.fromJson(response.data["comments"][i]));
          }
          getCommentListDataModel.refresh();
          hideLoader();
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

  Future reactionAPI(feedID, ind) async {
    fm.FormData formData = fm.FormData.fromMap(
      {'seed': feedID, 'reaction_type': 'love'},
    );
    String myUrl = "$baseUrl$like";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          // if (response.message.contains("removed")) {
          //   homeFeedList[ind].myReaction = null;
          //   int temp = homeFeedList[ind].reactionsCount ?? 1;
          //   temp--;
          //   homeFeedList[ind].reactionsCount = temp;
          //   homeFeedList.refresh();
          // } else {
          //   homeFeedList[ind].myReaction = "love";
          //   int temp = homeFeedList[ind].reactionsCount ?? 1;
          //   temp++;
          //   homeFeedList[ind].reactionsCount = temp;
          //   homeFeedList.refresh();
          // }
        } else {
          Toaster().warning(response.message);
        }
        // homeFeedList.refresh();
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

  Future getFollowersList() async {
    followersList.clear();

    String formData = "";
    String myUrl =
        "$baseUrl$follow?follow_network=followers&page=${currentFollowersPage.value}";

    try {
      showLoader();

      var response = await ApiManager().call(myUrl, formData, ApiType.get);
      if (response.status == "success") {
        final responseList = response.data["follow_network"];
        for (var i = 0; i < responseList.length; i++) {
          followersList.add(UserProfileData.fromFollowerJson(responseList[i]));
        }

        hideLoader();
      } else {
        Toaster().warning(response.message);
      }
    } catch (e, f) {
      hideLoader();
      log("Chek data ==> $e, $f ");
      MyPrint(tag: "catch", value: e.toString());
    }
  }

  Future getFollowingList() async {
    followingList.clear();

    String formData = "";
    String myUrl =
        "$baseUrl$follow?follow_network=following&page=${currentFollowingPage.value}";

    try {
      showLoader();

      var response = await ApiManager().call(myUrl, formData, ApiType.get);
      if (response.status == "success") {
        final responseList = response.data["follow_network"];
        for (var i = 0; i < responseList.length; i++) {
          followingList.add(UserProfileData.fromFollowingJson(responseList[i]));
        }

        hideLoader();
      } else {
        Toaster().warning(response.message);
      }
    } catch (e, f) {
      hideLoader();
      log("Chek data ==> $e, $f ");
      MyPrint(tag: "catch", value: e.toString());
    }
  }

  Future removeFollower({required int id}) async {
    String formData = "";
    String myUrl = "$baseUrl$follow$id/";
    try {
      showLoader();

      var response = await ApiManager().call(myUrl, formData, ApiType.delete);
      if (response.status == "success") {
        hideLoader();
        return response.code;
      } else {
        Toaster().warning(response.message);
      }
    } catch (e, f) {
      hideLoader();
      log("Chek data ==> $e, $f ");
      MyPrint(tag: "catch", value: e.toString());
    }
  }
}
