import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:light_compressor/light_compressor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
import 'package:watermel/app/Views/create_new_feed/create_new_feed.dart';
import 'package:watermel/app/Views/draft/edit_draft-screen.dart';
import 'package:watermel/app/Views/user_profile/edit_profile.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/method_channel/generate_thumnail_class.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/common_text.dart';

class CapturedVideoPreview extends StatefulWidget {
  CapturedVideoPreview(
      {super.key,
      required this.videoURL,
      required this.fromEdit,
      required this.ind,
      this.selectedType,
      this.thumbnailURL,
      this.caption,
      this.isPrivate,
      required this.draftList});
  bool? fromEdit, isPrivate;
  String? videoURL, thumbnailURL, caption;
  int? ind;
  List? draftList = [];
  int? selectedType;

  @override
  State<CapturedVideoPreview> createState() => CapturedVideoPreviewState();
}

class CapturedVideoPreviewState extends State<CapturedVideoPreview> {
  late VideoPlayerController _controller;
  HomeFeedController homeFeedController = Get.put(HomeFeedController());

  void initState() {
    super.initState();
    getThumnail();
    getData();
    print("Check thumnial video ==> ${widget.videoURL}");
  }

  getThumnail() async {
    Platform.isAndroid
        ? await generateThumbnailAndroid(widget.videoURL)
        : await _generateThumbnail(widget.videoURL);
  }

  Future<void> _generateThumbnail(videoFilePath) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoFilePath,
      imageFormat: ImageFormat.PNG,
      maxHeight: Get.height.toInt(),
      quality: 200,
    );

    widget.thumbnailURL = thumbnailPath;
    print("Check thumnial video ==> 2 ${widget.thumbnailURL}");
  }

  Future<void> generateThumbnailAndroid(videoFilePath) async {
    String? thumbnailPath = await MyCustomVideoThumbnail.generateThumbnail(
        videoFilePath, "thumbnailFilename");
    widget.thumbnailURL = thumbnailPath;
  }

  int maxSize = 20 * 1024 * 1024; //20 MB
  int minSize = 500 * 1024;
  getData() async {
    await setFile().whenComplete(() {
      setState(() {});
    });
  }

  Future setFile() async {
    log("Check my file path ==> ${widget.videoURL}");
    try {
      _controller = VideoPlayerController.file(File(widget.videoURL!))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      await _controller.play();
    } catch (e) {
      Toaster().warning(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Check ==>  $baseUrl${widget.videoURL}");
    log("Check ==>  ${widget.fromEdit}");
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              height: Get.height * 0.9,
              width: Get.width,
              color: Colors.black,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _controller.value != null && _controller.value.isInitialized
                        ? Center(
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          )
                        : Center(
                            child: MyText(
                              text_name: "Loading....",
                              txtcolor: MyColors.whiteColor,
                              fontWeight: FontWeight.w500,
                              txtfontsize: FontSizes.s15,
                            ),
                          ),
                    _controller.value.isPlaying == true
                        ? SizedBox()
                        : Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                width: 48,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        MyColors.whiteColor.withOpacity(0.8)),
                                child: SvgPicture.asset(MyImageURL.playIcon),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: Insets.i35,
            left: Insets.i20,
            child: InkWell(
              onTap: () {
                Get.back();
                // widget.fromEdit == true
                //     ? Get.offAll(
                //         () => EditDraftScreen(
                //               fromVideoRecording: false,
                //               isPrivate: widget.isPrivate,
                //               caption: widget.caption,
                //               thumbnailURL: widget.thumbnailURL,
                //               index: widget.ind,
                //               postType: widget.selectedType,
                //               mediaURL: widget.videoURL,
                //             ),
                //         transition: Transition.leftToRight,
                //         duration: Duration(milliseconds: 400))
                //     : Get.offAll(
                //         () => CreateNewFeedScreen(
                //               caption: widget.caption,
                //               thumbnailURl: widget.thumbnailURL,
                //               videoPath: widget.videoURL,
                //               selectedType: widget.ind,
                //               fromVideoRecording: false,
                //             ),
                //         transition: Transition.leftToRight,
                //         duration: Duration(milliseconds: 400));
              },
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: Insets.i35,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showLoader();
            File file = File(await getCompresssedVideo(widget.videoURL) ?? "");
            int sizeInBytes = await file.length();
            double sizeInKB = sizeInBytes / 1024;
            widget.videoURL = file.path;
            hideLoader();
            if (sizeInBytes > maxSize) {
              Toaster().warning("File size must be between 500 KB to 20 MB");
              return;
            } else {
              await _controller.dispose();
              log("check data ==> # ${widget.fromEdit}");
              log("check data ==> # ${widget.selectedType}");
              log("check data ==> # 111${widget.thumbnailURL}");
              CreateFeedController createFeedController =
                  Get.put(CreateFeedController());
              createFeedController.selectedFilePath.value = file.path;
              createFeedController.selectedIndex = widget.selectedType!;
              createFeedController.generateThumbnail(file.path);
              Get.back();
              Get.back();
              // widget.fromEdit == true
              //     ? Get.offAll(() => EditDraftScreen(
              //           fromVideoRecording: true,
              //           isPrivate: widget.isPrivate,
              //           caption: widget.caption,
              //           thumbnailURL: widget.thumbnailURL,
              //           index: widget.ind,
              //           postType: widget.selectedType,
              //           mediaURL: widget.videoURL,
              //         ))
              //     : Get.offAll(() => CreateNewFeedScreen(
              //           caption: widget.caption,
              //           thumbnailURl: widget.thumbnailURL,
              //           selectedType: widget.selectedType,
              //           fromVideoRecording: true,
              //           videoPath: widget.videoURL,
              //         ));
            }
          },
          child: const Icon(
            Icons.send,
            color: Colors.white,
          )),
    );
  }

  final LightCompressor _lightCompressor = LightCompressor();

  Future<String?> getCompresssedVideo(inputPath) async {
    final Result response = await _lightCompressor.compressVideo(
      path: inputPath,
      videoQuality: VideoQuality.very_high,
      isMinBitrateCheckEnabled: false,
      video: Video(videoName: "compressedVideo.mp4"),
      android: AndroidConfig(isSharedStorage: false, saveAt: SaveAt.Downloads),
      ios: IOSConfig(saveInGallery: true),
    );
    if (response is OnSuccess) {
      final String outputFile = response.destinationPath;
      File file = File(outputFile);
      int sizeInBytes = await file.length();
      double sizeInKB = sizeInBytes / 1024;

      if (sizeInBytes > maxSize) {
        Toaster().warning("File size must be between 500 KB to 20 MB");
      }
      return sizeInBytes > maxSize ? null : outputFile;
      // use the file
    } else if (response is OnFailure) {
    } else if (response is OnCancelled) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
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
