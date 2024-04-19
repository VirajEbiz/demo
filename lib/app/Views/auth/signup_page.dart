import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watermel/app/core/helpers/helpers.dart';
import 'package:watermel/app/core/theme/theme.dart';
import 'package:watermel/app/data/services/auth_service.dart';
import 'package:watermel/app/utils/theme/colors.dart';
import 'package:watermel/app/utils/theme/fonts.dart';
import 'package:watermel/app/utils/theme/images.dart';
import 'package:watermel/app/widgets/cache_image_widget.dart';
import '../../Views/home_bottom_bar/home_page.dart';
import 'login_controller.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  LoginController controller = Get.put(LoginController());

  String phoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: controller.signupFormKey,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: Get.height * 0.05),
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
                            gallaryPick();
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
                                    imagePathOrUrl: selectedFilePath.value),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                gallaryPick();
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
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Name",
                        labelText: "Full Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Email",
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    IntlPhoneField(
                      validator: (phone) {
                        if (phone == null || !phone.isValidNumber()) {
                          return "Please enter a valid number";
                        }
                        return null;
                      },
                      decoration: textFieldDecoration.copyWith(
                        hintText: "123445678",
                        labelText: "Phone Number",
                        counterText: '',
                      ),
                      dropdownIconPosition: IconPosition.trailing,
                      initialCountryCode: 'US',
                      onChanged: (phone) {
                        phoneNumber = phone.completeNumber;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: true,
                      decoration: textFieldDecoration.copyWith(
                        hintText: "Password",
                        labelText: "Password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: signUpUser,
                      child: Obx(
                        () => controller.registerLoading.value
                            ? LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white, size: 20)
                            : const Text("Sign Up"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("OR"),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.white,
                          ),
                          foregroundColor:
                              MaterialStatePropertyAll(primaryColor)),
                      onPressed: () async {
                        controller.signInWithApple(context);
                      },
                      child: Obx(
                        () => controller.loading.value
                            ? LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white, size: 20)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    MyImageURL.appleLogo,
                                    height: 35,
                                    width: 35,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Continue with Apple"),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.white,
                          ),
                          foregroundColor:
                              MaterialStatePropertyAll(primaryColor)),
                      onPressed: () async {
                        await controller.googleSigninAPI(context);
                      },
                      child: Obx(
                        () => controller.loading.value
                            ? LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white, size: 20)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/google.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Continue with Google"),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffF4F4F4),
              ),
              width: Get.width,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already have an account?  "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => LoginPage());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signUpUser() async {
    // if (selectedFilePath.value == "") {
    //   showMessage("Please select an image", type: "error");
    //   return;
    // } else
    if (controller.signupFormKey.currentState!.validate()) {
      controller.registerLoading.value = true;
      await AuthMethods().SignUpUserAPI(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        phone: phoneNumber,
        file: selectedFilePath.value,
      );
      controller.registerLoading.value = false;
    }
  }

  final picker = ImagePicker();
  RxString selectedFilePath = "".obs;

  gallaryPick() async {
    var result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      Get.back();
      selectedFilePath.value = result.path;
    }
  }
}
