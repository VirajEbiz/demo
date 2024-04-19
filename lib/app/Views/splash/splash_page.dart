import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watermel/app/Views/auth/login_controller.dart';
import 'package:watermel/app/Views/auth/login_page.dart';
import 'package:watermel/app/Views/home_bottom_bar/home_page.dart';
import 'package:watermel/app/Views/intro/intro_page.dart';
import 'package:watermel/app/utils/preference.dart';
import 'package:watermel/app/utils/toast.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTime();
  }

  setTime() {
    Future.delayed(const Duration(seconds: 3), () {
      loginController.isNotification == true ? null : onNavigation();
    });
  }

  onNavigation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var token = await MyStorage.read(MyStorage.token);
      var userId = await MyStorage.read(MyStorage.userId);
      if (token != null && userId != null && token != "" && userId != "") {
        Get.offAll(() => HomePage());
      } else {
        prefs.getBool('first_run1') ?? true == true
            ? Get.offAll(() => IntroPage())
            : Get.offAll(() => LoginPage());
        prefs.setBool('first_run1', false);
      }
    } catch (e) {
      Toaster().warning(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Center(
          child: Image.asset("assets/images/Splash_screen.jpg"),
        ),
      ),
    );
  }
}
