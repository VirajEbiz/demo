import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart' as fm;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:path/path.dart' as path;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/Views/user_profile/profile_detail_screen.dart';
import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/models/detail_post_data_model.dart';
import 'package:watermel/app/models/getCommentList_model.dart';
import 'package:watermel/app/models/getPeopleKnowData_model.dart';
import 'package:watermel/app/models/getallfeedmodel.dart';
import 'package:watermel/app/models/hashtag_model.dart';
import 'package:watermel/app/models/hetsearchedusedata_model.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/theme/print.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/main.dart';

class HomeFeedController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    buttonList = [
      {
        "ButtonName": "Read",
        "ButtonIcon": MyImageURL.readText,
        "IsSelected": 0
      },
      {"ButtonName": "Watch", "ButtonIcon": MyImageURL.watch, "IsSelected": 1},
      {
        "ButtonName": "Podcast",
        "ButtonIcon": MyImageURL.podcast,
        "IsSelected": 2
      },
    ];

    final userProfileController = Get.put(UserProfileController());
    userProfileController.getUserprofile(storage.read(MyStorage.userName));
  }

  RxBool isSearch = false.obs;
  RxInt CommentCount = 0.obs;
  RxInt ReactionCount = 0.obs;
  RxBool isBookMarkedtemp = false.obs;
  List tempList = ['mp4', 'avi', 'mkv', 'mov', "MOV", "MP4", "AVI", "MKV"];

  List<Map<String, dynamic>> userStory = [
    {"userImage": "assets/images/profileImage.jpeg", "userName": "Name"},
    {"userImage": "assets/images/profileImage.jpeg", "userName": "Name"},
    {"userImage": "assets/images/profileImage.jpeg", "userName": "Name"},
    {"userImage": "assets/images/profileImage.jpeg", "userName": "Name"},
    {"userImage": "assets/images/profileImage.jpeg", "userName": "Name"},
    {"userImage": "assets/images/profileImage.jpeg", "userName": "Name"},
    {"userImage": "assets/images/profileImage.jpeg", "userName": "Name"},
    {"userImage": "assets/images/profileImage.jpeg", "userName": "Name"},
  ];
  int selectedIndex = 0;
  RxBool isSelected = false.obs;
  RxString isSelectedtype = "read".obs;
  RxBool audioFilePlay = true.obs;

  List<Map<String, dynamic>> buttonList = [];

  List podcastCategory = [
    "All",
    "Life",
    "Comedy",
    "Tech",
    "Life",
    "Comedy",
    "Tech"
  ];

  String timeDiffrance(MyStartTime) {
    try {
      DateTime startTime = MyStartTime; // Replace with your start time
      DateTime endTime = DateTime.now(); // Replace with your end time

      // Calculate the time difference
      Duration difference = endTime.difference(startTime);

      return difference.inHours >= 24
          ? "${difference.inDays}d ago"
          : "${difference.inHours == 0 ? "" : "${difference.inHours}h "}${difference.inMinutes.remainder(60)}m ago";
    } catch (e) {
      return "";
    }
  }

  RxInt selectedPodcastCategory = 0.obs;
  int page = 1;
  RxInt currentPage = 0.obs;
  RxInt totalPage = 0.obs;
  RxInt peopleCurrentPage = 0.obs;
  RxInt peopleTotalPage = 0.obs;
  RxList<FeedListData> homeFeedList = <FeedListData>[].obs;
  RxList<PeopleYouKnowDataList> peopleYouKnowDataList =
      <PeopleYouKnowDataList>[].obs;
  // RxList videoThumnailList = [].obs;
  RxBool isLoadingFeed = false.obs;
  RxString noMoreFeeds = "".obs;
  RxString selectedTopic = "".obs;
  final RxInt selectedTopicIndex = 0.obs;
  RxList<HashtagModel> trendingHashtagsList = <HashtagModel>[].obs;
  RxList<HashtagModel> suggestedHashtagsList = <HashtagModel>[].obs;

//! GET ALL FEED API

  Future getAllFeedData(fromfirst, fromPagination) async {
    /** Mark posts as viewed */
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> viewedPosts = prefs.getStringList('viewedPosts') ?? [];
    if (viewedPosts.isNotEmpty) {
      var formData = {
        'seed_ids': viewedPosts,
      };
      print('form data ==> $formData');
      String myUrl = "$baseUrl$markAsSeen";

      {
        try {
          // showLoader();
          var response = await ApiManager().call(myUrl, formData, ApiType.post);
          if (response.status == "success") {
            print("Mark as seen ==> ${response.message}");
            // hideLoader();
            viewedPosts.clear();
            prefs.setStringList('viewedPosts', viewedPosts);
          } else {
            Toaster().warning(response.message);
          }
        } catch (e, f) {
          // hideLoader();
          log("Chek data ==> $e, $f ");
          MyPrint(tag: "catch", value: e.toString());
        }
      }
    }

    showLoader();

    /** Get all posts data */
    isLoadingFeed.value = true;
    noMoreFeeds.value = "";
    String type = selectedIndex == 0
        ? "read"
        : selectedIndex == 1
            ? "watch"
            : "podcast";
    // fm.FormData formData = fm.FormData.fromMap(
    //   {"seed_type": type, 'page': page},
    // );

    var jsonDB = {"seed_type": type, 'page': page};
    log(jsonDB.toString());
    dio.FormData formData = dio.FormData.fromMap(jsonDB);
    {
      try {
        showLoader();
        var response = await ApiManager()
            .call('$baseUrl$getAllFeedUrl', formData, ApiType.getWithBody);
        if (response.status == "success") {
          currentPage.value = response.data["current_page"];
          totalPage.value = response.data["total_pages"];
          if (response.data["seeds"] != null) {
            for (var i = 0; i < response.data["seeds"].length; i++) {
              homeFeedList
                  .add(FeedListData.fromJson(response.data["seeds"][i]));
              homeFeedList[i].isMore!.value =
                  homeFeedList[i].caption!.length > 50 ? true : false;
              listOfSeenFeed.add(homeFeedList[i].id!);
            }
            // homeFeedList.insert(0, addDummyHomeData());
            await markSeedAsRead().whenComplete(() => listOfSeenFeed.clear());
            update();
            hideLoader();
          } else {
            isLoadingFeed.value = false;
            Toaster().warning(response.message);
          }
        } else {
          isLoadingFeed.value = false;
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        isLoadingFeed.value = false;
        hideLoader();
        // log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

  //! REPORT THE SEED
  Future repostTheFeedAPI(feedID, caption) async {
    MyPrint(tag: "check report data ", value: feedID);

    fm.FormData formData = fm.FormData.fromMap(
      {
        'seed': feedID,
        'caption': caption,
      },
    );
    String myUrl = "$baseUrl$repostTheFeed";
    {
      try {
        showLoader();
        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          Toaster().warning(response.message);
          Get.offAll(() => HomePage(
                pageIndex: 0,
              ));
        } else {
          Toaster().warning(response.message);
        }
        await getAllFeedData(false, true);
        homeFeedList.refresh();
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

//! SEARCH USER API

  TextEditingController searchNameController = TextEditingController();
  RxList<SearchedUserDataList> searchUserDataList =
      <SearchedUserDataList>[].obs;

  Future searchUsersName(searchValue, fromSearch, fromPegination) async {
    fromSearch == true ? searchUserDataList.clear() : null;
    fromSearch == true ? page = 1 : null;

    String myUrl = "$baseUrl${searchuser}search=${searchValue}&page=$page";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, "", ApiType.get);
        if (response.status == "success") {
          currentPage.value = response.data["current_page"];
          totalPage.value = response.data["total_pages"];
          if (response.data["objects"] != null) {
            fromSearch == true ? searchUserDataList.clear() : null;
            fromSearch == true ? page = 1 : null;
            searchUserDataList.refresh();
            for (var i = 0; i < response.data["objects"].length; i++) {
              searchUserDataList.add(
                  SearchedUserDataList.fromJson(response.data["objects"][i]));
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

//! PEOPLE YOU MAY KNOW API

  int peopleYouKnowDataPage = 1;
  Future peopleYouKnow(fromNew) async {
    fromNew == true ? peopleYouKnowDataList.clear() : null;
    {
      try {
        // showLoader();
        var response = await ApiManager().call(
            '$baseUrl$getPeopleYouKnowEndpoint$peopleCurrentPage',
            "",
            ApiType.get);
        if (response.status == "success") {
          peopleCurrentPage.value = response.data["current_page"];
          peopleTotalPage.value = response.data["total_pages"];
          getAllFeedData(true, false);
          if (response.data["items"] != null) {
            await getNotificationCountAPI(1);

            for (var i = 0; i < response.data["items"].length; i++) {
              peopleYouKnowDataList.add(
                  PeopleYouKnowDataList.fromJson(response.data["items"][i]));
            }
            update();
          } else {
            await ApiManager().setRefreshTokenAPI(fromMain: true);

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

//! BOOKMARK THE FEED API

  Future bookMarkTheFeed(feedID, {ind, fromProfile, bookmarkValue}) async {
    log("In side the condition ==> 1 $feedID");
    fm.FormData formData = fm.FormData.fromMap(
      {
        'seed': feedID,
        'is_bookmarked': fromProfile == true
            ? bookmarkValue == true
                ? false
                : true
            : bookmarkValue == true
                ? false
                : true
      },
    );
    String myUrl = "$baseUrl$bookMarkFeed";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          if (fromProfile == true) {
            profilePostDetails.value.bookmark =
                response.code == 204 ? false : true;

            isBookMarkedtemp.value = profilePostDetails.value.bookmark ?? false;
            profilePostDetails.refresh();
            Toaster().warning(response.message);
          } else {
            homeFeedList[ind].bookmark =
                homeFeedList[ind].bookmark == true ? false : true;
            isBookMarkedtemp.value = homeFeedList[ind].bookmark ?? false;
            homeFeedList.refresh();
            Toaster().warning(response.message);
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

//! SET COMMENT JSON

  setCommnetOnFirst(newID) {
    var jsonData = '''
{
  "id": $newID,
  "user": {
    "id": ${storage.read(MyStorage.userId)},
    "first_name": null,
    "last_name": null,
    "username": "${storage.read(MyStorage.userName)}",
    "email": "${storage.read(MyStorage.email)}",
    "userprofile": {
      "profile_picture": "$baseUrl${storage.read(MyStorage.userProfile)}",
      "display_name":"${storage.read(MyStorage.displayName)}"
    }
  },
  "comment": "${commentController.text}",
  "comment_reactions": 0,
  "user_reaction": null,
  "cloner": [],
  "created_at": "${DateTime.now().toLocal()}",
  "modified_at": "${DateTime.now().toLocal()}"
}
''';
    Map<String, dynamic> jsonMap = json.decode(jsonData);
    GetCommentListDataModel commentModel =
        GetCommentListDataModel.fromJson(jsonMap);
    getCommentListDataModel.insert(0, commentModel);
    getCommentListDataModel.refresh();
  }

  addDummyHomeData() {
    var jsonData = '''
{
  "id": 125,
        "user": {
            "id": 26,
            "first_name": null,
            "last_name": null,
            "username": "jack",
            "email": "jack@yopmail.com",
            "userprofile": {
                "profile_picture": null,
                "display_name": "jack"
            }
        },
        "caption": "this is a repost - by viraj 2",
        "is_private": false,
        "type": "read",
        "media_data": [
            {
                "image": "media/seeds/3/3_20240327120227_2024-Mar-27.jpg"
            }
        ],
        "created_at": "2024-04-02T13:28:30.868432Z",
        "modified_at": "2024-04-02T13:28:30.868444Z",
        "reactions_count": 0,
        "comments_count": 0,
        "my_reaction": null,
        "bookmark": false,
        "top_reactions": [],
        "thumbnail_url": null,
        "share_url": "https://watermel.online/seed/single-post/125",
        "owner": {
            "id": 26,
            "first_name": null,
            "last_name": null,
            "username": "jack",
            "email": "jack@yopmail.com",
            "userprofile": {
                "profile_picture": null,
                "display_name": "jack"
            }
        },
        "caption_history": [
            {
                "user_id": 3,
                "user_name": "sajawal_sheraz",
                "user_profile_url": "/media/users/profile_pictures/profileImage_rfGGKjK.jpeg",
                "user_post_caption": "I'm the type who'd be happy not going anywhere as long as I was sure I knew exactly what was happening at the places I wasn't going to. I'm the type who'd like to sit home and watch every party that I'm invited to on a monitor in my bedroom."
            },
            {
                "user_id": 26,
                "user_name": "jack",
                "user_profile_url": null,
                "user_post_caption": "this is a repost - by viraj"
            }
        ],
        "view_count": 0
}
''';
    Map<String, dynamic> jsonMap = json.decode(jsonData);

    FeedListData.fromJson(jsonMap);
    return FeedListData.fromJson(jsonMap);
  }

//! ADD COMMENT

  Future addComment(feedID, {ind, fromprofile, fromAddComment}) async {
    fm.FormData formData = fm.FormData.fromMap(
      {'seed': feedID, 'comment': commentController.text},
    );

    String myUrl = "$baseUrl$addComent";
    {
      try {
        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          if (fromprofile == false) {
            int temp = homeFeedList[ind].commentsCount ?? CommentCount.value;
            temp++;
            homeFeedList[ind].commentsCount = temp;
            CommentCount.value = homeFeedList[ind].commentsCount ?? 0;
            homeFeedList.refresh();
          } else {
            int temp =
                profilePostDetails.value.commentsCount ?? CommentCount.value;
            temp++;
            profilePostDetails.value.commentsCount = temp;
            CommentCount.value = profilePostDetails.value.commentsCount ?? 0;
            profilePostDetails.refresh();

            hideLoader();
          }

          setCommnetOnFirst(response.data["id"]);
          hideLoader();
          commentController.clear();
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

//! GET NOTIFICATION

  RxInt totalCommentPage = 1.obs;
  RxInt currentCommentPage = 1.obs;

  RxList<GetCommentListDataModel> getCommentListDataModel =
      <GetCommentListDataModel>[].obs;

  Future getComment(feedID) async {
    fm.FormData formData = fm.FormData.fromMap(
      {'page': currentCommentPage},
    );
    String myUrl = "$baseUrl$getCommentEndPoint$feedID/";

    {
      try {
        showLoader();
        var response =
            await ApiManager().call(myUrl, formData, ApiType.getWithBody);
        if (response.status == "success") {
          totalCommentPage.value = response.data["total_pages"];
          currentCommentPage.value = response.data["current_page"];
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

//! REPORT THE SEED

  Future reportTheSeed(feedID) async {
    MyPrint(tag: "check report data ", value: feedID);

    fm.FormData formData = fm.FormData.fromMap(
      {'seed': feedID},
    );
    String myUrl = "$baseUrl$reportSeed";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          Toaster().warning(response.message);
        } else {
          Toaster().warning(response.message);
        }
        await getAllFeedData(false, true);
        homeFeedList.refresh();
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

//! SEED REACTION API

  Future reactionAPI(feedID, fromProfile, autoReflect, {ind}) async {
    log("Check my pasing data ==> $feedID, $fromProfile, ${ind}");

    fm.FormData formData = fm.FormData.fromMap(
      {'seed': feedID, 'reaction_type': 'love'},
    );
    String myUrl = "$baseUrl$like";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          if (autoReflect == true) {
            if (response.message.contains("removed")) {
              homeFeedList[ind].myReaction = null;
              int temp = homeFeedList[ind].reactionsCount ?? 1;
              temp--;
              homeFeedList[ind].reactionsCount = temp;
              ReactionCount.value = homeFeedList[ind].reactionsCount ?? 0;
              homeFeedList.refresh();
            } else {
              homeFeedList[ind].myReaction = "love";
              int temp = homeFeedList[ind].reactionsCount ?? 1;
              temp++;
              homeFeedList[ind].reactionsCount = temp;
              ReactionCount.value = homeFeedList[ind].reactionsCount ?? 0;
              homeFeedList.refresh();
            }
          }
        } else {
          Toaster().warning(response.message);
        }
        homeFeedList.refresh();
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

//! COMMNET REACTION API

  Future commentReactionAPI(feedID, ind) async {
    fm.FormData formData = fm.FormData.fromMap(
      {'comment': feedID, 'reaction_type': 'love'},
    );
    String myUrl = "$baseUrl$likeComment";
    log("Check my pasing data ==> $feedID, $myUrl, ${formData.toString()}");
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          if (response.message.contains("removed")) {
            getCommentListDataModel[ind].userReaction = null;
            int temp = getCommentListDataModel[ind].commentReactionCount ?? 1;
            temp--;
            getCommentListDataModel[ind].commentReactionCount = temp;
            // ReactionCount.value =
            //     profilePostDetails.value.reactionsCount ?? 0;
            profilePostDetails.refresh();
          } else {
            getCommentListDataModel[ind].userReaction = "love";
            int temp = getCommentListDataModel[ind].commentReactionCount ?? 1;
            temp++;
            getCommentListDataModel[ind].commentReactionCount = temp;
            // ReactionCount.value =
            //     profilePostDetails.value.reactionsCount ?? 0;
            profilePostDetails.refresh();
          }
          getCommentListDataModel.refresh();
        } else {
          Toaster().warning(response.message);
        }
        homeFeedList.refresh();
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

//! FOLLOW THE USER API

  Future FollowTheUsesr(userName, {index}) async {
    fm.FormData formData = fm.FormData.fromMap(
      {'username': userName},
    );
    String myUrl = "$baseUrl$follow";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, formData, ApiType.post);
        if (response.status == "success") {
          peopleYouKnowDataList.removeAt(index);
          update();
          Toaster().warning(response.message);
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> 555 ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

//! COMMNET POST DETAIL API
//https://watermel-dev-media.eu-central-1.amazonaws.com/media/seeds/6/6_20240415175624_pexels-luis-felipe-queiroz-11867612.jpg
//https://watermel-dev-media.s3.amazonaws.com/media/users/profile_pictures/1000_F_206941644_RJ4YD9eKbeCSZ4sZdqXjKi7kL0AZYNNq.jpg

  Rx<ProfilePostDetailData> profilePostDetails = ProfilePostDetailData().obs;
  RxBool isLoading = true.obs;
  getUserPotDetailsAPI(feedId, fromWhere) async {
    isLoading.value = true;
    String myUrl = "$baseUrl$getSpecifiPostDetails$feedId";
    {
      try {
        showLoader();
        isLoading.value = true;
        var response = await ApiManager().call(myUrl, "", ApiType.get);
        if (response.status == "success") {
          profilePostDetails.value =
              ProfilePostDetailData.fromJson(response.data);

          update();
          if (fromWhere == 1) {
            Get.to(() => ProfileFeedDetailScreen(
                  createTime: profilePostDetails.value.createdAt,
                  myReaction: profilePostDetails.value.myReaction,
                  fromMain: false,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id!,
                  isBookmark: profilePostDetails.value.bookmark,
                  likeCount: profilePostDetails.value.reactionsCount,
                  mediaType: 0,
                  mediaURL: profilePostDetails.value.mediaData!.isEmpty ||
                          profilePostDetails.value.mediaData!.first.image ==
                              null ||
                          profilePostDetails.value.mediaData?.first.image == ""
                      ? ""
                      : profilePostDetails.value.mediaData?.first.image,
                  thumbnail: profilePostDetails.value.thumbURl == null ||
                          profilePostDetails.value.thumbURl == ""
                      ? ""
                      : "$baseUrl${profilePostDetails.value.thumbURl}",
                  userName: profilePostDetails.value.user?.username ?? "",
                  userProfile: profilePostDetails
                      .value.user?.userprofile!.profilePicture,
                  isPrivate: profilePostDetails.value.isPrivate ?? false,
                ));
          }
          if (fromWhere == 2) {
            Get.to(() => ProfileFeedDetailScreen(
                  createTime: profilePostDetails.value.createdAt,
                  fromMain: false,
                  myReaction: profilePostDetails.value.myReaction,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id!,
                  isBookmark: profilePostDetails.value.bookmark,
                  likeCount: profilePostDetails.value.reactionsCount,
                  mediaType: 1,
                  mediaURL: profilePostDetails.value.mediaData!.isEmpty ||
                          profilePostDetails.value.mediaData!.first.video ==
                              null ||
                          profilePostDetails.value.mediaData?.first.video == ""
                      ? ""
                      : "$baseForImage${profilePostDetails.value.mediaData!.first.video}",
                  thumbnail: profilePostDetails.value.thumbURl == null ||
                          profilePostDetails.value.thumbURl == ""
                      ? ""
                      : "$baseForImage${profilePostDetails.value.thumbURl}",
                  userName: profilePostDetails.value.user?.username ?? "",
                  userProfile: profilePostDetails
                      .value.user?.userprofile!.profilePicture,
                  isPrivate: profilePostDetails.value.isPrivate ?? false,
                ));
          }
          if (fromWhere == 3) {
            Get.to(() => ProfileFeedDetailScreen(
                  createTime: profilePostDetails.value.createdAt,
                  fromMain: false,
                  myReaction: profilePostDetails.value.myReaction,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id!,
                  isBookmark: profilePostDetails.value.bookmark,
                  likeCount: profilePostDetails.value.reactionsCount,
                  mediaType: 2,
                  mediaURL: profilePostDetails.value.mediaData!.isEmpty ||
                          profilePostDetails.value.mediaData!.first.audio ==
                              null ||
                          profilePostDetails.value.mediaData?.first.audio == ""
                      ? ""
                      : "$baseForImage${profilePostDetails.value.mediaData!.first.audio}",
                  thumbnail: profilePostDetails.value.thumbURl == null ||
                          profilePostDetails.value.thumbURl == ""
                      ? ""
                      : "$baseForImage${profilePostDetails.value.thumbURl}",
                  userName: profilePostDetails.value.user?.username ?? "",
                  userProfile: profilePostDetails
                      .value.user?.userprofile!.profilePicture,
                  isPrivate: profilePostDetails.value.isPrivate ?? false,
                ));
          }
          isLoading.value = false;
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        isLoading.value = false;
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

//! GET NOTIFICATION COUNT API

  RxInt notificationCount = 0.obs;
  getNotificationCountAPI(fromWhere) async {
    isLoading.value = true;
    String myUrl = "$baseUrl$getNotificationCount";
    {
      try {
        isLoading.value = true;
        var response = await ApiManager().call(myUrl, "", ApiType.get);
        if (response.status == "success") {
          notificationCount.value = response.notificationCount ?? 0;
          update();
        } else if (response.status == "unauthorized") {
          // ApiManager().setRefreshTokenAPI(fromMain: true);
        } else {
          // Toaster().warning(response.message);
        }
      } catch (e, f) {
        log("-----------------> ${e}, $f ");
      }
    }
  }

//! DELETE FEED API CALL

  Future deleteFeedAPI(
    feedID,
  ) async {
    String myUrl = "$baseUrl$deleteFeed$feedID/";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, "", ApiType.delete);
        if (response.status == "success") {
          Toaster().warning(response.message);
          Get.offAll(() => HomePage(
                pageIndex: 3,
              ));
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

  //! EDIT FEED API CALL
  Future<void> editPost(
      int feedID, String? caption, String type, bool isPrivate) async {
    showLoader();
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'caption': caption,
        'is_private': isPrivate,
        'type': type,
      });
      print("Caption: $caption\nType: $type\nIsPrivate: $isPrivate");
      String myUrl = "$baseUrl$editFeed$feedID/";
      ApiManager().call(myUrl, formData, ApiType.put).then((response) {
        hideLoader();
        if (response.status == "success") {
          Toaster().warning(response.message);
          Get.offAll(() => HomePage(
                pageIndex: 3,
              ));
        } else {
          Toaster().warning(response.message);
        }
      });
    } catch (e) {
      hideLoader();
      MyPrint(tag: "catch", value: e.toString());
    }
  }

// //! FEED MARK AS READ
  List<int> listOfSeenFeed = [];
  Future markSeedAsRead() async {
    Map<String, dynamic> jsonDB = {
      'seed_ids': listOfSeenFeed,
    };

    log("Chek data  555==> ${jsonDB.toString()}");
    String myUrl = "$baseUrl$readTheSeed";

    {
      try {
        showLoader();
        var response = await ApiManager().call(myUrl, jsonDB, ApiType.post);
        log("Chek Read api status:: ${response.status == "success"}");
        if (response.status == "success") {
          listOfSeenFeed = [];
          log("Chek data  555==> ${listOfSeenFeed}");
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();
        log("Chek data  555==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

  /// Mark post as viewed
  void viewedPost(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final viewedPosts = prefs.getStringList('viewedPosts') ?? [];

    if (!viewedPosts.contains(id.toString())) {
      viewedPosts.add(id.toString());
      prefs.setStringList('viewedPosts', viewedPosts);
      return;
    }
  }

  /// Get Seeds relative to a Topic
  Future<void> getSeedsByTopic(bool newTopic,
      {bool isInChipList = false}) async {
    if (newTopic) {
      page = 1;
    }

    if (!isInChipList) {
      selectedTopicIndex.value = 1;
    }

    var formData = "";
    String type = selectedIndex == 0
        ? "read"
        : selectedIndex == 1
            ? "watch"
            : "podcast";
    var myUrl =
        "$baseUrl$relativeSeeds$page&type=$type&hashtag=${selectedTopic.value.toString().replaceAll('#', '')}";
    try {
      final response = await ApiManager().call(
        myUrl,
        formData,
        ApiType.get,
      );

      if (response.status == 'success') {
        homeFeedList.clear();
        for (var i = 0; i < response.data['seeds'].length; i++) {
          totalPage.value = response.data['total_pages'];
          currentPage.value = response.data['current_page'];
          if (totalPage.value == currentPage.value) {
            noMoreFeeds.value = "No more posts!";
          }
          homeFeedList.add(FeedListData.fromJson(response.data['seeds'][i]));
          homeFeedList[i].isMore!.value =
              homeFeedList[i].caption!.length > 50 ? true : false;
        }
        update();
      } else {
        Toaster().warning(response.message);
      }
    } catch (e, f) {
      log('Error: $e, $f');
    }
  }

  // Get trending hashtags
  Future<void> getTrendingHashtags() async {
    trendingHashtagsList.clear();
    const myUrl = '$baseUrl$trendingHashtags';
    try {
      final response = await ApiManager().call(
        myUrl,
        "",
        ApiType.get,
      );

      if (response.status == 'success') {
        for (var i = 0; i < response.data.length; i++) {
          trendingHashtagsList.add(HashtagModel.fromJson(response.data[i]));
        }
        update();
      } else {
        Toaster().warning(response.message);
      }
    } catch (e, f) {
      log('Error: $e, $f');
    }
  }

  // Get suggested Hashtags
  Future<void> getSuggestedHashtags(String hashtag) async {
    suggestedHashtagsList.clear();

    String myUrl = '$baseUrl$suggestedHashtags${hashtag.replaceAll('#', '')}';

    try {
      ApiManager().call(myUrl, "", ApiType.get).then((response) {
        if (response.status == 'success') {
          for (var i = 0; i < response.data.length; i++) {
            suggestedHashtagsList.add(HashtagModel.fromJson(response.data[i]));
          }
          update();
        } else {
          Toaster().warning(response.message);
        }
      });
    } catch (e, f) {
      log('Error: $e, $f');
    }
    print('Suggested Hashtags: $suggestedHashtagsList');
  }
}
