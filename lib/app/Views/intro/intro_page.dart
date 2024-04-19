import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:watermel/app/core/theme/theme.dart';
import 'package:watermel/app/utils/toast.dart';
import '../../Views/home_bottom_bar/home_page.dart';
import '../../utils/preference.dart';
import '../auth/login_page.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});
  final introKey = GlobalKey<IntroductionScreenState>();

  _onIntroEnd(context) async {
    // try {
    //   var token = await MyStorage.read(MyStorage.token);
    //   var userId = await MyStorage.read(MyStorage.userId);
    //   if (token != null && userId != null && token != "" && userId != "") {
    //     Get.offAll(() => const HomePage());
    //   } else {
    //     Get.offAll(() => LoginPage());
    //   }
    // } catch (e) {
    //   Toaster().warning(e.toString());
    // }
    Get.offAll(() => LoginPage());
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const greenTextStyle = TextStyle(
      fontSize: 20,
      color: primaryColor,
    );
    const normalTextStyle = TextStyle(
      fontSize: 20,
    );

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: IntroductionScreen(
            key: introKey,
            globalBackgroundColor: Colors.white,
            allowImplicitScrolling: true,
            autoScrollDuration: null,
            infiniteAutoScroll: false,
            globalHeader: const SizedBox(
              height: 40,
            ),
            globalFooter: const SizedBox(height: 20),
            pages: [
              PageViewModel(
                title: "",
                bodyWidget: SizedBox(
                  width: Get.width,
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "Give people the power to build community and bring the world closer",
                          style: normalTextStyle,
                        ),
                        TextSpan(
                          text: " together",
                          style: greenTextStyle,
                        ),
                      ],
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis, // or TextOverflow.clip
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
                image: _buildImage('img1.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "",
                bodyWidget: SizedBox(
                  width: Get.width,
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: "You can share your ",
                            style: normalTextStyle),
                        TextSpan(
                          text: "Photos",
                          style: greenTextStyle,
                        ),
                        TextSpan(
                          text: ", Chat with your ",
                          style: normalTextStyle,
                        ),
                        TextSpan(
                          text: "Friends",
                          style: greenTextStyle,
                        ),
                        TextSpan(
                          text: " & can ",
                          style: normalTextStyle,
                        ),
                        TextSpan(
                            text: "Like, Comments & go ",
                            style: normalTextStyle),
                        TextSpan(text: "Live", style: greenTextStyle),
                      ],
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis, // or TextOverflow.clip
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
                image: _buildImage('img2.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "",
                bodyWidget: SizedBox(
                  width: Get.width,
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "Create ", style: greenTextStyle),
                        TextSpan(
                          text: ", watch, and share ",
                          style: normalTextStyle,
                        ),
                        TextSpan(
                          text: "short",
                          style: greenTextStyle,
                        ),
                        TextSpan(
                          text: ", entertaining videos called ",
                          style: normalTextStyle,
                        ),
                        TextSpan(
                          text: "Reels",
                          style: greenTextStyle,
                        ),
                      ],
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis, // or TextOverflow.clip
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
                // bodyWidget: const Text(
                //     ""),
                image: _buildImage('img3.png'),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => _onIntroEnd(context),
            onSkip: () => _onIntroEnd(context),
            showSkipButton: true,
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: false,
            back: const Icon(Icons.arrow_back),
            skip: const Text('Skip',
                style: TextStyle(fontWeight: FontWeight.w600)),
            next: const Icon(Icons.arrow_forward),
            done: const Text('Done',
                style: TextStyle(fontWeight: FontWeight.w600)),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Colors.black,
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
