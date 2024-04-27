import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  PageController? pageController;
  int currentTap = 0;

  onPageChanged(int index) {
    currentTap = index;
    update();
  }

  animateToPage(int index) {
    currentTap = index;
    pageController!.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    update();
  }
}
