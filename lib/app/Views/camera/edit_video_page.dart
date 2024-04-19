import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';
import 'package:watermel/app/Views/create_new_feed/create_feed_controller.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/theme/colors.dart';

class EditVideoPage extends StatefulWidget {
  final String filePath;
  const EditVideoPage({super.key, required this.filePath});

  @override
  State<EditVideoPage> createState() => _EditVideoPageState();
}

class _EditVideoPageState extends State<EditVideoPage> {
  final double height = 60;

  late final VideoEditorController _controller = VideoEditorController.file(
    File(widget.filePath),
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(minutes: 1),
  );

  @override
  void initState() {
    super.initState();
    _controller
        .initialize()
        .then((_) => setState(() {}))
        .catchError((e) => Get.back(), test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() async {
    await _controller.dispose();
    super.dispose();
  }

  Future<void> _exportVideo() async {
    try {
      final Duration start = _controller.startTrim;
      final Duration end = _controller.endTrim;

      final String inputPath = widget.filePath;
      final Directory tempDir = await getTemporaryDirectory();
      final String outputPath = '${tempDir.path}/output.mp4';

      File output = File(outputPath);
      if (output.existsSync()) {
        output.deleteSync();
      }

      final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
      // final int returnCode = await flutterFFmpeg.execute(
      //   '-i $inputPath -ss ${start.inSeconds} -t ${end.inSeconds} -c copy $outputPath',
      // );
      const String compressionSettings =
          '-vf scale=720:-1 -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k';
      final int returnCode = await flutterFFmpeg.execute(
          '-i $inputPath -ss ${start.inSeconds} -t ${end.inSeconds} $compressionSettings $outputPath');

      if (returnCode == 0) {
        CreateFeedController createFeedController =
            Get.put(CreateFeedController());
        // createFeedController.selectedFilePath.value = outputPath;
        showLoader();
        await createFeedController.getCompresssedVideo(outputPath);
        await createFeedController.generateThumbnail(outputPath);
        hideLoader();
        Get.back();
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Failed to export video',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: MyColors.greenColor,
          colorText: MyColors.whiteColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export video: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: MyColors.greenColor,
        colorText: MyColors.whiteColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        body: _controller.initialized
            ? SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _topNavBar(),
                        Expanded(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Expanded(
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CropGridViewer.preview(
                                              controller: _controller),
                                          AnimatedBuilder(
                                            animation: _controller.video,
                                            builder: (_, __) => AnimatedOpacity(
                                              opacity:
                                                  _controller.isPlaying ? 0 : 1,
                                              duration: kThemeAnimationDuration,
                                              child: GestureDetector(
                                                onTap: _controller.video.play,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CoverViewer(controller: _controller)
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      // const TabBar(
                                      //   tabs: [
                                      //     Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         children: [
                                      //           Padding(
                                      //               padding: EdgeInsets.all(5),
                                      //               child: Icon(
                                      //                   Icons.content_cut)),
                                      //           Text('Trim')
                                      //         ]),
                                      //     Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         Padding(
                                      //             padding: EdgeInsets.all(5),
                                      //             child:
                                      //                 Icon(Icons.video_label)),
                                      //         Text('Cover')
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                      Expanded(
                                        child: Column(
                                          children: _trimSlider(),
                                        ),
                                      ),
                                      // Expanded(
                                      //   child: TabBarView(
                                      //     physics:
                                      //         const NeverScrollableScrollPhysics(),
                                      //     children: [
                                      //       Column(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         children: _trimSlider(),
                                      //       ),
                                      //       _coverSelection(),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
      onPopInvoked: (didPop) => false,
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                tooltip: 'Leave editor',
              ),
            ),
            const VerticalDivider(endIndent: 22, indent: 22),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                icon: const Icon(Icons.rotate_left),
                tooltip: 'Rotate unclockwise',
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.right),
                icon: const Icon(Icons.rotate_right),
                tooltip: 'Rotate clockwise',
              ),
            ),
            const VerticalDivider(endIndent: 22, indent: 22),
            Expanded(
              child: IconButton(
                onPressed: _exportVideo,
                icon: const Icon(Icons.check),
                tooltip: 'Save',
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _controller.video,
        ]),
        builder: (_, __) {
          final int duration = _controller.videoDuration.inSeconds;
          final double pos = _controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt()))),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: _controller.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(_controller.startTrim)),
                  const SizedBox(width: 10),
                  Text(formatter(_controller.endTrim)),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      )
    ];
  }

  // Widget _coverSelection() {
  //   return SingleChildScrollView(
  //     child: Center(
  //       child: Container(
  //         margin: const EdgeInsets.all(15),
  //         child: CoverSelection(
  //           controller: _controller,
  //           size: height + 10,
  //           quantity: 8,
  //           selectedCoverBuilder: (cover, size) {
  //             return Stack(
  //               alignment: Alignment.center,
  //               children: [
  //                 cover,
  //                 Icon(
  //                   Icons.check_circle,
  //                   color: const CoverSelectionStyle().selectedBorderColor,
  //                 )
  //               ],
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
