import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/models/trending_debate.dart';
import 'package:watermel/app/utils/theme/print.dart';
import 'package:watermel/app/utils/toast.dart';

class DebatesController extends GetxController {
  RxList<TrendingDebateModel> trendingDebates = <TrendingDebateModel>[].obs;
  RxInt totalTopics = 0.obs;
  RxInt totalPages = 0.obs;
  RxInt currentPage = 1.obs;

  @override
  void onInit() {
    getTrendingDebates();
    super.onInit();
  }

  Future getTrendingDebates() async {
    trendingDebates.clear();

    var formData = "";
    String myUrl = "$baseUrl$debates";

    try {
      var response = await ApiManager().call(myUrl, formData, ApiType.get);
      if (response.status == "success") {
        var data = response.data;
        print(data);
        totalTopics.value = data["total_topics"];
        totalPages.value = data["total_pages"];
        currentPage.value = data["current_page"];
        var topics = data["topics"];
        trendingDebates.clear();
        for (var topic in topics) {
          trendingDebates.add(TrendingDebateModel.fromJson(topic));
        }
      } else {
        Toaster().warning(response.message);
      }
    } catch (e, f) {
      log("Check data ==> $e, $f");
      MyPrint(tag: "catch", value: e.toString());
    }
  }
}
