import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watermel/app/Views/top_influencers/controller/top_influencers_controller.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:watermel/app/models/user_profile_model.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';

/// A card widget that represents a billboard item.
class TopInfluencersCard extends StatelessWidget {
  TopInfluencersCard({
    super.key,
    required this.userProfileData,
    required this.rank,
    required this.isSelf,
    required this.isFriends,
  });

  /// The user profile data associated with the billboard item.
  final UserProfileData userProfileData;

  /// The rank of the top influencers item.
  final int rank;

  /// Whether the user is the current user.
  final bool isSelf;

  /// Whether the user is a friend.
  final bool isFriends;

  TopInfluencersController topinfluencersController =
      Get.put(TopInfluencersController());

  String formatNumber(int number) {
    final formatter = NumberFormat.compact();
    formatter.maximumFractionDigits = 1;
    formatter.significantDigitsInUse = false;
    return formatter.format(number);
  }

  String formatNumberCommas(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isSelf) {
          topinfluencersController.getUserData();
        } else {
          Get.to(
            () => UserProfileScreenbackup(
              fromProfile: false,
              userName: userProfileData.username,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(Insets.i10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelf ? MyColors.greenColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.12,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: MyText(
                            text_name: '#$rank',
                            txtfontsize: 30,
                            fontWeight: FontWeight.bold,
                            txtcolor: rank == 1
                                ? const Color.fromARGB(255, 255, 191, 0)
                                : rank == 2
                                    ? Colors.grey
                                    : rank == 3
                                        ? const Color.fromARGB(255, 203, 125, 8)
                                        : isSelf
                                            ? MyColors.whiteColor
                                            : MyColors.greenColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CustomImageView(
                          radius: 100,
                          imagePathOrUrl: "${userProfileData.profilePicture}",
                          isProfilePicture: true,
                        ),
                      ),
                      const SizedBox(width: Insets.i20),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text_name: userProfileData.displayName ?? "",
                              txtfontsize: 14,
                              fontWeight: FontWeight.bold,
                              txtAlign: TextAlign.start,
                              txtcolor: isSelf
                                  ? MyColors.whiteColor
                                  : MyColors.blackColor,
                            ),
                            MyText(
                              text_name: "@${userProfileData.username ?? ""}",
                              txtfontsize: 12,
                              textOverflow: TextOverflow.ellipsis,
                              txtcolor: isSelf
                                  ? MyColors.whiteColor
                                  : MyColors.blackColor,
                            ),
                            MyText(
                              text_name:
                                  '${formatNumber(userProfileData.followers ?? 0)} followers',
                              txtfontsize: 12,
                              txtcolor: isSelf
                                  ? MyColors.whiteColor
                                  : MyColors.blackColor,
                            ),
                            if (isFriends)
                              MyText(
                                text_name:
                                    '#${formatNumberCommas(userProfileData.rank ?? 0)}',
                                txtfontsize: 12,
                                txtcolor: isSelf
                                    ? MyColors.whiteColor
                                    : MyColors.blackColor,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: rank == 1
                              ? const Color.fromARGB(255, 255, 191, 0)
                              : rank == 2
                                  ? Colors.grey
                                  : rank == 3
                                      ? const Color.fromARGB(255, 203, 125, 8)
                                      : isSelf
                                          ? MyColors.whiteColor
                                          : MyColors.greenColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: MyText(
                            text_name:
                                '${(userProfileData.noOfInfluencer ?? 0).toStringAsFixed(2)}',
                            txtfontsize: 14,
                            fontWeight: FontWeight.bold,
                            txtcolor:
                                isSelf ? MyColors.blackColor : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Insets.i10),
              SizedBox(
                width: Get.width * 0.8,
                child: MyText(
                  text_name: "${userProfileData.bio ?? ""}",
                  txtfontsize: 14,
                  txtAlign: TextAlign.start,
                  txtcolor: isSelf ? MyColors.whiteColor : MyColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
