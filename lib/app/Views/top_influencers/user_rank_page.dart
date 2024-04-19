import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watermel/app/Views/top_influencers/controller/top_influencers_controller.dart';
import 'package:watermel/app/Views/top_influencers/widgets/top_influencers_card.dart';
import 'package:watermel/app/models/user_profile_model.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/widgets/common_widget.dart';

class UserRankPage extends StatelessWidget {
  UserRankPage({super.key});

  TopInfluencersController topinfluencersController =
      Get.put(TopInfluencersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarPreferredSizeAction("My Rank", true, "My Rank", () {}),
      body: ListView.builder(
        itemCount: topinfluencersController.userList.length,
        itemBuilder: (context, index) {
          UserProfileData user = topinfluencersController.userList[index];
          return TopInfluencersCard(
            userProfileData: user,
            rank: user.rank!,
            isSelf: user.username == MyStorage.userName,
            isFriends: false,
          );
        },
      ),
    );
  }
}
