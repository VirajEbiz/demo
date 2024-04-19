import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hashtagable_v3/widgets/hashtag_text.dart';
import 'package:video_player/video_player.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/Home%20Feed/feed_screen.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/share_bottom_sheet.dart';
import 'package:watermel/app/Views/addComment/addcomments.dart';
import 'package:watermel/app/Views/auth/login_controller.dart';
import 'package:watermel/app/Views/bookmark/bookmark_controller.dart';
import 'package:watermel/app/Views/draft/edit_draft-screen.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/Views/home_bottom_bar/homebottom_controller.dart';
import 'package:watermel/app/Views/user_profile/edit_post_screen.dart';
import 'package:watermel/app/Views/user_profile/user_profile_backup.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_popup.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';
import 'package:watermel/main.dart';

//! mediatype 0 = image, 1 = video, 2= audio
class ProfileFeedDetailScreen extends StatefulWidget {
  ProfileFeedDetailScreen({
    super.key,
    this.index,
    this.fromMain,
    this.shareURL,
    this.mediaURL,
    this.userName,
    this.caption,
    this.userProfile,
    this.displayname,
    this.thumbnail,
    required this.mediaType,
    this.commentCount,
    required this.feedID,
    this.isBookmark,
    this.containComment,
    this.myReaction,
    this.createTime,
    this.fromBookmark,
    this.bookmarkList,
    this.likeCount,
    required this.isPrivate,
  });
  int? index;
  String? mediaURL;
  int? commentCount;
  bool? containComment;
  int? likeCount;
  bool? isBookmark;
  int feedID;
  String? shareURL;
  bool? fromMain;
  String? userProfile;
  String? userName;
  String? caption;
  String? thumbnail;
  String? displayname;
  int mediaType;
  dynamic myReaction;
  DateTime? createTime;
  bool? fromBookmark;
  List? bookmarkList;
  bool isPrivate;

  @override
  State<ProfileFeedDetailScreen> createState() =>
      _ProfileFeedDetailScreenState();
}

class _ProfileFeedDetailScreenState extends State<ProfileFeedDetailScreen> {
  late VideoPlayerController _controller;
  HomeFeedController homeFeedController = Get.put(HomeFeedController());

  void initState() {
    super.initState();
    _isPlaying.value = false;
    getData();
    widget.mediaURL == null || widget.mediaURL == ""
        ? isMediaAvilable.value = false
        : isMediaAvilable.value = true;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      widget.containComment == true ? setBottomSheet() : false;
    });
  }

  setBottomSheet() async {
    homeFeedController.getCommentListDataModel.clear();
    homeFeedController.currentCommentPage.value = 1;

    await homeFeedController.getComment(widget.feedID).whenComplete(() async {
      homeFeedController.commentController.clear();
      return await openCommentlistModel(
        context,
        widget.feedID,
        true,
      );
    });
  }

  RxBool isViewMore = false.obs;

  getData() async {
    print("Cehck type --> ${widget.mediaType}, ${widget.mediaURL}");
    homeFeedController.CommentCount.value =
        int.parse(widget.commentCount.toString());
    homeFeedController.ReactionCount.value =
        int.parse(widget.likeCount.toString());
    homeFeedController.isBookMarkedtemp.value = widget.isBookmark!;
    widget.mediaType == 1
        ? await setFile().whenComplete(() {
            setState(() {});
          })
        : widget.mediaType == 2
            ? await setAudio()
            : null;
  }

  RxBool isMediaAvilable = true.obs;

  Future setFile() async {
    try {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.mediaURL!))
            ..initialize().then((_) {
              _isPlaying.value = true;
              _isShowSlider.value = true;
              setState(() {});
            })
            ..addListener(() {
              setState(() {});
            });
      ;
      await _controller.play();
    } catch (e) {
      Toaster().warning("Please wait..");
    }
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = (hours < 10) ? '0$hours' : '$hours';
    String minutesStr = (minutes < 10) ? '0$minutes' : '$minutes';
    String secondsStr =
        (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  Future<void> _playAudio(String url) async {
    await _audioPlayer!.play(UrlSource(url));
    setState(() {
      _isShowSlider.value = true;
      _isPlaying.value = true;
    });
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer!.pause();
    setState(() {
      _isPlaying.value = false;
    });
  }

  Future<void> _seekAudio(Duration position) async {
    await _audioPlayer!.seek(position);
  }

  RxBool _isPlaying = false.obs;
  RxBool _isShowSlider = false.obs;

  void _togglePlaying() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      _isPlaying.value = false;
    } else {
      _controller.play();
      _isPlaying.value = true;
    }
  }

  void _onSeek(double value) {
    final duration = _controller.value.duration;
    final newPosition = value * duration.inMilliseconds;
    _controller.seekTo(Duration(milliseconds: newPosition.round()));
  }

  setAudio() async {
    widget.mediaURL == "" ? null : await setAudioFile(widget.mediaURL);
    Duration? dd = await _audioPlayer!.getDuration();

    _duration.value = dd!;
    List<String> parts = _duration.value.toString().split(".");
    duration_min.value = parts[0];

    _audioPlayer.onPositionChanged.listen((position) {
      _position.value = position;
      List<String> parts = _position.toString().split(".");
      position_min.value = parts[0];
    });
  }

  AudioPlayer _audioPlayer = AudioPlayer();
  Rx<Duration> _duration = const Duration().obs;
  Rx<Duration> _position = const Duration().obs;
  RxString duration_min = "0:00:00".obs;
  RxString position_min = "0:00:00".obs;

  setAudioFile(url) async {
    try {
      await _audioPlayer?.play(DeviceFileSource(url)).whenComplete(() {
        _isShowSlider.value = true;
      });
      setState(() {
        _isPlaying.value = true;
      });
    } catch (e) {
      Toaster().warning("Please wait..");
    }
  }

  onwillPop() {
    if (widget.mediaType == 0) {
      widget.fromMain == true
          ? Get.offAll(() => HomePage(
                pageIndex: 0,
              ))
          : Get.back();
    }
    if (widget.mediaType == 1) {
      _controller.dispose();
      widget.fromMain == true
          ? Get.offAll(() => HomePage(
                pageIndex: 0,
              ))
          : Get.back();
    }
    if (widget.mediaType == 2) {
      _audioPlayer.audioCache.loadedFiles.clear();
      _audioPlayer.dispose();
      widget.fromMain == true
          ? Get.offAll(() => HomePage(
                pageIndex: 0,
              ))
          : Get.back();
    }
    if (widget.mediaURL == null || widget.mediaURL == "") {
      widget.fromMain == true
          ? Get.offAll(() => HomePage(
                pageIndex: 0,
              ))
          : Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Checl passing status ==> ${widget.userProfile}");
    return WillPopScope(
      onWillPop: () => onwillPop(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: Get.height * 0.15,
                ),
                Expanded(
                  child: Container(
                    width: Get.width,
                    color: Colors.black,
                    child: isMediaAvilable.value == false
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Insets.i50),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.2,
                                  ),
                                  HashTagText(
                                    text: widget.caption ?? "",
                                    basicStyle: TextStyle(
                                      fontSize: FontSizes.s18,
                                      color: MyColors.whiteColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: Fonts.poppins,
                                    ),
                                    decoratedStyle: TextStyle(
                                      fontSize: FontSizes.s18,
                                      color: MyColors.greenColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: Fonts.poppins,
                                    ),
                                    onTap: (text) {
                                      homeFeedController.selectedTopic.value =
                                          text.replaceAll('#', '');
                                      homeFeedController.getSeedsByTopic(true);
                                      HomeController homeController =
                                          Get.put(HomeController());
                                      homeController.pageIndex.value = 0;
                                      Get.back();
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        : widget.mediaType == 0
                            ? ImageView()
                            : widget.mediaType == 1
                                ? videoView()
                                : audioView(),
                  ),
                ),
              ],
            ),
            _isShowSlider.value == false
                ? const SizedBox()
                : widget.mediaType == 1
                    ? videoSldier()
                    : audioSlider(),
            //! Header app bar
            Positioned(
              top: Insets.i35,
              left: Insets.i20,
              right: Insets.i20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        if (widget.mediaType == 0) {
                          widget.fromMain == true
                              ? Get.offAll(() => HomePage(
                                    pageIndex: 0,
                                  ))
                              : Get.back();
                        }
                        if (widget.mediaType == 1) {
                          _controller.dispose();
                          widget.fromMain == true
                              ? Get.offAll(() => HomePage(
                                    pageIndex: 0,
                                  ))
                              : Get.back();
                        }
                        if (widget.mediaType == 2) {
                          _audioPlayer.audioCache.loadedFiles.clear();
                          _audioPlayer.dispose();
                          widget.fromMain == true
                              ? Get.offAll(() => HomePage(
                                    pageIndex: 0,
                                  ))
                              : Get.back();
                        }
                        if (widget.mediaURL == null || widget.mediaURL == "") {
                          widget.fromMain == true
                              ? Get.offAll(() => HomePage(
                                    pageIndex: 0,
                                  ))
                              : Get.back();
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: Insets.i10,
                  ),
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                          onTap: () {
                            storage.read(MyStorage.userName) == widget.userName
                                ? Get.to(() => UserProfileScreenbackup(
                                      fromProfile: true,
                                      userName:
                                          storage.read(MyStorage.userName),
                                    ))
                                : Get.to(() => UserProfileScreenbackup(
                                      fromProfile: false,
                                      userName: widget.userName ?? "",
                                    ));
                          },
                          child: UnicornOutlineButton(
                            strokeWidth: 2,
                            radius: 100,
                            gradient: LinearGradient(
                              colors: [MyColors.greenColor, MyColors.redColor],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            child: Container(
                              height: Insets.i60,
                              width: Insets.i60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Insets.i12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: CustomImageView(
                                    isProfilePicture: true,
                                    imagePathOrUrl: widget.userProfile ==
                                                null ||
                                            widget.userProfile == ""
                                        ? ""
                                        : "$baseForImage${widget.userProfile}",
                                    radius: 100),
                              ),
                            ),
                            onPressed: () {},
                          ))),
                  const SizedBox(
                    width: Insets.i5,
                  ),
                  Expanded(
                    flex: widget.userName != storage.read(MyStorage.userName)
                        ? 9
                        : 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          textOverflow: TextOverflow.ellipsis,
                          text_name: "${widget.displayname}" ?? "N/A",
                          txtcolor: MyColors.whiteColor,
                          fontWeight: FontWeight.w500,
                          txtfontsize: FontSizes.s14,
                        ),
                        MyText(
                          text_name: homeFeedController.timeDiffrance(
                              widget.createTime ?? DateTime.now()),
                          txtcolor: MyColors.grayColor,
                          fontWeight: FontWeight.w400,
                          txtfontsize: FontSizes.s12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: Insets.i10,
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        await homeFeedController.bookMarkTheFeed(widget.feedID,
                            fromProfile: true,
                            bookmarkValue: widget.isBookmark);

                        widget.fromBookmark == true
                            ? widget.bookmarkList?.removeAt(widget.index!)
                            : null;
                      },
                      child: Obx(
                        () => Container(
                            height: Insets.i50,
                            width: Insets.i50,
                            padding: const EdgeInsets.all(Insets.i12),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.grayColor.withOpacity(.3)),
                            child: homeFeedController.isBookMarkedtemp.value ==
                                    true
                                ? SvgPicture.asset(MyImageURL.unbookmarkImage)
                                : SvgPicture.asset(MyImageURL.bookmarkImage)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: Insets.i10,
                  ),
                  widget.userName != storage.read(MyStorage.userName)
                      ? const SizedBox()
                      : Expanded(
                          flex: 2,
                          child: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              icon: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  height: Insets.i50,
                                  width: Insets.i50,
                                  // padding: const EdgeInsets.all(Insets.i12),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          MyColors.grayColor.withOpacity(.3)),
                                  child: Center(
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: MyColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              onSelected: (String result) {
                                result == "Delete"
                                    ? commonDialog(
                                        context,
                                        "Delete",
                                        "Are you sure You want to Delete this Seed?",
                                        onTap: () async {
                                          await homeFeedController
                                              .deleteFeedAPI(widget.feedID);
                                        },
                                      )
                                    : result == "Edit"
                                        ? Get.to(() => EditPostScreen(
                                              postType: widget.mediaType,
                                              feedId: widget.feedID,
                                              mediaURL: widget.mediaURL,
                                              caption: widget.caption,
                                              thumbnailURL: widget.thumbnail,
                                              isPrivate: widget.isPrivate,
                                            ))
                                        : homeFeedController.bookMarkTheFeed(
                                            widget.feedID,
                                            bookmarkValue: widget.isBookmark,
                                            ind: widget.index);
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Edit',
                                      child: ListTile(
                                        leading: Icon(Icons.edit_outlined),
                                        title: Text('Edit'),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete_outlined),
                                        title: Text('Delete'),
                                      ),
                                    ),
                                  ]),
                        )
                ],
              ),
            ),
            Positioned(
                right: Insets.i20,
                bottom: widget.mediaType == 0 ? Insets.i50 : Insets.i150,
                child: Container(
                  height: Get.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          ShowShareBottomSheet(
                              context,
                              widget.feedID,
                              widget.shareURL,
                              widget.caption ?? "",
                              widget.mediaType != 0
                                  ? "$baseForImage${homeFeedController.homeFeedList[widget.index!].thumbnailURL}"
                                  : "$baseForImage${widget.mediaURL}");
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              MyImageURL.detailshare,
                              height: Insets.i25,
                              width: Insets.i25,
                            ),
                            const SizedBox(
                              height: Insets.i10,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          HomeFeedController homeFeedController =
                              Get.put(HomeFeedController());
                          homeFeedController.getCommentListDataModel.clear();
                          homeFeedController.currentCommentPage.value = 1;

                          await homeFeedController
                              .getComment(widget.feedID)
                              .whenComplete(() async {
                            homeFeedController.commentController.clear();
                            return await openCommentlistModel(
                                context, widget.feedID, true,
                                ind: widget.index);
                          });
                          setState(() {});
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              MyImageURL.detailcomment,
                              height: Insets.i25,
                              width: Insets.i25,
                            ),
                            const SizedBox(
                              height: Insets.i5,
                            ),
                            Obx(
                              () => MyText(
                                text_name: homeFeedController.CommentCount.value
                                    .toString(),
                                txtcolor: MyColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                txtfontsize: FontSizes.s14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await homeFeedController
                              .reactionAPI(widget.feedID, true, false,
                                  ind: widget.index)
                              .whenComplete(() {
                            setState(() {
                              widget.myReaction == null
                                  ? widget.myReaction = "love"
                                  : widget.myReaction = null;
                            });
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              widget.myReaction != null
                                  ? MyImageURL.LikedImage
                                  : MyImageURL.like,
                              height: Insets.i25,
                              width: Insets.i25,
                              color: widget.myReaction != null
                                  ? null
                                  : Colors.white,
                            ),
                            const SizedBox(
                              height: Insets.i5,
                            ),
                            Obx(
                              () => MyText(
                                text_name: homeFeedController
                                    .ReactionCount.value
                                    .toString(),
                                txtcolor: MyColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                txtfontsize: FontSizes.s14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

            //! CAPTION VIEW
            if (isMediaAvilable.value)
              Positioned(
                left: Insets.i20,
                bottom: widget.mediaType == 0 ? Insets.i50 : Insets.i150,
                right: Insets.i60,
                child: SizedBox(
                  height: Get.height * 0.3,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            // () => MyText(
                            //   txtAlign: TextAlign.left,
                            //   text_name: viewText(
                            //       widget.caption.toString(), !isViewMore.value),
                            //   txtcolor: MyColors.whiteColor,
                            //   fontWeight: FontWeight.w500,
                            //   txtfontsize: FontSizes.s14,
                            // ),
                            () => HashTagText(
                              text: viewText(
                                  widget.caption.toString(), !isViewMore.value),
                              basicStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: FontSizes.s14,
                                color: MyColors.whiteColor,
                              ),
                              decoratedStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: FontSizes.s14,
                                color: MyColors.greenColor,
                              ),
                              onTap: (text) {
                                homeFeedController.selectedTopic.value =
                                    text.replaceAll('#', '');
                                homeFeedController.getSeedsByTopic(true);
                                HomeController homeController =
                                    Get.put(HomeController());
                                homeController.pageIndex.value = 0;
                                Get.back();
                                Get.back();
                              },
                            ),
                          ),
                          widget.caption!.length > 50
                              ? Obx(() => InkWell(
                                    onTap: () {
                                      isViewMore.value = !isViewMore.value;
                                    },
                                    child: MyText(
                                      text_name: !isViewMore.value
                                          ? "View more"
                                          : "View less",
                                      fontWeight: FontWeight.bold,
                                      txtfontsize: FontSizes.s14,
                                      txtcolor: MyColors.whiteColor,
                                      txtAlign: TextAlign.left,
                                    ),
                                  ))
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget videoView() {
    return _controller.value.isInitialized
        ? Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : mediaLoader();
  }

  Widget ImageView() {
    return CustomImageView(
      isProfilePicture: true,
      imagePathOrUrl: "$baseForImage${widget.mediaURL}",
      fit: BoxFit.fitWidth,
    );
  }

  Widget audioView() {
    return _isPlaying.value != true
        ? mediaLoader()
        : widget.thumbnail == null || widget.thumbnail == ""
            ? Image.asset(
                MyImageURL.audioImage,
                fit: BoxFit.fitWidth,
              )
            : CustomImageView(
                isProfilePicture: false,
                imagePathOrUrl: widget.thumbnail,
              );
  }

  Widget audioSlider() {
    return Positioned(
        left: Insets.i20,
        bottom: Insets.i40,
        right: Insets.i20,
        child: Column(
          children: [
            Obx(() => Slider.adaptive(
                  min: 0.0,
                  max: _duration.value.inSeconds.toDouble(),
                  value: _position.value.inSeconds.toDouble(),
                  onChanged: (double value) {
                    _seekAudio(Duration(seconds: value.toInt()));
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => MyText(
                      text_name: "${position_min.value}",
                      txtcolor: MyColors.whiteColor,
                    )),
                GestureDetector(
                  onTap: () async {
                    _isPlaying.value
                        ? await _pauseAudio()
                        : await setAudioFile(widget.mediaURL);

                    Platform.isAndroid &&
                            position_min.value == duration_min.value
                        ? await setAudioFile(widget.mediaURL)
                        : Platform.isIOS && position_min.value == "0:00:00"
                            ? await setAudioFile(widget.mediaURL)
                            : null;
                    setState(() {});
                  },
                  child: Center(
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      width: 48,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: MyColors.redColor),
                      child: Obx(
                        () => Platform.isAndroid
                            ? _isPlaying.value &&
                                    position_min.value != duration_min.value
                                ? Icon(
                                    Icons.pause,
                                    color: MyColors.whiteColor,
                                  )
                                : SvgPicture.asset(
                                    MyImageURL.playIcon,
                                    color: MyColors.whiteColor,
                                  )
                            : _isPlaying.value &&
                                    position_min.value != "0:00:00"
                                ? Icon(
                                    Icons.pause,
                                    color: MyColors.whiteColor,
                                  )
                                : SvgPicture.asset(
                                    MyImageURL.playIcon,
                                    color: MyColors.whiteColor,
                                  ),
                      ),
                    ),
                  ),
                ),
                Obx(() => MyText(
                      text_name: "${duration_min}",
                      txtcolor: MyColors.whiteColor,
                    )),
              ],
            )
          ],
        ));
  }

  Widget videoSldier() {
    return Positioned(
        left: Insets.i20,
        bottom: Insets.i40,
        right: Insets.i20,
        child: Column(
          children: [
            Obx(
              () => _isShowSlider.value == true
                  ? Slider.adaptive(
                      min: 0.0,
                      value: _controller.value.position.inMilliseconds /
                          _controller.value.duration.inMilliseconds,
                      onChanged: (value) {
                        _onSeek(value);
                      },
                    )
                  : const SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text_name: formatTime(_controller.value.position.inSeconds),
                  txtcolor: MyColors.whiteColor,
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () async {
                      _togglePlaying();
                      setState(() {});
                    },
                    child: Center(
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        width: 48,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: MyColors.redColor),
                        child: _isPlaying.value &&
                                _controller.value.position.inSeconds !=
                                    _controller.value.duration.inSeconds
                            ? Icon(
                                Icons.pause,
                                color: MyColors.whiteColor,
                              )
                            : SvgPicture.asset(
                                MyImageURL.playIcon,
                                color: MyColors.whiteColor,
                              ),
                      ),
                    ),
                  ),
                ),
                MyText(
                  text_name: formatTime(_controller.value.duration.inSeconds),
                  txtcolor: MyColors.whiteColor,
                ),
              ],
            )
          ],
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.mediaType == 1 ? _controller.dispose() : null;
    widget.mediaType == 2 ? _audioPlayer.dispose() : null;

    final ct = Get.put(LoginController());
    ct.isNotification == true ? ct.isNotification = false : false;
    super.dispose();
  }

  viewText(detail, isview) {
    if (detail.length < 50) {
      return detail;
    } else if (detail.length > 50) {
      if (isview) {
        return "${detail.substring(0, 50)}";
      } else {
        return detail;
      }
    } else {
      return detail;
    }
  }
}

class UnicornOutlineButton extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final VoidCallback _callback;
  final double _radius;

  UnicornOutlineButton({
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
    required VoidCallback onPressed,
  })  : this._painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        this._child = child,
        this._callback = onPressed,
        this._radius = radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _callback,
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: _callback,
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {required double strokeWidth,
      required double radius,
      required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
