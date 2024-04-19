import 'dart:developer';

import 'package:get/get.dart';
import 'package:watermel/app/Views/user_profile/profile_detail_screen.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/models/bookmark_list_model.dart';
import 'package:watermel/app/models/detail_post_data_model.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/theme/print.dart';
import 'package:watermel/app/utils/toast.dart';

class BookmarkController extends GetxController {
  RxList<BookmarkItem> bookmarkList = <BookmarkItem>[].obs;

  int page = 1;
  int current_page = 1;
  int total_page = 1;
  String selectedType = "read";
  RxBool isLoadingBookMark = false.obs;

  Future getBookmarkListAPI(selectedI) async {
    isLoadingBookMark.value = bookmarkList.isEmpty ? true : false;
    selectedI == 0
        ? selectedType = "read"
        : selectedI == 1
            ? selectedType = "watch"
            : selectedType = "podcast";
    String myUrl =
        "$baseUrl$getBookmarkFeeds?seed_type=$selectedType&page=$page";

    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, "", ApiType.get);
        if (response.status == "success") {
          current_page = response.data["current_page"];
          total_page = response.data["total_pages"];
          for (var i = 0; i < response.data["bookmarks"].length; i++) {
            bookmarkList.add(
              BookmarkItem.fromJson(response.data["bookmarks"][i]),
            );
          }
          update();

          bookmarkList.refresh();
          isLoadingBookMark.value = false;
          hideLoader();
        } else if (response.code == "000") {
          await getBookmarkListAPI(selectedI);
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

  Rx<ProfilePostDetailData> profilePostDetails = ProfilePostDetailData().obs;
  RxBool isLoading = true.obs;
  getUserPotDetailsAPI(feedId, fromWhere, ind) async {
    log("Check from where ==> ${fromWhere}");
    String myUrl = "$baseUrl$getSpecifiPostDetails$feedId";
    {
      try {
        showLoader();

        var response = await ApiManager().call(myUrl, "", ApiType.get);
        if (response.status == "success") {
          profilePostDetails.value =
              ProfilePostDetailData.fromJson(response.data);

          update();
          if (fromWhere == 0) {
            Get.to(() => ProfileFeedDetailScreen(
                  bookmarkList: bookmarkList,
                  index: ind,
                  fromBookmark: true,
                  createTime: profilePostDetails.value.createdAt,
                  myReaction: profilePostDetails.value.myReaction,
                  fromMain: false,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id,
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
                ));
          }
          if (fromWhere == 1) {
            Get.to(() => ProfileFeedDetailScreen(
                  bookmarkList: bookmarkList,
                  index: ind,
                  createTime: profilePostDetails.value.createdAt,
                  fromBookmark: true,
                  fromMain: false,
                  myReaction: profilePostDetails.value.myReaction,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id,
                  isBookmark: profilePostDetails.value.bookmark,
                  likeCount: profilePostDetails.value.reactionsCount,
                  mediaType: 1,
                  mediaURL:
                      "$baseUrl${profilePostDetails.value.mediaData!.first.video}",
                  thumbnail: profilePostDetails.value.thumbURl == null ||
                          profilePostDetails.value.thumbURl == ""
                      ? ""
                      : "$baseUrl${profilePostDetails.value.thumbURl}",
                  userName: profilePostDetails.value.user?.username ?? "",
                  userProfile: profilePostDetails
                      .value.user?.userprofile!.profilePicture,
                ));
          }
          if (fromWhere == 2) {
            Get.to(() => ProfileFeedDetailScreen(
                  bookmarkList: bookmarkList,
                  index: ind,
                  createTime: profilePostDetails.value.createdAt,
                  fromBookmark: true,
                  fromMain: false,
                  myReaction: profilePostDetails.value.myReaction,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id,
                  isBookmark: profilePostDetails.value.bookmark,
                  likeCount: profilePostDetails.value.reactionsCount,
                  mediaType: 2,
                  mediaURL:
                      "$baseUrl${profilePostDetails.value.mediaData!.first.audio}",
                  thumbnail: profilePostDetails.value.thumbURl == null ||
                          profilePostDetails.value.thumbURl == ""
                      ? ""
                      : "$baseUrl${profilePostDetails.value.thumbURl}",
                  userName: profilePostDetails.value.user?.username ?? "",
                  userProfile: profilePostDetails
                      .value.user?.userprofile!.profilePicture,
                ));
          }
          isLoading.value = false;
        } else if (response.code == "000") {
          await getUserPotDetailsAPI(feedId, fromWhere, ind);
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f");
        isLoading.value = false;
        MyPrint(tag: "catch 1111", value: e.toString());
      }
    }
  }
}
