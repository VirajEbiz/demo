import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/Views/home_bottom_bar/homebottom_controller.dart';
import 'package:watermel/app/Views/trendingDebates/controller/debates_controller.dart';
import 'package:watermel/app/Views/trendingDebates/widgets/trending_debates_card.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/widgets/common_methods.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';

class TrendingDebatesPage extends StatefulWidget {
  const TrendingDebatesPage({super.key});

  @override
  State<TrendingDebatesPage> createState() => _TrendingDebatesPageState();
}

class _TrendingDebatesPageState extends State<TrendingDebatesPage> {
  DebatesController debatesController = Get.put(DebatesController());

  @override
  void initState() {
    super.initState();
    debatesController.getTrendingDebates();
  }

  String timeDifferance(myStartTime) {
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /**
           * Appbar
           */
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 80.0,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: appbarPreferredSizeAction(
                  "Trending Debates", false, "Trending Debates", () {}),
            ),
          ),
          /**
           * Trending Debates
           */
          Obx(
            () => debatesController.trendingDebates.isEmpty
                ? SliverToBoxAdapter(
                    child: CommonMethod().venueListEffect(5),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate(
                      List.generate(debatesController.trendingDebates.length,
                          (index) {
                        return TrendingDebatesCard(
                          rank: index + 1,
                          trendingDebate:
                              debatesController.trendingDebates[index],
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
