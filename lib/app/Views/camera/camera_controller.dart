import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watermel/main.dart';

class CameraControllerGetx extends GetxController {
  late CameraController controller;
  Timer? timer;
  RxInt secondsRemaining = 0.obs;
  RxInt currrentSecond = 0.obs;
  RxInt currentCameraIndex = 0.obs;
  RxString finalVideoPath = "".obs;
  RxInt tempSec = 0.obs;

  Future initializeCamera() async {
    controller = CameraController(
      cameras![currentCameraIndex.value],
      ResolutionPreset.veryHigh,
      enableAudio: true,
    );

    await controller.initialize();
    controller.getMaxZoomLevel().then((value) =>
        maxAvailableZoom.value = currentCameraIndex.value == 1 ? 3.0 : value);
    controller
        .getMinZoomLevel()
        .then((value) => minAvailableZoom.value = value);
    update();
  }

  Future<void> startVideoRecording() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String filePath = '$videoDirectory/${DateTime.now()}.mp4';
    finalVideoPath.value = filePath;
    print("Check my recorded video path ==> ${filePath}");
    try {
      await controller.startVideoRecording();
      isRecording.value = true;
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        IsPause.value == true ? null : recordingDuration.value++;
        IsPause.value == true ? null : currrentSecond++;
        tempSec.value = recordingDuration.value;
        if (secondsRemaining.value == 0) {
          // _timer!.cancel();
          stopVideoRecording();
        } else {
          IsPause.value == true ? null : secondsRemaining.value--;
        }
      });
    } on CameraException catch (e) {
      print(e);
    }
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      isRecording.value = false;

      XFile video = await controller.stopVideoRecording();

      print("Check video path ==> ${video.path}");
      timer!.cancel();
      // ignore: use_build_context_synchronously
      // Get.offAll(
      //   () => VideoPage(
      //     videoURL: finalVideoPath.value,
      //     videoFile: File(video.path),
      //   ),
      // );
    } on CameraException catch (e) {
      print(e);
    }
  }

  Future toggleCamera() async {
    currentCameraIndex.value = (currentCameraIndex.value + 1) % cameras!.length;
    CameraDescription newCamera = cameras![currentCameraIndex.value];
    await controller.setDescription(newCamera);
  }

  RxBool IsPause = false.obs;
  void togglePausePLay() async {
    IsPause.value == true ? resumeRecording() : pauseRecording();
  }

  RxDouble minAvailableZoom = 1.0.obs;
  RxDouble maxAvailableZoom = 1.0.obs;
  RxDouble currentZoomLevel = 1.0.obs;

  RxBool isRecording = false.obs;
  ValueNotifier<int> recordingDuration = ValueNotifier(0);

  double zoomLevel = 1.0; // Initial zoom level
  double initialVerticalPosition = 0.0;
  void updateZoomLevel(double delta) async {
    zoomLevel = (zoomLevel + delta).clamp(1.0, maxAvailableZoom.value);
    await controller.setZoomLevel(zoomLevel);
  }

  Future<void> pauseRecording() async {
    print("In side the Pause");

    try {
      await controller.pauseVideoRecording();

      IsPause.value = true;
    } catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> resumeRecording() async {
    print("In side the resume");
    IsPause.value = false;

    try {
      await controller.resumeVideoRecording();
      isRecording.value = true;
    } catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  RxBool is60Second = true.obs;
  switchSecond() {
    is60Second.value = !is60Second.value;
    secondsRemaining.value = is60Second.value == true ? 60 : 90;
  }
}
