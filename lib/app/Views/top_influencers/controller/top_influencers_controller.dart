import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/models/user_profile_model.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/theme/print.dart';

class TopInfluencersController extends GetxController {
  RxList<UserProfileData> topInfluencersList = <UserProfileData>[].obs;
  RxList<UserProfileData> friendsList = <UserProfileData>[].obs;
  RxList<UserProfileData> userList = <UserProfileData>[].obs;
  Rx<UserProfileData> userRank = UserProfileData().obs;
  RxInt totalPeople = 0.obs;
  RxInt totalPages = 0.obs;
  RxInt currentPage = 1.obs;

  Future getTopInfluencersData() async {
    topInfluencersList.clear();

    var formData = "";
    String myUrl = "$baseUrl$topInfluencers";

    try {
      var response = await ApiManager().call(myUrl, formData, ApiType.get);
      if (response.status == "success") {
        var data = response.data;
        var othersRank = data["others_rank"];
        var people = othersRank["dataset"];
        topInfluencersList.clear();
        for (var person in people) {
          topInfluencersList.add(UserProfileData.fromJson(person));
        }
        userRank.value = UserProfileData.fromJson(data["user_rank"]);
      } else {
        MyPrint(tag: "TopInfluencersController", value: response.message);
      }
    } catch (e, f) {
      print("Check data ==> $e, $f");
      MyPrint(tag: "catch", value: e.toString());
    }
  }

  Future getFriendsData(bool nextPage) async {
    if (!nextPage) friendsList.clear();

    var formData = "";
    String myUrl =
        "$baseUrl$topInfluencers?target=friends&page=${currentPage.value}";

    showLoader();
    try {
      var response = await ApiManager().call(myUrl, formData, ApiType.get);
      if (response.status == "success") {
        var data = response.data;
        var othersRank = data["others_rank"];
        totalPeople.value = othersRank["total_people"];
        totalPages.value = othersRank["total_pages"];
        currentPage.value = othersRank["current_page"];
        var people = othersRank["dataset"];
        if (!nextPage) friendsList.clear();
        for (var person in people) {
          friendsList.add(UserProfileData.fromJson(person));
        }
      } else {
        MyPrint(tag: "TopInfluencersController", value: response.message);
      }
    } catch (e, f) {
      print("Check data ==> $e, $f");
      MyPrint(tag: "catch", value: e.toString());
    }
    hideLoader();
  }

  Future getUserData() async {
    userList.clear();

    var formData = "";
    String myUrl = "$baseUrl$topInfluencers?target=me";

    try {
      var response = await ApiManager().call(myUrl, formData, ApiType.get);
      if (response.status == "success") {
        var data = response.data;
        var people = data["my_rank"];
        userList.clear();
        for (var person in people) {
          userList.add(UserProfileData.fromJson(person));
        }
      } else {
        MyPrint(tag: "TopInfluencersController", value: response.message);
      }
    } catch (e, f) {
      print("Check data ==> $e, $f");
      MyPrint(tag: "catch", value: e.toString());
    }
  }
}
