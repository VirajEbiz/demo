import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/Home%20Feed/home_widgets/share_bottom_sheet.dart';
import 'package:watermel/app/Views/addComment/addcomments.dart';
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
class FeedDetailScreen extends StatefulWidget {
  FeedDetailScreen(
      {super.key,
      this.index,
      this.mediaURL,
      this.userName,
      this.caption,
      this.userProfile,
      this.displayname,
      this.thumbnail,
      this.mediaType,
      this.commentCount,
      this.feedID,
      this.isBookmark,
      this.createTime,
      this.shareURL,
      this.myReaction,
      this.likeCount});
  int? index;
  String? mediaURL;
  int? commentCount;
  int? likeCount;
  bool? isBookmark;
  int? feedID;
  String? shareURL;
  String? userProfile;
  String? userName;
  String? caption;
  String? thumbnail;
  String? displayname;

  int? mediaType;
  DateTime? createTime;
  String? myReaction;
  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  late VideoPlayerController _controller;
  HomeFeedController homeFeedController = Get.put(HomeFeedController());

  void initState() {
    super.initState();
    _isPlaying.value = false;
    getData();
    widget.mediaURL == null || widget.mediaURL == ""
        ? isMediaAvilable.value = false
        : isMediaAvilable.value = true;
  }

  RxBool isViewMore = false.obs;

  getData() async {
    log("Check media url ===> ${widget.feedID}");

    homeFeedController.CommentCount.value =
        int.parse(widget.commentCount.toString());
    homeFeedController.ReactionCount.value =
        int.parse(widget.likeCount.toString());
    homeFeedController.isBookMarkedtemp.value = widget.isBookmark!;
    widget.mediaType == 1
        ? await setFile().whenComplete(() {
            print("Check dataaaa ==> 11");
            setState(() {});
          })
        : widget.mediaType == 2
            ? await setAudio()
            : null;
  }

  RxBool isMediaAvilable = true.obs;

  Future setFile() async {
    log("check 1-1--1-1-1");
    log("check 1-1--1-1-1 ${widget.mediaURL!}");
    log("check 1-1--1-1-1 ${widget.mediaType!}");
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
      Toaster().warning(e.toString());
    }
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
      await _audioPlayer.play(DeviceFileSource(url)).whenComplete(() {
        _isShowSlider.value = true;
      });
      setState(() {
        _isPlaying.value = true;
      });
    } catch (e) {
      // print("Check data ==> ${e}");
      // Toaster().warning("Please wait..");
    }
  }

  onwillPop() {
    if (widget.mediaType == 0) {
      Get.back();
    }
    if (widget.mediaType == 1) {
      _controller.dispose();
      Get.back();
    }
    if (widget.mediaType == 2) {
      _audioPlayer.audioCache.loadedFiles.clear();
      _audioPlayer.dispose();
      Get.back();
    }
    if (widget.mediaURL == null || widget.mediaURL == "") {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        ? Center(
                            child: MyText(
                              fontWeight: FontWeight.w400,
                              text_name: "No Media",
                              txtfontsize: FontSizes.s18,
                              txtcolor: MyColors.whiteColor,
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (widget.mediaType == 0) {
                            Get.back();
                          }
                          if (widget.mediaType == 1) {
                            _controller.dispose();
                            Get.back();
                          }
                          if (widget.mediaType == 2) {
                            _audioPlayer.audioCache.loadedFiles.clear();
                            _audioPlayer.dispose();
                            Get.back();
                          }
                          if (widget.mediaURL == null ||
                              widget.mediaURL == "") {
                            Get.back();
                          }
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: Insets.i10,
                      ),
                      GestureDetector(
                        onTap: () {
                          storage.read(MyStorage.userName) == widget.userName
                              ? Get.to(() => UserProfileScreenbackup(
                                    fromProfile: true,
                                    userName: storage.read(MyStorage.userName),
                                  ))
                              : Get.to(() => UserProfileScreenbackup(
                                    fromProfile: false,
                                    userName: widget.userName ?? "",
                                  ));
                        },
                        child: Row(
                          children: [
                            UnicornOutlineButton(
                              strokeWidth: 2,
                              radius: 100,
                              gradient: LinearGradient(
                                colors: [
                                  MyColors.greenColor,
                                  MyColors.redColor
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              child: Container(
                                height: Insets.i60,
                                width: Insets.i60,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Insets.i12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CustomImageView(
                                      isProfilePicture: true,
                                      imagePathOrUrl: widget.userProfile,
                                      radius: 100),
                                ),
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(
                              width: Insets.i10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  text_name: widget.displayname ?? "N/A",
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     await homeFeedController
                  //         .bookMarkTheFeed(widget.feedID,
                  //             bookmarkValue: widget.isBookmark,
                  //             ind: widget.index,
                  //             fromProfile: false)
                  //         .whenComplete(() {
                  //       setState(() {});
                  //     });
                  //   },
                  //   child: Obx(
                  //     () => Container(
                  //         height: Insets.i50,
                  //         width: Insets.i50,
                  //         padding: const EdgeInsets.all(Insets.i12),
                  //         decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: MyColors.grayColor.withOpacity(.3)),
                  //         child: homeFeedController.isBookMarkedtemp.value ==
                  //                 true
                  //             ? SvgPicture.asset("assets/images/unbookMark.svg")
                  //             : SvgPicture.asset("assets/images/bookMark.svg")),
                  //   ),
                  // ),
                  popupButtonWidget(),
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
                              widget.caption,
                              widget.thumbnail);
                          // String textToShare = widget.shareURL!;

                          // Share.share(textToShare);
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
                          homeFeedController.getCommentListDataModel.clear();
                          homeFeedController.currentCommentPage.value = 1;

                          await homeFeedController
                              .getComment(
                            homeFeedController.homeFeedList[widget.index!].id,
                          )
                              .whenComplete(() async {
                            homeFeedController.commentController.clear();
                            return await openCommentlistModel(
                                context,
                                homeFeedController
                                    .homeFeedList[widget.index!].id,
                                false,
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
                              .reactionAPI(
                                  homeFeedController
                                      .homeFeedList[widget.index!].id,
                                  false,
                                  false,
                                  ind: widget.index)
                              .whenComplete(() {
                            setState(() {
                              if (widget.myReaction == null ||
                                  widget.myReaction == "") {
                                widget.myReaction = "love";

                                homeFeedController.ReactionCount.value =
                                    homeFeedController.ReactionCount.value + 1;
                                homeFeedController.homeFeedList[widget.index!]
                                    .myReaction = "love";
                                int temp = homeFeedController
                                        .homeFeedList[widget.index!]
                                        .reactionsCount ??
                                    1;
                                temp++;
                                homeFeedController.homeFeedList[widget.index!]
                                    .reactionsCount = temp;
                                homeFeedController.ReactionCount.value =
                                    homeFeedController
                                            .homeFeedList[widget.index!]
                                            .reactionsCount ??
                                        0;
                                homeFeedController.homeFeedList.refresh();
                              } else {
                                widget.myReaction = null;

                                homeFeedController.ReactionCount.value =
                                    homeFeedController.ReactionCount.value - 1;
                                homeFeedController.homeFeedList[widget.index!]
                                    .myReaction = null;
                                int temp = homeFeedController
                                        .homeFeedList[widget.index!]
                                        .reactionsCount ??
                                    1;
                                temp--;
                                homeFeedController.homeFeedList[widget.index!]
                                    .reactionsCount = temp;
                                homeFeedController.ReactionCount.value =
                                    homeFeedController
                                            .homeFeedList[widget.index!]
                                            .reactionsCount ??
                                        0;
                                homeFeedController.homeFeedList.refresh();
                              }
                            });
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              MyImageURL.likecomment,
                              height: Insets.i25,
                              width: Insets.i25,
                              color: widget.myReaction != null
                                  ? Colors.red
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
            Positioned(
              left: Insets.i20,
              bottom: widget.mediaType == 0 ? Insets.i50 : Insets.i150,
              right: Insets.i60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => MyText(
                      txtAlign: TextAlign.left,
                      text_name: viewText(
                          widget.caption.toString(), !isViewMore.value),
                      txtcolor: MyColors.whiteColor,
                      fontWeight: FontWeight.w500,
                      txtfontsize: FontSizes.s14,
                    ),
                  ),
                  widget.caption!.length > 50
                      ? Obx(() => InkWell(
                            onTap: () {
                              isViewMore.value = !isViewMore.value;
                            },
                            child: MyText(
                              text_name:
                                  !isViewMore.value ? "View more" : "View less",
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
          ],
        ),
      ),
    );
  }

  Widget popupButtonWidget() {
    return PopupMenuButton<String>(
        padding: const EdgeInsets.only(left: Insets.i35),
        icon: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: Insets.i50,
            width: Insets.i50,
            padding: const EdgeInsets.all(Insets.i12),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.grayColor.withOpacity(.3)),
            child: Icon(
              Icons.more_vert,
              color: MyColors.whiteColor,
            ),
          ),
        ),
        onSelected: (String result) {
          result == "report"
              ? commonDialog(
                  context,
                  "Report",
                  "Are you sure You want to report this Post?",
                  onTap: () async {
                    Get.back();
                    await homeFeedController
                        .reportTheSeed(widget.feedID.toString());
                  },
                )
              : homeFeedController.bookMarkTheFeed(widget.feedID,
                  ind: widget.index,
                  bookmarkValue:
                      homeFeedController.homeFeedList[widget.index!].bookmark);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'report',
                child: ListTile(
                  leading: Icon(Icons.report),
                  title: Text('Report'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'bookmark',
                child: ListTile(
                  leading: Icon(
                      homeFeedController.homeFeedList[widget.index!].bookmark ==
                              true
                          ? Icons.bookmark_add_rounded
                          : Icons.bookmark_add_outlined),
                  title: Text(
                      homeFeedController.homeFeedList[widget.index!].bookmark ==
                              true
                          ? 'bookmarked'
                          : 'Bookmark'),
                ),
              ),
            ]);
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
      isProfilePicture: false,
      imagePathOrUrl: "$baseUrl${widget.mediaURL}",
      fit: BoxFit.fitWidth,
    );
  }

  Widget audioView() {
    return _isShowSlider.value != true
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
                        print(
                            "Check ==> ${_controller.value.duration.inSeconds}");
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
    if (_isPlaying.value == true && widget.mediaType == 2) {
      _isPlaying.value = false;
      _audioPlayer.dispose();
    }
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
