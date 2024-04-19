import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/divider_widget.dart';
import 'package:watermel/app/Views/home_bottom_bar/homebottom_controller.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/models/trending_debate.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/common_text.dart';

class TrendingDebatesCard extends StatelessWidget {
  TrendingDebatesCard(
      {super.key, required this.rank, required this.trendingDebate});

  final int rank;
  final TrendingDebateModel trendingDebate;
  HomeFeedController homeFeedController = Get.put(HomeFeedController());

  String timeDifference(myStartTime) {
    DateTime startTime = myStartTime; // Replace with your start time
    DateTime endTime = DateTime.now(); // Replace with your end time

    // Calculate the time difference
    Duration difference = endTime.difference(startTime);

    // Print the result
    // print(
    // 'Time difference: ${difference.inHours} hours and ${difference.inMinutes.remainder(60)} minutes');
    return difference.inHours >= 24
        ? "${difference.inDays}d ago"
        : "${difference.inHours == 0 ? "" : "${difference.inHours}h "}${difference.inMinutes.remainder(60)}m ago";
  }

  String formatNumber(int number) {
    final formatter = NumberFormat.compact();
    formatter.maximumFractionDigits = 1;
    formatter.significantDigitsInUse = false;
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "$baseForImage${trendingDebate.topicImage}")),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              height: Get.width * 9 / 16 * 0.6,
              child: Container(
                width: Get.width,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black,
                    ],
                  ),
                ),
                child: ListTile(
                  leading: MyText(
                    text_name: "$rank.",
                    txtcolor: MyColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    txtAlign: TextAlign.center,
                    txtfontsize: 14,
                  ),
                  title: MyText(
                    text_name: "#${trendingDebate.topicName}",
                    txtcolor: Colors.white,
                    fontWeight: FontWeight.bold,
                    txtAlign: TextAlign.left,
                    txtfontsize: 14,
                  ),
                  subtitle: MyText(
                    text_name:
                        "${formatNumber(trendingDebate.interactions)} views  ${timeDifference(trendingDebate.createdAt)}",
                    txtcolor: Colors.white,
                    txtAlign: TextAlign.left,
                  ),
                  trailing: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      homeFeedController.selectedTopic.value =
                          trendingDebate.topicName.replaceAll('#', '');
                      homeFeedController.getSeedsByTopic(true);
                      HomeController homeController = Get.put(HomeController());
                      homeController.pageIndex.value = 0;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Insets.i22, vertical: Insets.i10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: MyColors.greenColor),
                      child: MyText(
                        text_name: "Explore",
                        txtcolor: MyColors.whiteColor,
                        txtfontsize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.i30),
      ],
    );
  }
}
