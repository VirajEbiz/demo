import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:watermel/app/core/helpers/contants.dart';
import 'package:watermel/app/core/theme/theme.dart';
import 'package:watermel/app/Views/user_profile/user_profile_controller.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import 'package:watermel/app/widgets/common_popup.dart';
import 'package:watermel/app/widgets/common_text.dart';
import 'package:watermel/app/widgets/common_widget.dart';

import '../../../main.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key, required this.userName});
  String? userName;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserProfileController userProfileController =
      Get.find<UserProfileController>();

  @override
  void initState() {
    onloadProfile();
    super.initState();
  }

  onloadProfile() async {
    userProfileController.displayNameController.text = widget.userName ?? "";
    userProfileController.userNameController.text =
        await MyStorage.read(MyStorage.userName);
    userProfileController.isPrivate.value =
        storage.read(MyStorage.Accout_IsPrivate) ?? false;
    userProfileController.selectedFilePath.value = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarPreferredSize("Edit Profile", true),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/watermel.png",
                      // height: 140,
                    ),
                    const SizedBox(height: 32),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            userProfileController.selectImage();
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: MyColors.grayColor,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Insets.i100),
                              child: Obx(
                                () => CustomImageView(
                                    isProfilePicture: true,
                                    fit: BoxFit.cover,
                                    radius: Insets.i1,
                                    imagePathOrUrl: userProfileController
                                                .selectedFilePath.value !=
                                            ""
                                        ? userProfileController
                                            .selectedFilePath.value
                                        : "$baseForImage${userProfileController.userProfileData.value.profilePicture}"),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                userProfileController.selectImage();
                              },
                              child: SvgPicture.asset(
                                MyImageURL.watermelImage,
                                height: Insets.i25,
                                // color: MyColors.whiteColor,
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    /*    TextFormField(
                      controller: userProfileController.userNameController,
                      keyboardType: TextInputType.name,
                      readOnly: true,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          top: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        fillColor: MyColors.whiteColor,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.borderColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors.borderColor,
                          ),
                        ),
                      ),
                      cursorColor: MyColors.grayColor,
                    ),*/
                    TextFormField(
                      controller: userProfileController.userNameController,
                      keyboardType: TextInputType.name,
                      readOnly: true,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Name",
                        labelText: "User Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please User Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: userProfileController.displayNameController,
                      keyboardType: TextInputType.name,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Name",
                        labelText: "Display Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Unique Name";
                        }
                        return null;
                      },
                    ),
                    // const SizedBox(
                    //   height: 24,
                    // ),
                    // TextFormField(
                    //   controller: userProfileController.userNameController,
                    //   keyboardType: TextInputType.emailAddress,
                    //   decoration: textFieldDecoration.copyWith(
                    //     hintText: "User Name",
                    //     labelText: "User Name",
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Please enter your user name";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 24),
                    // TextFormField(
                    //   keyboardType: TextInputType.visiblePassword,
                    //   controller: userProfileController.stateController,
                    //   obscureText: true,
                    //   decoration: textFieldDecoration.copyWith(
                    //     hintText: "State",
                    //     labelText: "State",
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Please enter your State";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 24),
                    // TextFormField(
                    //   keyboardType: TextInputType.visiblePassword,
                    //   controller: userProfileController.cityController,
                    //   obscureText: true,
                    //   decoration: textFieldDecoration.copyWith(
                    //     hintText: "city",
                    //     labelText: "city",
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Please enter your city";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 24),
                    // TextFormField(
                    //   keyboardType: TextInputType.visiblePassword,
                    //   controller: userProfileController.postcodeController,
                    //   obscureText: true,
                    //   decoration: textFieldDecoration.copyWith(
                    //     hintText: "Postcode",
                    //     labelText: "Postcode",
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Please enter your Postcode";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 24),
                    // TextFormField(
                    //   keyboardType: TextInputType.visiblePassword,
                    //   controller: userProfileController.bioController,
                    //   obscureText: true,
                    //   decoration: textFieldDecoration.copyWith(
                    //     hintText: "bio",
                    //     labelText: "bio",
                    //   ),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Please enter your bio";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 24),
                    settingTile(MyImageURL.privacy, MyImageURL.ontoggle,
                        "Private Account", () {
                      //Get.to(() => SearchHomeScreen());
                    }),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        commonDialog(
                          context,
                          "Edit Profile",
                          "Are you sure you want to edit your profile?",
                          onTap: () async {
                            await userProfileController.EditProfile();

                            Get.back();
                          },
                        );
                      },
                      child: const Text("Edit Profile"),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingTile(
      String asset, String asset1, String title, void Function() onTap,
      {bool isLineIcon = true}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
              padding: EdgeInsets.only(
                  left: Get.width * .00,
                  bottom: Get.height * .015,
                  top: Get.height * .015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        asset,
                        color: MyColors.blackColor,
                      ),
                      SizedBox(width: Get.width * 0.06),
                      MyText(
                        txtAlign: TextAlign.center,
                        text_name: title,
                        txtcolor: MyColors.blackColor,
                        myFont: Fonts.poppins,
                        fontWeight: FontWeight.w400,
                        txtfontsize: FontSizes.s14,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      userProfileController.isPrivate.value =
                          !userProfileController.isPrivate.value;
                    },
                    child: Obx(
                      () => SvgPicture.asset(
                        userProfileController.isPrivate.value
                            ? asset1
                            : MyImageURL.offtoggle,
                      ),
                    ),
                  )
                ],
              )),
        ),
      ],
    );
  }
}
