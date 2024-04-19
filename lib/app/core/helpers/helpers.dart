import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  return null;
}

// Save  and clear auth token
Future<void> saveAuthToken(String token) async {
  if (kIsWeb) {
    // Use shared_preferences for web
    final preference = await SharedPreferences.getInstance();
    await preference.setString('auth_token', token);
  } else {
    // Use flutter_secure_storage for mobile (Android/iOS)
    const storage = FlutterSecureStorage();
    await storage.write(key: 'auth_token', value: token);
  }
}

Future<String?> getAuthToken() async {
  if (kIsWeb) {
    final preference = await SharedPreferences.getInstance();
    return preference.getString('auth_token');
  } else {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }
}

Future<bool> isAuthorized() async {
  if (kIsWeb) {
    final preference = await SharedPreferences.getInstance();
    return preference.containsKey('auth_token');
  } else {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');
    return token != null;
  }
}

void showMessage(String text, {String type = "success"}) {
  if (type == "success") {
    Get.snackbar("Success", text,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  } else {
    Get.snackbar("Error", text,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }
}
