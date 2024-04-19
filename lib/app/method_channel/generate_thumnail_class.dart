import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MyCustomVideoThumbnail {
  static const MethodChannel _channel = MethodChannel('video_thumbnail');

  static Future<String?> generateThumbnail(
      String videoPath, String filename) async {
    final directory = await getTemporaryDirectory();
    try {
      final String? thumbnailPath = await _channel.invokeMethod(
          'generateThumbnail', {
        'videoPath': videoPath,
        'filename': filename,
        'tempDerectory': directory.path
      });
      return thumbnailPath;
    } on PlatformException catch (e) {
      print("Failed to get thumbnail: '${e.message}'.");
      return null;
    }
  }
}
