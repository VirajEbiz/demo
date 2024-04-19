import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watermel/app/Views/camera/animated_widgets.dart';
import 'package:watermel/app/Views/camera/edit_video_page.dart';
import 'package:watermel/app/Views/camera/video_preview.dart';
import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
import 'package:watermel/app/Views/create_new_feed/create_new_feed.dart';
import 'package:watermel/app/Views/draft/edit_draft-screen.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/main.dart';

class CameraPage extends StatefulWidget {
  CameraPage(
      {super.key,
      required this.fromEdit,
      this.ind,
      this.draftList,
      this.thumbnailURL,
      this.caption,
      this.isPrivate,
      this.mediaURL,
      this.selectedType});
  bool? fromEdit, isPrivate;

  int? ind;
  List? draftList = [];
  int? selectedType;
  String? thumbnailURL, caption, mediaURL;
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  Timer? _timer;
  RxInt _secondsRemaining = 0.obs;
  RxInt currrentSecond = 0.obs;
  RxInt _currentCameraIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _secondsRemaining.value = is60Second.value == true ? 60 : 90;
  }

  @override
  void dispose() {
    controller?.dispose();

    _timer!.cancel();
    super.dispose();
  }

  RxString finalVideoPath = "".obs;
  RxInt tempSec = 0.obs;
  Future<void> _startVideoRecording() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String filePath = '$videoDirectory/${DateTime.now()}.mp4';
    finalVideoPath.value = filePath;
    try {
      await controller.startVideoRecording();
      isRecording.value = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        IsPause.value == true ? null : recordingDuration.value++;
        IsPause.value == true ? null : currrentSecond++;
        tempSec.value = recordingDuration.value;
        if (_secondsRemaining.value == 0) {
          // _timer!.cancel();
          _stopVideoRecording();
        } else {
          IsPause.value == true ? null : _secondsRemaining.value--;
        }
      });
    } on CameraException catch (e) {
      print(e);
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      isRecording.value = false;

      XFile video = await controller.stopVideoRecording();

      _timer!.cancel();

      if (!mounted) return;
      Get.to(() => CapturedVideoPreview(
            isPrivate: widget.isPrivate,
            caption: widget.caption,
            thumbnailURL: widget.thumbnailURL,
            draftList: widget.draftList,
            ind: widget.ind,
            selectedType: widget.selectedType,
            fromEdit: widget.fromEdit,
            videoURL: video.path,
          ));
      // Get.to(() => EditVideoPage(filePath: video.path));
    } on CameraException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (v) async {
        Get.back();
        // widget.fromEdit == true
        //     ? Get.offAll(
        //         () => EditDraftScreen(
        //               fromVideoRecording: false,
        //               isPrivate: widget.isPrivate,
        //               thumbnailURL: widget.thumbnailURL,
        //               postType: widget.selectedType,
        //               index: widget.ind,
        //               mediaURL:
        //                   widget.draftList?[widget.ind!]["videopath"] ?? "",
        //               draftList: widget.draftList,
        //             ),
        //         transition: Transition.leftToRight,
        //         duration: const Duration(milliseconds: 400))
        //     : Get.offAll(
        //         () => CreateNewFeedScreen(
        //               videoPath: widget.mediaURL,
        //               caption: widget.caption,
        //               thumbnailURl: widget.thumbnailURL,
        //               selectedType: widget.selectedType,
        //               fromVideoRecording: false,
        //             ),
        //         transition: Transition.leftToRight,
        //         duration: const Duration(milliseconds: 400));
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(
        //   title: const Text('Camera Example'),
        //   automaticallyImplyLeading: false,
        // ),
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                  aspectRatio: 1 / controller.value.aspectRatio,
                  child: CameraPreview(controller)),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _toggleCamera();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: const SizedBox(
                          height: 50,
                          width: 50,
                          child: Icon(
                            Icons.cameraswitch_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    animatedProgressButton(),
                    GestureDetector(
                      onTap: () {
                        isRecording.value != true
                            ? null
                            : _stopVideoRecording();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Obx(
                            () => Icon(
                              Icons.video_collection_rounded,
                              color: isRecording.value != true
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: Insets.i35,
              left: Insets.i20,
              child: InkWell(
                onTap: () {
                  Get.back();
                  // CreateFeedController createFeedController =
                  //     Get.put(CreateFeedController());
                  // widget.fromEdit == true
                  //     ? Get.offAll(
                  //         () => EditDraftScreen(
                  //               fromVideoRecording: false,
                  //               isPrivate: widget.isPrivate,
                  //               thumbnailURL: widget.thumbnailURL,
                  //               postType: widget.selectedType,
                  //               index: widget.ind,
                  //               mediaURL: widget.draftList?[widget.ind!]
                  //                       ["videopath"] ??
                  //                   "",
                  //               draftList: widget.draftList,
                  //             ),
                  //         transition: Transition.leftToRight,
                  //         duration: const Duration(milliseconds: 400))
                  //     : Get.offAll(
                  //         () => CreateNewFeedScreen(
                  //               videoPath: widget.mediaURL,
                  //               caption: widget.caption,
                  //               thumbnailURl: widget.thumbnailURL,
                  //               selectedType: widget.selectedType,
                  //               fromVideoRecording: false,
                  //             ),
                  //         transition: Transition.leftToRight,
                  //         duration: const Duration(milliseconds: 400));
                },
                child: const Icon(
                  Icons.close,
                  size: Insets.i35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RxBool is60Second = true.obs;
  switchSecond() {
    is60Second.value = !is60Second.value;
    _secondsRemaining.value = is60Second.value == true ? 60 : 90;
  }

  Future<void> _pauseRecording() async {
    print("In side the Pause");

    try {
      await controller.pauseVideoRecording();

      IsPause.value = true;
    } catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> _resumeRecording() async {
    print("In side the resume");
    IsPause.value = false;

    try {
      await controller.resumeVideoRecording();
      isRecording.value = true;
    } catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  void _initializeCamera() async {
    controller = CameraController(
      cameras![_currentCameraIndex.value],
      ResolutionPreset.veryHigh,
      enableAudio: true,
    );

    await controller.initialize();
    controller.getMaxZoomLevel().then((value) =>
        maxAvailableZoom.value = _currentCameraIndex.value == 1 ? 3.0 : value);
    controller
        .getMinZoomLevel()
        .then((value) => minAvailableZoom.value = value);
    setState(() {});
    if (!mounted) {
      return;
    }
  }

  void _toggleCamera() async {
    _currentCameraIndex.value =
        (_currentCameraIndex.value + 1) % cameras!.length;
    CameraDescription newCamera = cameras![_currentCameraIndex.value];
    await controller.setDescription(newCamera);
  }

  RxBool IsPause = false.obs;
  void _togglePausePLay() async {
    IsPause.value == true ? _resumeRecording() : _pauseRecording();
  }

  RxDouble minAvailableZoom = 1.0.obs;
  RxDouble maxAvailableZoom = 1.0.obs;
  RxDouble currentZoomLevel = 1.0.obs;

  RxBool isRecording = false.obs;
  ValueNotifier<int> recordingDuration = ValueNotifier(0);

  double _zoomLevel = 1.0; // Initial zoom level
  double _initialVerticalPosition = 0.0;
  void _updateZoomLevel(double delta) async {
    _zoomLevel = (_zoomLevel + delta).clamp(1.0, maxAvailableZoom.value);
    await controller.setZoomLevel(_zoomLevel);
  }

  Widget animatedProgressButton() {
    return GestureDetector(
      onLongPress: () async {
        if (isRecording.value == true) {
          IsPause.value == true ? await _resumeRecording() : null;
        } else {
          await _startVideoRecording();
        }
      },
      onLongPressEnd: (s) async {
        await _pauseRecording();
      },
      onTap: () {
        isRecording.value == true ? _togglePausePLay() : _startVideoRecording();
      },
      // onVerticalDragStart: (details) {
      //   isRecording.value == true && IsPause.value == false
      //       ? _initialVerticalPosition = details.globalPosition.dy
      //       : null;
      // },
      // onVerticalDragUpdate: (details) {
      //   final delta =
      //       (_initialVerticalPosition - details.globalPosition.dy) / 200.0;
      //   isRecording.value == true && IsPause.value == false
      //       ? _updateZoomLevel(delta)
      //       : null;
      // },
      // onVerticalDragEnd: (details) {
      //   _pauseRecording();
      // },
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isRecording.value ? 100 : 80,
          width: isRecording.value ? 100 : 80,
          child: Stack(
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF978B8B).withOpacity(0.8),
                  )),
              ValueListenableBuilder(
                  valueListenable: recordingDuration,
                  builder: (context, val, child) {
                    return TweenAnimationBuilder<double>(
                        duration: Duration(
                            milliseconds: isRecording.value ? 1100 : 0),
                        tween: Tween<double>(
                          begin: currrentSecond.value.toDouble(),
                          end: currrentSecond.value + 1,
                        ),
                        curve: Curves.linear,
                        builder: (context, value, _) {
                          return Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: isRecording.value ? 100 : 30,
                              width: isRecording.value ? 100 : 30,
                              child: RecordingProgressIndicator(
                                value: value,
                                maxValue: is60Second.value ? 60 : 90,
                              ),
                            ),
                          );
                        });
                  }),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                      height: isRecording.value ? 25 : 64,
                      width: isRecording.value ? 25 : 64,
                      decoration: BoxDecoration(
                        color: isRecording.value
                            ? Colors.white
                            : Colors.red, //Color(0xffe80415),
                        borderRadius: isRecording.value
                            ? BorderRadius.circular(6)
                            : BorderRadius.circular(100),
                      ),
                      child: Obx(
                        () => isRecording.value != true
                            ? const SizedBox()
                            : Icon(
                                IsPause.value
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
