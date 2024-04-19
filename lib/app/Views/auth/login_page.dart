import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watermel/app/Views/auth/signup_page.dart';
import 'package:watermel/app/core/helpers/helpers.dart';
import 'package:watermel/app/core/theme/theme.dart';
import 'package:watermel/app/data/services/auth_service.dart';
import 'package:watermel/app/utils/loader.dart';
import 'package:watermel/app/utils/theme/images.dart';
import '../../Views/home_bottom_bar/home_page.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  LoginController controller = Get.put(LoginController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: controller.loginFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/watermel.png",
                        // height: 140,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFieldDecoration.copyWith(
                          hintText: "Phone number, email or username",
                          labelText: "Phone number, email or username",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
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
                        onPressed: loginUser,
                        child: const Text("Login"),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffF4F4F4),
              ),
              width: Get.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't Have Account?  "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => SignUpPage());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void loginUser() async {
    if (controller.loginFormKey.currentState!.validate()) {
      log("Check passing data ==> ${_emailController.text}");
      log("Check passing data ==> ${_passwordController.text}");
      showLoader();
      await AuthMethods().logInUser(
          email: _emailController.text, password: _passwordController.text);
    }
  }
}
