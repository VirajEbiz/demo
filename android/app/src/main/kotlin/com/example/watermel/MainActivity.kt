package com.watermel.online

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "video_thumbnail"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "generateThumbnail") {
                val videoPath = call.argument<String>("videoPath")
                val filename = call.argument<String>("filename")
                val tempDerectory = call.argument<String>("tempDerectory")
                val thumbnailPath = VideoThumbnailPlugin.generateThumbnail(videoPath!!, filename!!, tempDerectory!!)
                result.success(thumbnailPath)
            } else {
                result.notImplemented()
            }
        }
    }
}

