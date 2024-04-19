import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as fm;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:watermel/app/Views/user_profile/profile_detail_screen.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/data/services/auth_service.dart';
import 'package:watermel/app/models/detail_post_data_model.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/print.dart';
import 'package:watermel/app/utils/toast.dart';
import 'package:watermel/app/widgets/common_methods.dart';
import 'package:watermel/firebase_options.dart';
import 'package:crypto/crypto.dart';
import 'package:watermel/main.dart';

class LoginController extends GetxController {
  RxBool loading = false.obs;
  RxBool registerLoading = false.obs;

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  Rx<Uint8List?> userImage = Rx<Uint8List?>(null);
  bool isNotification = false;

  @override
  void onInit() {
    super.onInit();
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleLogin = GoogleSignIn();

  //! GOOGE LOGIN
  Future googleSigninAPI(context) async {
    await _googleLogin.signOut();

    final AuthCredential credential;
    showLoader();
    try {
      try {
        GoogleSignInAccount? googleUser = await _googleLogin.signIn();

        GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final u.User? user = (await auth.signInWithCredential(credential)).user;
        var userdetails;
        if (user != null) {
          Map<String, dynamic> jsonDB = {
            "device_token": await CommonMethod().deviceToken(),
            "sub": user.uid,
            "email": user.email,
            "email_verified": user.emailVerified,
            "at_hash": '',
            "iat": '',
            "exp": '',
            "sso_type": 'google'
          };
          MyPrint(tag: "GOOGLE LOGIN REQ PARMS", value: jsonDB.toString());
          hideLoader();
          await signinWithSocialMedia(jsonDB);
        } else {
          hideLoader();
          update();
        }
      } catch (e) {
        hideLoader();
      }
    } on Exception catch (e) {
      hideLoader();

      update();
    }
  }

  //! SOCIAL BACKEND LOGIN
  Future signinWithSocialMedia(jsonDB) async {
    storage.write(MyStorage.token, null);
    storage.erase();
    String myUrl = "$baseUrl$googleLoginAPI";
    {
      try {
        showLoader();
        var response = await ApiManager().call(myUrl, jsonDB, ApiType.post);
        if (response.status == "success") {
          await responseStorage(response.data);
          Toaster().warning(response.message);
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

//! APPLE LOGIN
  void signInWithApple(context) async {
    try {
      await auth.signOut();
      update();
      showLoader();
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      final u.User? user =
          (await auth.signInWithCredential(oauthCredential)).user;

      if (user != null) {
        Map<String, dynamic> jsonDB = {
          "device_token": await CommonMethod().deviceToken(),
          "sub": user.uid,
          "email": user.email,
          "email_verified": user.emailVerified,
          "is_private_email": false,
          "sso_type": "apple",
          "exp": "",
          "iat": "",
          "at_hash": "",
          "id_token": oauthCredential.idToken,
          "auth_time": "",
          "expires_in": "",
          "token_type": "",
          "access_token": oauthCredential.accessToken,
          "refresh_token": user.refreshToken,
          "nonce_supported": true,
        };
        MyPrint(tag: "APPLE LOGIN REQ PARMS", value: jsonDB.toString());

        hideLoader();
        await signinWithSocialMedia(jsonDB);
      } else {
        hideLoader();
        update();
      }
    } on Exception catch (e) {
      hideLoader();

      update();
    }
  }

  Rx<ProfilePostDetailData> profilePostDetails = ProfilePostDetailData().obs;
  RxBool isLoading = true.obs;
  getUserPotDetailsAPI(feedId, fromMain, isContainComment) async {
    isLoading.value = true;
    String myUrl = "$baseUrl$getSpecifiPostDetails$feedId";
    log("21262126 - 26");
    {
      try {
        showLoader();
        isLoading.value = true;
        var response = await ApiManager().call(myUrl, "", ApiType.get);
        if (response.status == "success") {
          profilePostDetails.value =
              ProfilePostDetailData.fromJson(response.data);
          log("Check data ===> 1111$myUrl");

          if (profilePostDetails.value.mediaData?.first.image != "") {
            log("21262126 - 1 ${profilePostDetails.value.mediaData!.first.image}");

            Get.to(() => ProfileFeedDetailScreen(
                  createTime: profilePostDetails.value.createdAt,
                  containComment: isContainComment,
                  fromMain: fromMain,
                  myReaction: profilePostDetails.value.myReaction,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id,
                  isBookmark: profilePostDetails.value.bookmark,
                  likeCount: profilePostDetails.value.reactionsCount,
                  mediaType: 0,
                  mediaURL: profilePostDetails.value.mediaData!.isEmpty ||
                          profilePostDetails.value.mediaData!.first.image ==
                              null ||
                          profilePostDetails.value.mediaData?.first.image == ""
                      ? ""
                      : profilePostDetails.value.mediaData!.first.image,
                  thumbnail: profilePostDetails.value.thumbURl == null ||
                          profilePostDetails.value.thumbURl == ""
                      ? ""
                      : "$baseUrl${profilePostDetails.value.thumbURl}",
                  userName: profilePostDetails.value.user?.username ?? "",
                  userProfile: profilePostDetails
                      .value.user?.userprofile!.profilePicture,
                ));
          } else if (profilePostDetails.value.mediaData!.first.video != "") {
            log("21262126 - 2 $baseUrl${profilePostDetails.value.mediaData!.first.video}");

            Get.to(() => ProfileFeedDetailScreen(
                  createTime: profilePostDetails.value.createdAt,
                  containComment: isContainComment,
                  fromMain: fromMain,
                  myReaction: profilePostDetails.value.myReaction,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id,
                  isBookmark: profilePostDetails.value.bookmark,
                  likeCount: profilePostDetails.value.reactionsCount,
                  mediaType: 1,
                  mediaURL: profilePostDetails.value.mediaData!.isEmpty ||
                          profilePostDetails.value.mediaData!.first.video ==
                              null ||
                          profilePostDetails.value.mediaData?.first.video == ""
                      ? ""
                      : "$baseUrl${profilePostDetails.value.mediaData!.first.video}",
                  thumbnail: profilePostDetails.value.thumbURl == null ||
                          profilePostDetails.value.thumbURl == ""
                      ? ""
                      : "$baseUrl${profilePostDetails.value.thumbURl}",
                  userName: profilePostDetails.value.user?.username ?? "",
                  userProfile: profilePostDetails
                      .value.user?.userprofile!.profilePicture,
                ));
          } else if (profilePostDetails.value.mediaData!.first.audio != "") {
            log("21262126 - 3 $baseUrl${profilePostDetails.value.mediaData!.first.audio}");

            Get.to(() => ProfileFeedDetailScreen(
                  createTime: profilePostDetails.value.createdAt,
                  containComment: isContainComment,
                  fromMain: fromMain,
                  myReaction: profilePostDetails.value.myReaction,
                  shareURL: profilePostDetails.value.shareURl,
                  caption: profilePostDetails.value.caption,
                  commentCount: profilePostDetails.value.commentsCount,
                  displayname:
                      profilePostDetails.value.user?.userprofile?.displayName ??
                          "",
                  feedID: profilePostDetails.value.id,
                  isBookmark: profilePostDetails.value.bookmark,
                  likeCount: profilePostDetails.value.reactionsCount,
                  mediaType: 2,
                  mediaURL: profilePostDetails.value.mediaData!.isEmpty ||
                          profilePostDetails.value.mediaData!.first.audio ==
                              null ||
                          profilePostDetails.value.mediaData?.first.audio == ""
                      ? ""
                      : "$baseUrl${profilePostDetails.value.mediaData!.first.audio}",
                  thumbnail: profilePostDetails.value.thumbURl == null ||
                          profilePostDetails.value.thumbURl == ""
                      ? ""
                      : "$baseUrl${profilePostDetails.value.thumbURl}",
                  userName: profilePostDetails.value.user?.username ?? "",
                  userProfile: profilePostDetails
                      .value.user?.userprofile!.profilePicture,
                ));
          }

          isLoading.value = false;
        } else {
          Toaster().warning(response.message);
        }
      } catch (e, f) {
        hideLoader();
        log("Chek data ==> ${e}, $f ");
        isLoading.value = false;
        MyPrint(tag: "catch", value: e.toString());
      }
    }
  }
}
