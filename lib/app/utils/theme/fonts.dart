// using duration for screen change

import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

final bool useMobileLayout =
    MediaQuery.of(Get.context!).size.shortestSide <= 600.0;

class Durations {
  static const Duration fastest = Duration(milliseconds: 150); // 0.15 sec
  static const Duration fast = Duration(milliseconds: 250); // 0.250 sec
  static const Duration medium = Duration(milliseconds: 350); // 0.350 sec
  static const Duration slow = Duration(milliseconds: 700); // 0.700 sec
  static const Duration slower = Duration(milliseconds: 1000); // 1 sec
  static const Duration slowest = Duration(milliseconds: 5000);
}

//font name
class Fonts {
  static const String poppins = "Poppins";
}

//using padding
class Insets {
  // final double   shortesSide1 = MediaQuery.of(Get.context!).size.shortestSide;
  static final double scale1 = useMobileLayout.toString() == "true" ? 1 : 1.5;
  static const double scale = 1;
  static final double i1 = 22 * scale1;
  static const double i2 = 2 * scale;
  static const double i3 = 3 * scale;
  static const double i4 = 4 * scale;
  static const double i5 = 5 * scale;
  static const double i6 = 6 * scale;
  static const double i7 = 7 * scale;
  static const double i8 = 8 * scale;
  static const double i10 = 10 * scale;
  static const double i12 = 12 * scale;
  static const double i13 = 13 * scale;
  static const double i14 = 14 * scale;
  static const double i15 = 15 * scale;
  static const double i16 = 16 * scale;
  static const double i18 = 18 * scale;
  static const double i20 = 20 * scale;
  static const double i21 = 21 * scale;
  static const double i22 = 22 * scale;
  static const double i23 = 23 * scale;
  static const double i25 = 25 * scale;
  static const double i28 = 28 * scale;
  static const double i30 = 30 * scale;
  static const double i32 = 32 * scale;
  static const double i35 = 35 * scale;
  static const double i36 = 36 * scale;
  static const double i40 = 40 * scale;
  static const double i45 = 45 * scale;
  static const double i50 = 50 * scale;
  static const double i55 = 55 * scale;
  static const double i60 = 60 * scale;
  static const double i70 = 70 * scale;
  static const double i100 = 100 * scale;
  static const double i150 = 150 * scale;
}

//using font size
class FontSizes {
  static const double scale = 1;
  static const double s10 = 10 * scale;
  static const double s11 = 11 * scale;
  static const double s12 = 12 * scale;
  static const double s13 = 13 * scale;
  static const double s14 = 14 * scale;
  static const double s15 = 15 * scale;
  static const double s16 = 16 * scale;
  static const double s17 = 17 * scale;
  static const double s18 = 18 * scale;
  static const double s20 = 20 * scale;
  static const double s22 = 22 * scale;
  static const double s25 = 25 * scale;
  static const double s26 = 26 * scale;
  static const double s28 = 28 * scale;
  static const double s30 = 30 * scale;
  static const double s35 = 35 * scale;
  static const double s38 = 38 * scale;
}

//using space
class Sizes {
  static const double hitScale = 0.5;
  static const double s2 = 2;
  static const double s3 = 3;
  static const double s4 = 4;
  static const double s5 = 5;
  static const double s7 = 7;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s15 = 15;
  static double s151 = useMobileLayout.toString() == "true" ? 15 : 25;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s25 = 25;
  static const double s30 = 30;
  static const double s35 = 35;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s43 = 43;
  static const double s45 = 45;
  static const double s50 = 50;
  static const double s55 = 55;
  static const double s60 = 60;
  static const double s65 = 65;
  static const double s75 = 75;
  static const double s80 = 80;
  static const double s100 = 100;
  static const double s110 = 110;
  static const double s120 = 120;
  static const double s130 = 130;
  static const double s140 = 140;
  static const double s150 = 150;
  static const double s160 = 160;
  static const double s180 = 180;
  static const double s195 = 195;
  static const double s200 = 200;
  static const double s225 = 225;
  static const double s251 = 251;
  static const double s260 = 260;
  static const double s270 = 270;
  static const double s320 = 320;
  static const double s450 = 450;
  static const double s460 = 460;
  static const double s500 = 500;
  static const double s550 = 550;
  static const double s600 = 600;
}
