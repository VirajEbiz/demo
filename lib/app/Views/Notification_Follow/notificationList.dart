import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:watermel/app/Views/Notification_Follow/follow_controller.dart';
import 'package:watermel/app/Views/auth/login_controller.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/main.dart';
import '../../utils/theme/colors.dart';
import '../../widgets/common_widget.dart';

class NotificationListScreen extends StatefulWidget {
  NotificationListScreen({super.key, required this.fromMain});
  bool fromMain;
  @override
  State<NotificationListScreen> createState() => NotificationListScreenState();
}

class NotificationListScreenState extends State<NotificationListScreen> {
  FollowController followController = Get.put(FollowController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      followController.currentPage = 1;
      followController.notificationListData.clear();
      followController.getNotificationListAPI();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (v) async {
        if (v == false) {
          widget.fromMain == true
              ? Get.offAll(() => HomePage(
                    pageIndex: 0,
                  ))
              : Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: MyColors.whiteColor,
        appBar: appbarPreferredSize(
          "Notification",
          true,
          isRightIcon: false,
          isRightText: false,
          backonTap: () {
            widget.fromMain == true
                ? Get.offAll(() => HomePage(
                      pageIndex: 0,
                    ))
                : Get.back();
          },
        ),
        body: homeBody(),
      ),
    );
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        followController.currentPage++;

        if (followController.currentPage < (followController.pageNo)) {
          followController.getNotificationListAPI();
        }
      }
    }
    return true;
  }

  homeBody() {
    return Container(
      margin: const EdgeInsets.only(
          top: Insets.i15, left: Insets.i25, right: Insets.i25),
      child: NotificationListener(
        onNotification: onNotification,
        child: Obx(
          () => followController.notificationListData.isEmpty ||
                  followController.notificationListData == []
              ? MyNoNotification()
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: followController.notificationListData.length,
                  itemBuilder: (context, index) {
                    var data = followController.notificationListData[index];
                    return notificationWidget(data, index);
                  }),
        ),
      ),
    );
  }

  notificationWidget(data, index) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => UserProfileScreen(
        //       fromProfile: false,
        //       userName: homeFeedController.searchUserDataList[index].username,
        //     ));
      },
      child: Container(
          padding: const EdgeInsets.only(bottom: Insets.i25),
          color: MyColors.whiteColor,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => UserProfileScreenbackup(
                              userName: data.notifsenderusername,
                              fromProfile: storage.read(MyStorage.userName) ==
                                      data.notifsenderusername
                                  ? true
                                  : false,
                            ));
                      },
                      child: Center(
                          child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CustomImageView(
                            isProfilePicture: true,
                            radius: 100,
                            imagePathOrUrl: data.notifSenderProfilePicture ==
                                    null
                                ? ""
                                : "$baseUrl${data.notifSenderProfilePicture}"),
                      )),
                    ),
                  ),
                  const SizedBox(width: Insets.i10),
                  Expanded(
                    flex: 8,
                    child: InkWell(
                      onTap: () async {
                        final ct = Get.put(LoginController());
                        data.seed == null
                            ? Get.to(() => UserProfileScreenbackup(
                                  userName: data.notifsenderusername,
                                  fromProfile:
                                      storage.read(MyStorage.userName) ==
                                              data.notifsenderusername
                                          ? true
                                          : false,
                                ))
                            : await ct.getUserPotDetailsAPI(
                                data.seed,
                                false,
                                data.notifType == "comment" &&
                                        data.comment != null
                                    ? true
                                    : false);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                txtAlign: TextAlign.start,
                                text_name:
                                    data.notifSenderDisplayName ?? "Name",
                                // homeFeedController.searchUserDataList[index].username,
                                fontWeight: FontWeight.w500,
                                txtcolor: MyColors.blackColor,
                                txtfontsize: FontSizes.s14,
                              ),
                              MyText(
                                txtAlign: TextAlign.start,
                                text_name: DateFormat('d-MMM-yy hh:mma').format(
                                    DateTime.parse(data.createdAt.toString())
                                        .toUtc()
                                        .toLocal()),
                                // homeFeedController.searchUserDataList[index].username,
                                fontWeight: FontWeight.w400,
                                txtcolor: MyColors.blackColor,
                                txtfontsize: FontSizes.s10,
                              ),
                            ],
                          ),
                          MyText(
                            txtAlign: TextAlign.start,
                            text_name: data.title ?? "",
                            // homeFeedController.searchUserDataList[index].username,
                            fontWeight: FontWeight.w400,
                            txtcolor: MyColors.blackColor,
                            txtfontsize: FontSizes.s12,
                          ),
                          SizedBox(height: Insets.i10),
                          // data.followRequestApproved != null ||
                          data.followRequestApproved == false
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        confirmPopup(context, false,
                                            data.followNetwork, index);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.greenColor,
                                          border: Border.all(
                                              color: MyColors.blackColor),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          child: MyText(
                                            text_name: "Confirm",
                                            txtcolor: MyColors.blackColor,
                                            fontWeight: FontWeight.w500,
                                            txtfontsize: FontSizes.s12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Insets.i10),
                                    GestureDetector(
                                      onTap: () {
                                        confirmPopup(context, true,
                                            data.followNetwork, index);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColors.redColor,
                                          border: Border.all(
                                              color: MyColors.blackColor),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13, vertical: 3),
                                          child: MyText(
                                            text_name: "Delete",
                                            txtcolor: MyColors.whiteColor,
                                            fontWeight: FontWeight.w500,
                                            txtfontsize: FontSizes.s12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }

  confirmPopup(BuildContext context, isReject, followNetworkID, index) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: MyText(
              text_name: "WaterMel App",
              fontWeight: FontWeight.w500,
              txtcolor: MyColors.blackColor,
              txtfontsize: FontSizes.s15,
            ),
            content: MyText(
              text_name: isReject == true
                  ? "Are you sure You want Delete this Request?"
                  : "Are you sure You want Acccept this Request?",
              fontWeight: FontWeight.w400,
              txtcolor: MyColors.blackColor,
              txtfontsize: FontSizes.s14,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: MyText(
                  text_name: "No",
                  fontWeight: FontWeight.w600,
                  txtcolor: MyColors.blackColor,
                  txtfontsize: FontSizes.s16,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (isReject == true) {
                    followController
                        .rejectFollowReqAPI(followNetworkID, true)
                        .whenComplete(() {
                      followController.notificationListData.removeAt(index);
                      followController.notificationListData.refresh();
                    });
                  } else {
                    followController
                        .acceptFollowReqAPI(followNetworkID, true)
                        .whenComplete(() {
                      followController.notificationListData.removeAt(index);
                      followController.notificationListData.refresh();
                    });
                  }
                },
                child: MyText(
                  text_name: "Yes",
                  fontWeight: FontWeight.w600,
                  txtcolor: MyColors.blackColor,
                  txtfontsize: FontSizes.s16,
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
