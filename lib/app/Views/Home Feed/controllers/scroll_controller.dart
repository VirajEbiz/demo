import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScrollController extends GetxController {
  final scrollController = ScrollController();

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
