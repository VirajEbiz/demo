import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:light_compressor/light_compressor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/method_channel/generate_thumnail_class.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:dio/dio.dart' as fm;
import 'package:watermel/app/utils/theme/print.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:dio/dio.dart' as dio;
import '../../Views/home_bottom_bar/home_page.dart';
import '../../utils/theme/images.dart';
import 'dart:io';

class CreateFeedController extends GetxController {
  List<Map<String, dynamic>> buttonList = [];

  void onInit() {
    super.onInit();
    buttonList = [
      {
        "ButtonName": "Read",
        "ButtonIcon": MyImageURL.readText,
        "IsSelected": 0
      },
      {"ButtonName": "Watch", "ButtonIcon": MyImageURL.watch, "IsSelected": 1},
      {
        "ButtonName": "Podcast",
        "ButtonIcon": MyImageURL.podcast,
        "IsSelected": 2
      },
    ];
  }

  int selectedIndex = 0;
  RxBool isSelected = false.obs;
  RxString isSelectedtype = "Read".obs;
  RxBool isFeedPrivate = false.obs;
  RxString selectedFilePath = "".obs;
  RxString selectedThumbnailPath = "".obs;
  RxString selectedFileFramePath = "".obs;
  RxBool audioFilePlay = true.obs;
  RxBool videoRecord = false.obs;
  dynamic pickedFile = "";
  int maxSize = 20 * 1024 * 1024; //20 MB
  int minSize = 500 * 1024; // 1 MB

  Future<void> pickFile({fromVideo, forThumbnail}) async {
    List<String> allowedExtensionsList = <String>[];
    if (selectedIndex == 0) {
      allowedExtensionsList.clear();
      allowedExtensionsList = ['jpg', 'jpeg', 'png'];
    } else if (selectedIndex == 1 || fromVideo == true) {
      allowedExtensionsList.clear();
      allowedExtensionsList = ['mp4', 'avi', 'mkv', 'mov'];
    } else if (selectedIndex == 2) {
      allowedExtensionsList.clear();
      allowedExtensionsList = [
        'mp3',
        'wav',
        'ogg',
        'aac',
      ];
    }
    try {
      FilePickerResult? result;
      XFile? result1;
      XFile? thumnailFile;

      if (forThumbnail == true) {
        log("In side the thumbnail ==> ");
        thumnailFile = await picker.pickImage(source: ImageSource.gallery);
      } else {
        if (selectedIndex == 0) {
          result1 = await picker.pickImage(source: ImageSource.gallery);
        } else if (selectedIndex == 1 || fromVideo == true) {
          result1 = await picker.pickVideo(source: ImageSource.gallery);
          Platform.isAndroid
              ? await generateThumbnailAndroid(result1!.path)
              : await generateThumbnail(result1!.path);
        } else {
          result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions:
                  allowedExtensionsList // Add more audio file extensions if needed
              );
        }
      }

      if (result1 != null || result != null || thumnailFile != null) {
        if (forThumbnail == true) {
          selectedThumbnailPath.value = thumnailFile!.path;
          log("Selected thumnail path ==> ${selectedThumbnailPath.value}");
        } else {
          if (selectedIndex == 0) {
            selectedFilePath.value = result1!.path;
            pickedFile = result1;
          } else if (selectedIndex == 1 || fromVideo == true) {
            showLoader();
            File file = File(await getCompresssedVideo(result1!.path) ?? "");
            int sizeInBytes = await file.length();
            double sizeInKB = sizeInBytes / 1024;
            if (sizeInBytes > maxSize) {
              Toaster().warning("File size must be between 500 KB to 20 MB");
              hideLoader();
              return;
            } else {
              selectedFilePath.value = file.path;

              pickedFile = result1;
              selectedFilePath.value == "" ? null : hideLoader();
            }
          } else {
            if (result!.files.single.size > maxSize) {
              Toaster().warning("File size must be between 500 KB to 20 MB");
              return;
            } else {
              selectedFilePath.value = result.files.single.path!;
              log("Check log ==> ${selectedFilePath.value}");
            }
          }
        }
      } else {}
    } catch (e) {
      MyPrint(tag: "Error picking audio:", value: "$e");
    }
  }

  Rx<String> generatedThumNail = "".obs;

  Future<String?> generateThumbnail(String videoPath) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      // maxWidth: 200,
      quality: 0,
    );

    return _saveImage(File(thumbnail.toString()));
  }

  Future<String?> generateThumbnailAndroid(String videoPath) async {
    String? thumbnailPath = await MyCustomVideoThumbnail.generateThumbnail(
        videoPath, "thumbnailFilename");
    generatedThumNail.value = thumbnailPath!;
  }

  Future<String> _saveImage(File image) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String imagePath = '${directory.path}/image.png';

    final File localImage = await image.copy(imagePath);
    generatedThumNail.value = localImage.path;
    return generatedThumNail.value;
  }

  Future<int> getImageFileSize(File file) async {
    int fileSize = file.lengthSync();
    print("File Size is: $fileSize");
    return fileSize;
  }

  final picker = ImagePicker();
  cameraPick() async {
    var result = await picker.pickImage(source: ImageSource.camera);
    if (result != null) {
      // Get.back();
      selectedFilePath.value = result.path;
      print("Check selected path ==> ${selectedFilePath.value}");
    }
  }

  gallaryPick() async {
    var result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      Get.back();
      selectedFilePath.value = result.path;
    }
  }

  String SplitFilePath(fileName) {
    List<String> parts = fileName.split('.');
    String fileExtension = "";
    if (parts.length > 1) {
      String fileExtension = parts.last;

      return fileExtension;
    } else {
      return "";
    }
  }

  TextEditingController captionController = TextEditingController();

  //! COMPRESSVIDEO
  final LightCompressor _lightCompressor = LightCompressor();

  Future<String?> getCompresssedVideo(inputPath) async {
    final Result response = await _lightCompressor.compressVideo(
      path: inputPath,
      videoQuality: VideoQuality.very_high,
      isMinBitrateCheckEnabled: false,
      video: Video(videoName: "compressedVideo.mp4"),
      android: AndroidConfig(isSharedStorage: false, saveAt: SaveAt.Downloads),
      ios: IOSConfig(saveInGallery: false),
    );
    if (response is OnSuccess) {
      selectedFilePath.value = response.destinationPath;
      File file = File(selectedFilePath.value);
      int sizeInBytes = await file.length();
      if (sizeInBytes > maxSize) {
        Toaster().warning("File size must be between 500 KB to 20 MB");
      }

      return sizeInBytes > maxSize ? null : selectedFilePath.value;
      // use the file
    } else if (response is OnFailure) {
    } else if (response is OnCancelled) {}
  }

  Future CreateNewFeed(String type, fromHome) async {
    try {
      showLoader();
      // var formData = fm.FormData.fromMap({
      //   if (selectedFilePath.value != "")
      //     'files': [
      //       await fm.MultipartFile.fromFile(selectedFilePath.value,
      //           filename: 'profileImage.jpeg')
      //     ],
      //   'caption': captionController.text == "" ? "" : captionController.text,
      //   'is_private': isFeedPrivate.value.toString(),
      //   'type': isSelectedtype.value.toString().toLowerCase()
      // });
      dio.FormData? formData1;
      if (selectedFilePath.value != "") {
        Map<String, dynamic> jsonDB = {
          'caption': captionController.text == "" ? "" : captionController.text,
          'is_private': isFeedPrivate.value.toString(),
          'type': isSelectedtype.value.toString().toLowerCase()
        };
        jsonDB['files'] = [
          await fm.MultipartFile.fromFile(selectedFilePath.value)
        ];
        if (selectedThumbnailPath.value == "" &&
            generatedThumNail.value == "") {
        } else {
          jsonDB['thumbnail'] = [
            await fm.MultipartFile.fromFile(selectedThumbnailPath.value == ""
                ? generatedThumNail.value
                : selectedThumbnailPath.value)
          ];
        }

        log("generated thumbailPath ::222: => ${generatedThumNail.value}");
        log("generated thumbailPath ::222: => ${jsonDB.toString()}");

        formData1 = dio.FormData.fromMap(jsonDB);
      } else {
        Map<String, dynamic> jsonDB = {
          'caption': captionController.text == "" ? "" : captionController.text,
          'is_private': isFeedPrivate.value.toString(),
          'type': isSelectedtype.value.toString().toLowerCase()
        };
        log("request Param== ===${jsonDB.toString()}");
        formData1 = dio.FormData.fromMap(jsonDB);
      }

      var response = await ApiManager()
          .call("$baseUrl$createFeed", formData1, ApiType.post);
      hideLoader();
      if (response.status == "success") {
        selectedFilePath.value = "";
        captionController.clear();
        // if (type == "draft") {
        //   return true;
        // }
        fromHome == true
            ? await Get.offAll(() => HomePage(pageIndex: 0))
            : null;
      } else if (response.code == "000") {
        await CreateNewFeed(type, fromHome);
      } else {
        Toaster().warning(response.message.toString());
      }
    } catch (e) {
      hideLoader();
      MyPrint(tag: "catch", value: e.toString());
    }
  }

  Future<void> pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    // You can use pickedFile.path to get the path of the selected video file
    // Process the video file as needed (e.g., display it, upload it, etc.)
  }

  Future<void> pickImageFromCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      selectedFilePath.value = pickedFile.path;
    }
  }
}
