import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:watermel/main.dart';

class MyStorage {
  // static final _storage = FlutterSecureStorage();

  static const String IntroductionFlag = "IntroductionFlag";
  static const String userProfile = "userProfile";
  // static const String userProfilePicture = "userProfile";
  static const String userName = "userName";
  static const String token = "token";
  static const String userId = "userId";
  static const String email = "email";
  static const String mobile = "mobile";
  static const String socialType = "socialType";
  static const String notificationFlag = "notificationFlag";
  static const String mobileCode = "mobileCode";
  static const String draftreadlist = "draftreadlist";
  static const String draftwatchlist = "draftwatchlist";
  static const String draftpodcastlist = "draftpodcastlist";
  static const String notificationStatus = "notificationStatus";
  static const String displayName = "displayName";
  static const String refreshToken = "refreshToken";

  static const String Accout_IsPrivate = "Accout_IsPrivate";

  static dynamic read(String name) {
    return storage.read(name);
    // return info != null ? json.decode(info) : info;
  }

  static Future<dynamic> write(String key, dynamic value) async {
    //  dynamic object = value != null ? json.encode(value) : value;
    await storage.write(key, value);

    //  return await _storage.write(key, object);
  }
}
