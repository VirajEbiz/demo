import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watermel/app/utils/theme/colors.dart';

extension WidgetUtil on Widget {
  Widget shimmer() {
    return Shimmer.fromColors(
        baseColor: MyColors.lightGrayColor,
        highlightColor: MyColors.borderColor,
        direction: ShimmerDirection.ltr,
        child: this);
  }
}
