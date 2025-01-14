import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;
  final _navigationStack = <int>[].obs;
  var showChildScreen = false.obs;
  Widget? childScreen;

  void updateIndex(int index) {
    _navigationStack.add(currentIndex.value);
    currentIndex.value = index;
    showChildScreen.value = false; 
  }

  void navigateToChild(Widget screen) {
    childScreen = screen;
    showChildScreen.value = true;
  }

  void navigateBack() {
    if (showChildScreen.value) {
      showChildScreen.value = false; 
    } else if (_navigationStack.isNotEmpty) {
      currentIndex.value = _navigationStack.removeLast();
    }
  }
}
