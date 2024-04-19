import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';

//! mediatype 0 = image, 1 = video, 2= audio
class DraftDetailScreen extends StatefulWidget {
  DraftDetailScreen({
    super.key,
    this.index,
    this.mediaURL,
    this.userName,
    this.caption,
    this.userProfile,
    this.displayname,
    this.thumbnail,
    this.mediaType,
  });
  int? index;
  String? mediaURL;
  String? userProfile;
  String? userName;
  String? caption;
  String? thumbnail;
  String? displayname;
  int? mediaType;
  @override
  State<DraftDetailScreen> createState() => _DraftDetailScreenState();
}

class _DraftDetailScreenState extends State<DraftDetailScreen> {
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
      _controller = VideoPlayerController.file(File(widget.mediaURL!))
        ..initialize().then((_) {
          log("Check my file path ==> 11 ${widget.mediaURL}");
          _isPlaying.value = true;
          _isShowSlider.value = true;
          setState(() {});
        })
        ..addListener(() {
          setState(() {});
        });

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
  Rx<Duration> _duration = Duration().obs;
  Rx<Duration> _position = Duration().obs;
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
      // Toaster().warning("Some thing went wrong");
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
                ? SizedBox()
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
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: Insets.i10,
                      ),
                      GestureDetector(
                        onTap: () {
                          // storage.read(MyStorage.userName) == widget.userName
                          //     ? Get.to(() => UserProfileScreenbackup(
                          //           fromProfile: true,
                          //           userName: storage.read(MyStorage.userName),
                          //         ))
                          //     : Get.to(() => UserProfileScreenbackup(
                          //           fromProfile: false,
                          //           userName: widget.userName ?? "",
                          //         ));
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
                                  padding: EdgeInsets.all(5),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

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
      imagePathOrUrl: widget.mediaURL,
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
                  : SizedBox(),
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

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
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
